extends StaticBody2D

class_name Enemy

@export var SPEED:float
@onready var attack_timer: Timer = $AttackTimer

@onready var player = $"../Player"

var randomnum

enum{
	SURROUND,
	ATTACK,
	HIT
}

var state = SURROUND

func _ready():
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	randomnum = rng.randf()

func _physics_process(delta: float) -> void:
	match state:
		SURROUND:
			move(get_circle_position(randomnum), delta)
		ATTACK:
			move(player.global_position, delta)
		HIT:
			move(player.global_position, delta)
			print("HIT")
			#Slash ANIM

func move(target,delta):
	var direction = (target - global_position).normalized() 
	var desired_velocity =  direction * SPEED
	var steering = (desired_velocity - velocity) * delta * 2.5
	velocity += steering
	move_and_slide()

func get_circle_position(random):
	var kill_circle_centre = player.global_position
	var radius = 40
	 #Distance from center to circumference of circle
	var angle = random * PI * 2;
	var x = kill_circle_centre.x + cos(angle) * radius;
	var y = kill_circle_centre.y + sin(angle) * radius;

	return Vector2(x, y)


func _on_attack_timer_timeout() -> void:
	state  = ATTACK
