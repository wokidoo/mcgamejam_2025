extends Control

@onready var player:Player = get_tree().root.find_child("Player",true,false)

func _ready() -> void:
	self.visible = false
	player.ON_DEATH.connect(_game_over)

func _game_over():
	self.visible = true
	get_tree().paused = true
	player.queue_free()
