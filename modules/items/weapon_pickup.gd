@tool
class_name WeaponPickup extends Node2D

enum WEAPON_TYPE { 
	BUBBLE_GUN,
	SYRING_GUN,
}

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : Sprite2D = $Sprite2D
@onready var weapon_index : int = 1

func _ready() -> void:
	area_2d.body_entered.connect(_on_Area2D_body_entered)

# On entered
func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		print("Player picked up weapon")
		# weapon_index = randi() % WEAPON_TYPE.size()
		# print("Got weapon: ", WEAPON_TYPE.get(weapon_index))
		# var weapon_system_node = body.get_node("WeaponSystem")
		# if weapon_system_node:
		# 	weapon_system_node.add_weapon(weapon_index)
		body.add_weapon(weapon_index)
		queue_free()

# Set the weapon type
func set_weapon_type(weapon_type:WEAPON_TYPE) -> void:
	# randomize index from 0 to an integer value
	weapon_index = weapon_type
