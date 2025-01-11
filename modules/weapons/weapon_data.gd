extends Resource
class_name WeaponData

@export var name: String
@export var description: String
@export var texture: Texture
@export var damage: float = 5.0
@export_range(0.01,20.0) var attacks_per_second: float = 1.0
@export var speed: float = 100.0
@export var range: float = 500.0
@export_range(0,180,0.1,"radians_as_degrees") var deviation: float
@export_range(0.1,10,0.1) var area: float = 1.0
