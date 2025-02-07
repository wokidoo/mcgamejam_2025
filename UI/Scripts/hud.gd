extends CanvasLayer

@export var player : Player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	LevelManager.gameTime = 0.0
	LevelManager.enemyKilled = 0
	$time.text = "Lost: " + str(LevelManager.gameTime) + " sec"
	$enemyKilled2.text = "Enemies Trashed: " + str(LevelManager.enemyKilled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$time.text = "Lost: " +str(snapped(LevelManager.gameTime, 0.01)) + " sec"
	$enemyKilled2.text = "Enemies Trashed: " + str(LevelManager.enemyKilled)
	
	$health.text = "HP: " + str(player.HEALTH)
	$message.text = LevelManager.message
