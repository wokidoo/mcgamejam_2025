extends CharacterBody2D
class_name Player

class_name Player

@export var MAX_SPEED :float = 1500.0
@export var DECELERATION :float = 100.0
@export var melee_hit_box:ShapeCast2D
@export var MELEE_ATTACK_SPEED:float
@export var melee_cooldown:Timer
var canAttack:bool
var direction: Vector2

func _ready() -> void:
	canAttack = true

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_vector("move_left", "move_right","move_up","move_down")
	# If direction is not null, change velocity
	if not direction.is_zero_approx():
		velocity = direction * MAX_SPEED
	else:
		velocity = Vector2.ZERO * move_toward(velocity.length(), 0.0, DECELERATION * delta)
	move_and_slide()


func _on_attack_body_entered(body) -> void:
	if(body.is_in_group("Enemy")):
		body.state = body.HIT


func _on_attack_body_exited(body) -> void:
	if(body.is_in_group("Enemy")):
		body.state = body.SURROUND


func _on_attract_body_entered(body) -> void:
	if(body.is_in_group("Enemy")):
		body.attack_timer.start()


func _on_attract_body_exited(body) -> void:
	if(body.is_in_group("Enemy")):
		body.attack_timer.stop()
		body.state = body.SURROUND
