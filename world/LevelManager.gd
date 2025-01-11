extends Node2D

# Player and enemy nodes
@export var Player: PackedScene

# Difficulty Timer
@export var difficultyTimer: Timer
@export var difficultyTimerInterval: float = 10.0
# MODIFIERS: The level will increase a set of modifiers based on the game time to increase game difficulty
# These modifiers should be referenced by other scripts to 'increase' the base value of game elements
# The formula is: 
# [variable] = [base value] * [modifier]
# where: [modifiers] += [increment] after every interval as long as [modifier] <= [max modifier]
## Enemy spawn rate
@export var MAX_SPAWN_RATE_MODIFIER: float = 3.0
@export var SPAWN_RATE_MODIFIER_INCREMENT: float = 0.2
@export var spawnRateModifier: float = 1.0 # Grab this!

## Number of enemies
@export var MAX_NUMBER_OF_ENEMIES_MODIFIER: float = 20.0
@export var NUMBER_OF_ENEMIES_MODIFIER_INCREMENT: float = 1.0
@export var maxNumberOfEnemiesModifier: float = 1.0 #Grab this!

## Enemy speed
@export var MAX_ENEMY_SPEED_MODIFIER: float = 3.0
@export var ENEMY_SPEED_MODIFIER_INCREMENT: float = 0.2
@export var enemySpeedModifier: float = 1.0 # Grab this!

## Enemy health
@export var MAX_ENEMY_HEALTH_MODIFIER: float = 3.0
@export var ENEMY_HEALTH_MODIFIER_INCREMENT: float = 0.2
@export var enemyHealthModifier: float = 1.0 # Grab this!

# Current game time
var gameTime: float = 0.0

# Current number of enemies
var numberOfEnemies: int = 0

# Function to increase the modifers after Timer hit zero
func _on_DifficultyTimer_timeout():
	# Increase the spawn rate modifier
	if spawnRateModifier < MAX_SPAWN_RATE_MODIFIER:
		spawnRateModifier += SPAWN_RATE_MODIFIER_INCREMENT

	# Increase the number of enemies modifier
	if maxNumberOfEnemiesModifier < MAX_NUMBER_OF_ENEMIES_MODIFIER:
		maxNumberOfEnemiesModifier += NUMBER_OF_ENEMIES_MODIFIER_INCREMENT

	# Increase the enemy speed modifier
	if enemySpeedModifier < MAX_ENEMY_SPEED_MODIFIER:
		enemySpeedModifier += ENEMY_SPEED_MODIFIER_INCREMENT

	# Increase the enemy health modifier
	if enemyHealthModifier < MAX_ENEMY_HEALTH_MODIFIER:
		enemyHealthModifier += ENEMY_HEALTH_MODIFIER_INCREMENT
	
	# DEBUG println
	print("Game Time: ", gameTime)
	print("Spawn Rate Modifier: ", spawnRateModifier)
	print("Number of Enemies Modifier: ", maxNumberOfEnemiesModifier)
	print("Enemy Speed Modifier: ", enemySpeedModifier)
	print("Enemy Health Modifier: ", enemyHealthModifier)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawnRateModifier = 1.0
	maxNumberOfEnemiesModifier = 1.0
	enemySpeedModifier = 1.0
	enemyHealthModifier = 1.0

	difficultyTimer = Timer.new()
	add_child(difficultyTimer)
	difficultyTimer.timeout.connect(_on_DifficultyTimer_timeout)
	difficultyTimer.wait_time = difficultyTimerInterval
	difficultyTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gameTime += delta
