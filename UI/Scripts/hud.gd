extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$time.text = "Lost: " + str(LevelManager.gameTime) + " sec"
	$enemyKilled2.text = "Found: " + str(LevelManager.enemyKilled)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$time.text = "Lost: " +str(snapped(LevelManager.gameTime, 0.01)) + " sec"
	$enemyKilled2.text = "Found: " + str(LevelManager.enemyKilled)
