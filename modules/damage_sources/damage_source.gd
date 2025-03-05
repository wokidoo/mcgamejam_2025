extends Node2D
class_name DamageSource

@export_group("stats")
@export var damage: float
@export var speed: float
@export var range: float
@export var area: float:
	get:
		return area
	set(value):
		area = value
		self.scale = Vector2(value,value)
@export_range(0,180,0.1,"radians_as_degrees") var deviation: float
## Number of enemies that source can go through before being destroyed
## A value of 0 means the source can pierce any number of enemies
@export var pierce:int = 0
@export var knockback_strength: float:
	get:
		return knockback_strength
	set(value):
		knockback_strength = value
		knockback_strength = max(0,knockback_strength)

var has_pierced: int = 0

var direction : Vector2
var emit_destroyed: bool = true

signal on_source_destroyed(source: DamageSource)
signal on_source_contact(source: DamageSource)

func destroy_source():
	if emit_destroyed:
		print_debug("on_source_destroyed called by: ",self)
		on_source_destroyed.emit(self)
	queue_free.call_deferred()

# sets all stats properties 
func _set_all_stats(data):
	assert(data is DamageSource or data is Weapon)
	damage = data.damage
	speed = data.speed
	range = data.range
	area = data.area
	deviation = data.deviation

# Set knock back strength
func set_knockback_strength(value: float, body: Node):
	if body.knockback_strength:
		body.knockback_strength = value
