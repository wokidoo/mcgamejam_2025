extends Control



func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world_level.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
