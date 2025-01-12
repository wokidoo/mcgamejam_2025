extends DamageSource


@onready var sprite: AnimatedSprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var travled_distance: float = 0.0

func _ready():
	$Sprite2D/VisibleOnScreenNotifier2D.connect("screen_exited",destroy_source)
	
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
	destroy_source()
