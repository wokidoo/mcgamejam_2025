@tool
class_name PowerupPickup extends Node2D

enum POWERUP_TYPE { 
	SKATE,
	NOIR,
}

@onready var area_2d: Area2D = $Area2D
@onready var sprite_2d: AnimatedSprite2D = $Sprite2D
@onready var powerup_index : int = 0

func _ready() -> void:
	area_2d.body_entered.connect(_on_Area2D_body_entered)

	# Randomize the powerup
	powerup_index = randi() % POWERUP_TYPE.size()
	# set the sprite
	#sprite_2d.texture = LevelManager.preload_powerup_sprites[powerup_index]
	if powerup_index == POWERUP_TYPE.SKATE:
		sprite_2d.play("default")
	elif powerup_index == POWERUP_TYPE.NOIR:
		sprite_2d.play("default")



# On entered
func _on_Area2D_body_entered(body: Node) -> void:
	if body is Player:
		print("Player picked up powerup")
		powerup_index = randi() % POWERUP_TYPE.size()
		print("Got powerup: ", POWERUP_TYPE.get(powerup_index))
		body.activate_powerup(powerup_index)
		queue_free()

# Set the powerup type
func set_powerup_type(powerup_type:POWERUP_TYPE) -> void:
	# randomize index from 0 to an integer value
	powerup_index = powerup_type
