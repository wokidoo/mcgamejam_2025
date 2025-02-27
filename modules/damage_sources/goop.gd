extends DamageSource

@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
var travled_distance: float = 0.0
var goop_dot: PackedScene = preload("res://modules/damage_sources/goop_dot.tscn")

func _ready():
	audio.play()
	sprite.play("default")
	
func _physics_process(delta):
	var move_by : Vector2 = direction*speed*delta
	global_position += move_by
	global_rotation = direction.angle()
	travled_distance += move_by.length()
	if travled_distance >= range:
		destroy_source()


func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		var dot = goop_dot.instantiate()
		body.add_child(dot)
	sprite.speed_scale = 2
	sprite.play("explode")
	speed = 0
	await sprite.animation_looped
	destroy_source()
