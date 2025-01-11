extends DamageSource
class_name Slash


@onready var sprite: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var total_rotated: float = 0.0

func _ready():
	# Set starting to face attack direction
	var initial_angle = direction.rotated(deg_to_rad(90))
	# Rotate initial angle by half of the arc
	initial_angle = initial_angle.rotated(deg_to_rad(-range/2.0))
	# Apply starting rotation
	rotation = initial_angle.angle()
	
func _physics_process(delta):
	var rotate_by : float = speed*delta
	self.rotate(deg_to_rad(rotate_by))
	total_rotated += rotate_by
	if total_rotated >= range:
		sprite.visible = false
		destroy_source()
