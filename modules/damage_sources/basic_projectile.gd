extends DamageSource
class_name Projectile


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var travled_distance: float = 0.0

func _ready():
	$Sprite2D/VisibleOnScreenNotifier2D.connect("screen_exited",destroy_source)
	pass
	
func _physics_process(delta):
	var move_by : Vector2 = direction*speed*delta
	position += move_by
	rotation = direction.angle()
	travled_distance += move_by.length()
	if travled_distance >= range:
		destroy_source()
