@tool
class_name WeaponPickup extends Node2D

enum WEAPON_TYPE { 
	BANANA_GUN,
	BUBBLE_GUN,
	GOOP_GUN,
	SYRING_GUN,
	TIRE_GUN,
	PLASTIC_GUN,
}

@onready var area_2d : Area2D = $Area2D
@onready var sprite_2d : AnimatedSprite2D = $Sprite2D
@onready var weapon_index : int = 1

func _ready() -> void:
	area_2d.body_entered.connect(_on_Area2D_body_entered)
	# randomize the weapon
	weapon_index = randi() % WEAPON_TYPE.size()

	# set the sprite
	#sprite_2d.texture = LevelManager.preload_weapon_sprites[weapon_index]
	if weapon_index == WEAPON_TYPE.SYRING_GUN:
		sprite_2d.play("syring")
	elif weapon_index == WEAPON_TYPE.GOOP_GUN:
		sprite_2d.play("goop")
	elif weapon_index == WEAPON_TYPE.BANANA_GUN:
		sprite_2d.play("banana")
	elif weapon_index == WEAPON_TYPE.PLASTIC_GUN:
		sprite_2d.play("bag")
	elif weapon_index == WEAPON_TYPE.TIRE_GUN:
		sprite_2d.play("tire")

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
