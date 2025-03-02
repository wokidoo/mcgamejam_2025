extends Control

@onready var new_run:Button = $"VBoxContainer/New Run"
@onready var quit:Button = $VBoxContainer/Quit

func _ready() -> void:
	new_run.pressed.connect(_on_new_run_pressed)
	quit.pressed.connect(_on_quit_pressed)
	$iris_effect/AnimationPlayer.play("iris_effect")

func _on_new_run_pressed() -> void:
	$iris_effect/AnimationPlayer.play_backwards("iris_effect")
	await get_tree().create_timer(1.0).timeout
	get_tree().change_scene_to_file("res://Scenes/LoadingScreen.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()

func _process(delta):
	var texture = $SubViewport.get_texture()
	$Screen.texture = texture
