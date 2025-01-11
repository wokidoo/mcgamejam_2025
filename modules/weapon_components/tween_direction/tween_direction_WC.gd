extends WeaponComponent
class_name TweenDirectionWC

## Target value for the tweened stat
@export var target_value: float = 0.0
##[b]True[/b]: Stat will be modified by [member TweenStatWC.target_value] relative
## to original value.
## [br][br]
##[b]False[/b]: Final stat value will be set to [member TweenStatWC.target_value]
@export var as_relative: bool = false
## Duration of the tween
@export var duration: float = 1.0
@export var easing_method: Tween.EaseType
@export var trans_method: Tween.TransitionType
## Should the damage source be destroyed after the tween
@export var destroy_after: bool = true

func _apply_component(source: DamageSource):
	var tween = get_tree().create_tween()
	tween.set_ease(easing_method)
	tween.set_trans(trans_method)
	tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	if as_relative:
		#tween.tween_property(source,stat_name, target_value,duration).as_relative()
		pass
	else:
		#tween.tween_property(source,stat_name, target_value,duration)
		pass
	if destroy_after:
		tween.tween_callback(source.destroy_source)
