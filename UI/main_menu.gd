extends Control

@onready var new_run:Button = $"VBoxContainer/New Run"
@onready var quit:Button = $VBoxContainer/Quit

func _ready() -> void:
	new_run.pressed.connect(_on_new_run_pressed)
	quit.pressed.connect(_on_quit_pressed)
	

func _on_new_run_pressed() -> void:
	get_tree().change_scene_to_file("res://world/world_level.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
