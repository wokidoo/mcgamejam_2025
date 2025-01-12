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
@export var onDeathWeapon: PackedScene
@export var onDeathPowerup: PackedScene

@onready var sprite: AnimatedSprite2D = $Sprite2D

var randomnum: float

var isDeathSpawned: bool = false

var can_hurt_sound:bool

var can_move: bool = true

signal enemy_died(enemy:Enemy)

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
	onDeathWeapon = load("res://modules/items/weapon_pickup.tscn")
	onDeathPowerup = load("res://modules/items/powerup_pickup.tscn")
	sprite.play("default")


func _physics_process(delta: float) -> void:
	match state:
		SURROUND:
			move(get_circle_position(randomnum), delta)
		ATTACK:
			move(player.global_position, delta)
		HIT:
			if can_move:
				var player_velocity = player.velocity
				velocity += player_velocity
				move_and_slide()
	
	

func move(target,delta):
	if can_move:
		var direction = (target - global_position).normalized() 
		var desired_velocity =  direction * SPEED

		velocity = desired_velocity
		if velocity.x < 0:
			sprite.flip_h = true
		else:
			sprite.flip_h = false
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
		# rng to spawn an item or powerup
		if (!isDeathSpawned):
			isDeathSpawned = true
			death_spawn()

		if(!deathSounds.playing):
			deathSounds.play()

func death_spawn():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var weapon_spawn_chance = rng.randf()
	var powerup_spawn_chance = rng.randf()
	if weapon_spawn_chance <= LevelManager.WEAPON_DROP_CHANCE:
		# spawn onDeathWeapon
		var weapon_instance = onDeathWeapon.instantiate()
		get_parent().call_deferred("add_child", weapon_instance)
		weapon_instance.global_position = global_position
	elif powerup_spawn_chance <= LevelManager.POWERUP_DROP_CHANCE:
		# spawn powerup
		var powerup_instance = onDeathPowerup.instantiate()
		get_parent().call_deferred("add_child", powerup_instance)
		powerup_instance.global_position = global_position

func destory_enemy():
	deathSounds.play()
	sprite.speed_scale = 5
	sprite.play("death")
	enemy_died.emit(self)
	await sprite.animation_looped
	queue_free()

func reset_hurt_sound():
	can_hurt_sound = true
