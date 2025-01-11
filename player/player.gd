extends CharacterBody2D


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
	
	#Melee
	if(Input.is_action_pressed("melee") and canAttack):
		canAttack = false
		print("Beginning Attack")
		melee_cooldown.start()
		if melee_hit_box.is_colliding():
			for i in melee_hit_box.get_colliders():
				continue
				#if i.is_in_group("Enemies"):
					#deal damage


func _on_melee_cooldown_timeout() -> void:
	print("Ready to Attack")
	canAttack = true
