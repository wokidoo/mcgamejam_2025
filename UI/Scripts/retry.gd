extends Button

var simultaneous_scene = preload("res://TestScenes/battle_arena_test.tscn").instantiate()

func _on_pressed() -> void:
	get_tree().root.add_child(simultaneous_scene)
