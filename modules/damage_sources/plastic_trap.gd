extends Node2D

@onready var parent: Enemy
@onready var timer: Timer = $Timer

func _ready():
	parent = get_parent()
	var child_trap = parent.find_child("plastic_trap")
	if child_trap:
		child_trap.timer.start(1)
		queue_free()
	parent.can_move = false
	timer.start(1)
	await timer.timeout
	parent.can_move = true
	queue_free()
