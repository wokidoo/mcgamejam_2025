extends Control

@onready var player:Player = get_tree().root.find_child("Player",true,false)

func _ready() -> void:
	self.visible = false
	player.ON_DEATH.connect(_game_over)

func _game_over():
	self.visible = true
	get_tree().paused = true
	player.queue_free()


func _on_retry_pressed() -> void:
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/main_menu.tscn")
