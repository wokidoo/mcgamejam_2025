extends CanvasLayer

@export var player : Player

@onready var time:Label = $VBoxContainer/time
@onready var killCount:Label = $VBoxContainer/killCount
@onready var pickUpMessage:Label = $HBoxContainer/pickUpMessage
@onready var HP:Label = $VBoxContainer/HP
@onready var messageTimer:Timer = $"Message Timer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.gameTime = 0.0
	LevelManager.enemyKilled = 0
	
	time.text = "Lost: " + str(LevelManager.gameTime) + " sec"
	killCount.text = "Enemies Trashed: " + str(LevelManager.enemyKilled)
	pickUpMessage.visible = false
	player.ON_PICKUP.connect(OnPickUp)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time.text = "Lost: " +str(snapped(LevelManager.gameTime, 0.01)) + " sec"
	killCount.text = "Enemies Trashed: " + str(LevelManager.enemyKilled)
	
	HP.text = "HP: " + str(player.HEALTH)
	pickUpMessage.text = LevelManager.message

func OnPickUp():
	pickUpMessage.visible = true
	messageTimer.start()

func _on_message_timer_timeout() -> void:
	pickUpMessage.visible = false
