extends Button

@onready var level = "res://world/world_level.tscn"



func _on_pressed() -> void:
	get_node("root/Main").free()
	get_tree().root.add_child(level)
