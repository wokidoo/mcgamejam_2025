extends Node2D

@export var preload_scenes: Array[PackedScene]

# Weapon pickup
func add_weapon(weapon_index:int) -> void:
	var weapon = preload_scenes[weapon_index].instantiate()
	weapon.position = Vector2(0,0)
	add_child(weapon)
