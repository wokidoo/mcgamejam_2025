extends Node2D

@onready var progressBar: TextureProgressBar = $TimerCooldown

@export var powerUpType: AnimatedSprite2D

@onready var timer: Timer = $Timer

@onready var player:Player = $"../../Player"

func _ready() -> void:
	visible = false
	

func _process(delta: float) -> void:
	progressBar.value = timer.time_left/timer.wait_time

func powerStart():
	visible = true
	timer.start()
	

func _on_timer_timeout() -> void:
	visible = false
