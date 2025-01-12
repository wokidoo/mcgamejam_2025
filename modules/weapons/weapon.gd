extends Node2D
class_name Weapon

signal on_attack(weapon:Weapon)

#@export var weapon_data: WeaponData

@export var weapon_name: String
@export var description: String
@export var texture: Texture2D
@export var damage: float = 5.0
@export_range(0.01,20.0) var attacks_per_second: float = 1.0
@export var speed: float = 100.0
@export var range: float = 500.0
@export_range(0,180,0.1,"radians_as_degrees") var deviation: float
@export_range(0.1,10,0.1) var area: float = 1.0
@export var input_name:String = "attack"

var direction: Vector2 = Vector2.ZERO
var attack_timer: Timer
@onready var sprite: Sprite2D = Sprite2D.new()
@onready var auto_fire: bool = false
 
func _ready():
	attack_timer = Timer.new()
	add_child(attack_timer)
	attack_timer.one_shot = true
	sprite.texture = texture

func _physics_process(delta):
	if Input.is_action_just_pressed("auto_fire"):
		auto_fire = !auto_fire

	if auto_fire or Input.is_action_pressed(input_name):
		if attack_timer.is_stopped():
			direction = calculate_attack_direction()
			attack_timer.start(1.0/attacks_per_second)
			on_attack.emit(self)

func calculate_attack_direction() -> Vector2:
	var global_mouse_pos = get_global_mouse_position()
	return (global_mouse_pos - global_position).normalized()

func get_deviated_direction():
	return direction.rotated(randf_range(-deviation,deviation))
