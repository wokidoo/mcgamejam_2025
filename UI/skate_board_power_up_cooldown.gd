extends "res://UI/Scripts/temp_power_up_timer.gd"

func _ready() -> void:
	player.ON_PICKUP_SKATEBOARD.connect(powerStart)
