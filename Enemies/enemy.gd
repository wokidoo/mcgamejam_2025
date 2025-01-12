extends CharacterBody2D

class_name Enemy

@export var HEALTH: float = 10.0
@export var SPEED:float

@onready var player:Player = $"../Player"
@onready var hitbox: Area2D = $"Hitbox"
@onready var deathSounds:AudioStreamPlayer2D = $DeathSounds
@export var DAMAGE: float = 1.0
@onready var hurt_sound:AudioStreamPlayer2D = $HurtSounds
@onready var chomp_sound:AudioStreamPlayer2D = $ChompSound

var randomnum

signal enemy_died(enemy:Enemy)

var can_hurt_sound:bool

enum{
	SURROUND,
	ATTACK,
	HIT
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	can_hurt_sound = true
	rng.randomize()
	randomnum = rng.randf()
	deathSounds.finished.connect(destory_enemy)
	hurt_sound.finished.connect(reset_hurt_sound)
	#hitbox.area_entered.connect(_on_damage_source_enter)

func _physics_process(delta: float) -> void:
	match state:
		SURROUND:
			move(get_circle_position(randomnum), delta)
		ATTACK:
			move(player.global_position, delta)
		HIT:
			#move(-player.velocity.normalized(), delta)
			var player_velocity = player.velocity
			velocity += player_velocity
			move_and_slide()
	
	

func move(target,delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED

	velocity = desired_velocity
	move_and_slide()

	
func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;
	return Vector2(x, y)

#func _on_damage_source_enter(damage_source: DamageSource) -> void:
	#print_debug("Receive ",damage_source.damage," damage!")
	#HEALTH -= damage_source.damage
	#if HEALTH <= 0:
		#destory_enemy()

func take_damage(damage):
	HEALTH -= damage
	if(can_hurt_sound):
		can_hurt_sound = false
		hurt_sound.play()
	
	if HEALTH <= 0:
		hitbox.disable_mode = hitbox.DISABLE_MODE_REMOVE
		if(!deathSounds.playing):
			deathSounds.play()

func destory_enemy():
	enemy_died.emit(self)
	queue_free()

func reset_hurt_sound():
	can_hurt_sound = true
