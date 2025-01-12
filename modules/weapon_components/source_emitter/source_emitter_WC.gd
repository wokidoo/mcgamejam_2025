extends WeaponComponent
class_name SourcEmitterWC

## Refrence to Scene to be emitted
@export var source_scene:PackedScene
##[b]True[/b]: Weapon deviation will be added when calculating source direction.
## [br][br]
##[b]False[/b]: Source direction will use unmodified direction value
@export var use_deviation: bool = true
signal on_source_created(source: DamageSource)
signal on_source_destroyed(source: DamageSource)
signal on_source_contact(source:DamageSource)

func _apply_component(data):
	if data is Weapon:
		print_debug("Emitting source from Weapon data")
		var damage_source = source_scene.instantiate() as DamageSource
		damage_source.position = self.global_position
		damage_source.scale = data.scale
		if use_deviation:
			damage_source.direction = data.get_deviated_direction()
		else:
			damage_source.direction = data.direction
		damage_source._set_all_stats(data)
		get_tree().root.add_child(damage_source)
		damage_source.on_source_destroyed.connect(emitted_source_destroyed)
		on_source_created.emit(damage_source)
	elif data is DamageSource:
		print_debug("Emitting source from DamageSource data")
		var damage_source = source_scene.instantiate() as DamageSource
		damage_source.position = data.global_position
		damage_source.scale = data.scale
		damage_source.direction = data.direction
		damage_source._set_all_stats(data)
		get_tree().root.add_child(damage_source)
		damage_source.on_source_destroyed.connect(emitted_source_destroyed)
		on_source_created.emit(damage_source)
	else:
		assert(data is DamageSource or data is Weapon)

func emitted_source_destroyed(source: DamageSource):
	on_source_destroyed.emit(source)
