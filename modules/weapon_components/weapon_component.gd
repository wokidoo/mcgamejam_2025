extends Node2D
class_name WeaponComponent
## A component for weapons or weapon components, enabling modular behavior.
##
## This class allows attaching additional functionality to a [Weapon] or another
## [WeaponComponent] by responding to specific signals from either the parent.
## It is designed to be extended by concrete implementations.
## [br][br]
## [b]Parent Requirements[/b]:[br]
## - The parent node must be of type [Weapon] or [WeaponComponent]. [br]
## - The parent must emit the signal specified in [member parent_trigger_signal].[br]
## [br][br]
## [b]Global Signal Handling[/b]:[br]
## - Global signals are dynamically connected through the [SignalBus].


## Refrence to the parent node. Parent node can only be of type [Weapon] or 
## [WeaponComponent]
@onready var component_parent = get_parent()
## Name of the parent signal that will trigger a call to 
## [method WeaponComponent._apply_component]
@export var parent_trigger_signal: String


func _ready():
	# component_parent should only be of type Weapon or of type WeaponComponent
	assert(component_parent is Weapon or component_parent is WeaponComponent)
	# Attach parent signal to _apply_component
	if component_parent.has_signal(parent_trigger_signal):
		component_parent.connect(parent_trigger_signal,_apply_component)

## Override this method in child classes to implement specific behavior.
## [br][br]
## [b][u]Example[/u][/b]:
## [codeblock]
## func _apply_component(weapon: Weapon):
##      var damage_source = source_scene.instantiate() as DamageSource
##      damage_source.position = self.position
##      damage_source.direction = weapon.get_deviated_direction()
##      damage_source._set_all_stats(weapon)
##      get_tree().root.add_child(damage_source)
##      on_damage_source_created.emit(damage_source)
## [/codeblock]
## [br][br]
## This method is called whenever the component's trigger signals are emitted.
## It serves as the primary entry point for the component's functionality.
## [br][br]
## [param data] The data passed when the signal is emitted. Can vary depending on the signal.
## [br][br]
func _apply_component(data):
	# Does nothing by default
	pass
