extends Control

@onready var loadProgress = $VBoxContainer/ProgressBar
var nextScenePath = "res://world/world_level.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(nextScenePath)
	$VBoxContainer/AnimationPlayer.play("text_appear")
	$VBoxContainer/Label.text = "[center][wave amp=50.0 freq=10.0 connected=0]LOADING...[/wave][/center]"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(nextScenePath,progress)
	loadProgress.value = progress[0]*100
	if progress[0]>=1:
		$VBoxContainer/AnimationPlayer.play_backwards("text_appear")
		await get_tree().create_timer(0.25).timeout
		var packed_scene = ResourceLoader.load_threaded_get(nextScenePath)
		get_tree().change_scene_to_packed(packed_scene)
