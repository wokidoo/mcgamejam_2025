extends Node2D

@onready var parent: Enemy
@onready var timer: Timer = $Timer
var dot_damage: float = 1.0
var dot_delay: float = 1.0

func _ready():
	parent = get_parent()
	var child_dot = parent.find_child("goop_dot")
	if child_dot:
		queue_free()
	else:
		parent.sprite.modulate = Color.MEDIUM_PURPLE
		timer.timeout.connect(inflict_dot)
		timer.autostart = true
		timer.start(dot_delay)

func inflict_dot():
	parent.take_damage(dot_damage)
