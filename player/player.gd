extends CharacterBody2D
class_name Player

@export var MAX_SPEED :float = 1500.0
@export var DECELERATION :float = 100.0
@export var melee_hit_box:ShapeCast2D
@export var MELEE_ATTACK_SPEED:float
@export var melee_cooldown:Timer
@export var HEALTH:float = 5.0

signal ON_DEATH

@onready var DamageCooldown:Timer = $DamageCooldown
@onready var footsteps:AudioStreamPlayer2D = $FootstepSound
@onready var damage_taken_sound:AudioStreamPlayer2D = $DamageTakenSound

var canTakeDamage:bool

@export var SPEEDSTER_TIMER : float = 10.0
@export var NOIR_TIMER : float = 10.0

var canAttack:bool
var direction: Vector2
var tookStep:bool

# Player weapons
var weapons : Array[Weapon]

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox
@onready var particles: GPUParticles2D= $GPUParticles2D
var particle_material: ParticleProcessMaterial

@onready var arm_sprite: AnimatedSprite2D = $ArmJoint/SpriteArm
@onready var arm_joint: Node2D = $ArmJoint

@onready var muzzle_sprite: AnimatedSprite2D = $ArmJoint/SpriteMuzzleFlash


func _ready() -> void:
	hitbox.body_entered.connect(_on_damage_source_enter)
	DamageCooldown.timeout.connect(_on_timeout)
	footsteps.finished.connect(_on_footstep_finished)
	canAttack = true
	canTakeDamage = true
	tookStep = true
	particle_material = particles.process_material

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	# If direction is not null, change velocity
	if not direction.is_zero_approx():
		velocity = direction * MAX_SPEED
	else:
		velocity = Vector2.ZERO * move_toward(velocity.length(), 0.0, DECELERATION * delta)
		
	if velocity.length() > 0:
		if(tookStep):
			footsteps.play()
			tookStep = false
		
		sprite.play("walk")
		if velocity.x < 0:
			sprite.flip_h = true
			particle_material.direction.x = -1
		else:
			sprite.flip_h = false
			particle_material.direction.x = 1
		particles.emitting = true
	else:
		sprite.play("idle")
		particles.emitting = false
	move_and_slide()
	
func _process(delta):
	var attack_direction = calculate_attack_direction()
	arm_joint.rotation = attack_direction.angle()
	if attack_direction.angle() > PI/2 or attack_direction.angle() < -PI/2:
		arm_sprite.flip_v = true
		arm_sprite.position.y = 0
		muzzle_sprite.position.y = 18
	else:
		arm_sprite.flip_v = false
		arm_sprite.position.y = 0
		muzzle_sprite.position.y = -18

func _input(event):
	if event.is_action_pressed("attack"):
		arm_sprite.play("fire")
		muzzle_sprite.visible = true
		muzzle_sprite.play("fire")
	elif event.is_action_released("attack"):
		arm_sprite.play("idle")
		muzzle_sprite.visible = false

func calculate_attack_direction() -> Vector2:
	var global_mouse_pos = get_global_mouse_position()
	return (global_mouse_pos - global_position).normalized()
func take_damage(source:Enemy):
	canTakeDamage = false
	damage_taken_sound.play()
	source.chomp_sound.play()
	DamageCooldown.start()
	print("Taking ",source.DAMAGE," damage")
	HEALTH -= source.DAMAGE
	if(HEALTH<=0):
		ON_DEATH.emit()

func _on_timeout():
	if(hitbox.has_overlapping_bodies()):
		for i in hitbox.get_overlapping_bodies():
			if(i.is_in_group("Enemy")):
				take_damage(i)
				break
	else:
		canTakeDamage = true

func _on_damage_source_enter(source:Enemy):
	if(canTakeDamage):
		take_damage(source)
func _on_footstep_finished():
	tookStep = true

func _on_attract_body_entered(body) -> void:
	if(body.is_in_group("Enemy")):
		body.attack_timer.start()


func _on_attract_body_exited(body) -> void:
	if(body.is_in_group("Enemy")):
		body.attack_timer.stop()
		body.state = body.SURROUND

# Weapon pickup
func add_weapon(weapon_index:int) -> void:
	var weapon = LevelManager.preload_weapon_scenes[weapon_index].instantiate()
	weapon.position = Vector2(0,0)
	add_child(weapon)

# Speedster timer timeout
func _on_speed_timer_timeout() -> void:
	MAX_SPEED /= 2

# Noir timer timeout
func _on_noir_timer_timeout() -> void:
	pass

# Power up
func activate_powerup(powerup_index:int) -> void:
	match powerup_index:
		0: # SPEED
			# add timer for 20 seconds speed boost
			# and maybe a skate powerup
			var speed_timer = Timer.new()
			add_child(speed_timer)
			speed_timer.wait_time = SPEEDSTER_TIMER
			speed_timer.one_shot = true
			speed_timer.timeout.connect(_on_speed_timer_timeout)
			speed_timer.start()
			MAX_SPEED *= 2
		1: # NOIR
			# Add invincibility here & noir filter
			var invinc_timer = Timer.new()
			add_child(invinc_timer)
			invinc_timer.wait_time = NOIR_TIMER
			invinc_timer.one_shot = true
			invinc_timer.timeout.connect(_on_noir_timer_timeout)
			invinc_timer.start()
			MELEE_ATTACK_SPEED *= 3
			# and maybe OPAF gun
		_:
			MAX_SPEED *= 1
