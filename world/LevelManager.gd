extends Node2D

# Player weapons
var preload_weapon_scenes: Array[PackedScene]
#var preload_weapon_sprites: Array[Texture2D]

# Player powerups
#var preload_powerup_scenes: Array[PackedScene]
#var preload_powerup_sprites: Array[Texture2D]

# Auto Firing
var auto_fire: bool = false

# Difficulty Timer
@export var difficultyTimer: Timer
@export var difficultyTimerInterval: float = 90.0
# MODIFIERS: The level will increase a set of modifiers based on the game time to increase game difficulty
# These modifiers should be referenced by other scripts to 'increase' the base value of game elements
# The formula is: 
# [variable] = [base value] * [modifier]
# where: [modifiers] += [increment] after every interval as long as [modifier] <= [max modifier]
## Enemy spawn rate
@export var MAX_SPAWN_RATE_MODIFIER: float = 3.0
@export var SPAWN_RATE_MODIFIER_INCREMENT: float = 0.5
@export var spawnRateModifier: float = 1.0 # Grab this!

## Number of enemies
@export var MAX_NUMBER_OF_ENEMIES_MODIFIER: float = 20.0
@export var NUMBER_OF_ENEMIES_MODIFIER_INCREMENT: float = 2.0
@export var maxNumberOfEnemiesModifier: float = 1.0 #Grab this!

## Enemy speed
@export var MAX_ENEMY_SPEED_MODIFIER: float = 3.0
@export var ENEMY_SPEED_MODIFIER_INCREMENT: float = 0.2
@export var enemySpeedModifier: float = 1.0 # Grab this!

## Enemy health
@export var MAX_ENEMY_HEALTH_MODIFIER: float = 3.0
@export var ENEMY_HEALTH_MODIFIER_INCREMENT: float = 0.2
@export var enemyHealthModifier: float = 1.0 # Grab this!

# Drop chance
@export var WEAPON_DROP_CHANCE: float = 0.3
@export var POWERUP_DROP_CHANCE: float = 0.3

# Signal for modifier increase
signal modifier_increased

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
	
	modifier_increased.emit()

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

	# Call the function to load weapon
	print("loading weapons...")
	load_scenes("res://weapons", preload_weapon_scenes)

	#print("loading weapon sprites...")
	#load_sprites("res://assets/Sprites/items", preload_weapon_sprites)
#
	## Call the function to load powerups
	#print("loading powerup sprites...")
	#load_sprites("res://assets/Sprites/powerups", preload_powerup_sprites)

# Function to load scenes
func load_scenes(folder_path: String, arr: Array[PackedScene]) -> void:
	var files = get_files_in_folder(folder_path)
	print("Files in folder: ", files)
	for file in files:
		var gun_scene = load(folder_path + "/" + file)
		if gun_scene:
			arr.append(gun_scene)
			print(arr.size())
		else:
			print("Failed to load gun scene: ", gun_scene)

# Function to load sprites
func load_sprites(folder_path: String, arr: Array[Texture2D]) -> void:
	var files = get_files_in_folder(folder_path)
	print("Files in folder: ", files)
	for file in files:
		if !file.ends_with(".png"): 
			continue
		var image = Image.load_from_file(folder_path + "/" + file)
		if image:
			var texture = ImageTexture.create_from_image(image)
			if texture:
				arr.append(texture)
				print(arr.size())
			else:
				print("Failed to create texture from texture: ", texture)
			
	
# Look for files in the folder "godot"
func get_files_in_folder(folder_path: String) -> Array:
	var dir = DirAccess.open(folder_path)
	var files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				files.append(file_name)
			file_name = dir.get_next()
		dir.list_dir_end()
	return files

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	gameTime += delta

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("auto_fire"):
		LevelManager.auto_fire = !LevelManager.auto_fire
