extends CanvasLayer

var material: ShaderMaterial
var player: Player
var last_pos: Vector2 = Vector2.ZERO
@export var shift_coefficient: float = 200;
func _ready():
	material = $ColorRect.material
	player = get_tree().root.find_child("Player",true,false)
	print_debug(player)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	var move_by = player.global_position - last_pos
	last_pos = player.global_position
	material.set_shader_parameter("player_pos",last_pos/shift_coefficient)
