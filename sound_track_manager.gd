extends AudioStreamPlayer

@export var round_1_2_song:AudioStreamMP3
@export var round_3_up_song:AudioStreamMP3


var round:int

func _ready() -> void:
	round = 1
	LevelManager.modifier_increased.connect(_on_wave_increase)
	stream = round_1_2_song
	play()

func _on_wave_increase():
	round+=1
	print_debug("Round: ",round)
	match(round):
		3:
			stop()
			stream = round_3_up_song
			play()
		5:
			pitch_scale += 0.1
