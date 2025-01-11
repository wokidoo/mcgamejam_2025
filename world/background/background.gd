extends Parallax2D

var sprite_material: ShaderMaterial
var player: Player
var last_pos: Vector2 = Vector2.ZERO
@export var shift_coefficient: float = 200;

func _ready():
	sprite_material = $Sprite2D.material
	player = get_tree().root.find_child("Player",true,false)
	print_debug(player)
