extends Control

@onready var loadProgress = $VBoxContainer/ProgressBar
var nextScenePath = "res://world/world_level.tscn"

func _ready() -> void:
	ResourceLoader.load_threaded_request(nextScenePath)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var progress = []
	ResourceLoader.load_threaded_get_status(nextScenePath,progress)
	loadProgress.value = progress[0]*100
	if progress[0]>=1:
		var packed_scene = ResourceLoader.load_threaded_get(nextScenePath)
		get_tree().change_scene_to_packed(packed_scene)
