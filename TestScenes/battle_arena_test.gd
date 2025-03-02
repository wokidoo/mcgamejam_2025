extends Node2D

func _ready():
	$iris_effect/AnimationPlayer.play("iris_effect")
	await get_tree().create_timer(1.0).timeout
	get_tree().paused = false
	
