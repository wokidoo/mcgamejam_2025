extends CharacterBody2D
class_name Player

@export var MAX_SPEED :float = 1500.0
@export var DECELERATION :float = 100.0
@export var melee_hit_box:ShapeCast2D
@export var MELEE_ATTACK_SPEED:float
@export var melee_cooldown:Timer
@export var HEALTH:float = 5.0

@onready var DamageCooldown:Timer = $DamageCooldown

var canTakeDamage:bool
var canAttack:bool
var direction: Vector2

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var hitbox: Area2D = $HitBox

func _ready() -> void:
	hitbox.body_entered.connect(_on_damage_source_enter)
	DamageCooldown.timeout.connect(_on_timeout)
	canAttack = true
	canTakeDamage = true

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	# If direction is not null, change velocity
	if not direction.is_zero_approx():
		velocity = direction * MAX_SPEED
	else:
		velocity = Vector2.ZERO * move_toward(velocity.length(), 0.0, DECELERATION * delta)
		
	if velocity.length() > 0:
		sprite.play("walk")
		if velocity.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
	else:
		sprite.play("idle")
	move_and_slide()

func _on_damage_source_enter(source:Enemy):
	if(canTakeDamage):
		take_damage(source)

func take_damage(source:Enemy):
	canTakeDamage = false
	DamageCooldown.start()
	print("Taking ",source.DAMAGE," damage")
	HEALTH -= source.DAMAGE
	if(HEALTH<=0):
		get_tree().paused = true

func _on_timeout():
	if(hitbox.has_overlapping_bodies()):
		for i in hitbox.get_overlapping_bodies():
			if(i.is_in_group("Enemy")):
				take_damage(i)
				break
	else:
		print("Can take Damage")
		canTakeDamage = true
