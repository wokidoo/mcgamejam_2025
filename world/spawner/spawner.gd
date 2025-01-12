extends Node2D
class_name Spawner

@onready var enemy_scene: Array[PackedScene]
@onready var default_enemy = preload("res://Enemies/Enemy.tscn")
@export var spawnWaitTimer : float = 5.0
@onready var timer: Timer = $Timer
@export var numberOfEnemies : int = 0
@export var MAX_NUMBER_OF_ENEMIES : int = 20
@export var spawnPoints : Array[Node2D]

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	enemy_scene.append( load("res://Enemies/Enemy.tscn") )
	LevelManager.modifier_increased.connect(_on_modifier_increased)
	timer.timeout.connect(_on_Timer_timeout)
	timer.wait_time = spawnWaitTimer
	timer.start()

func _on_Timer_timeout():
	print("Spawning enemy")
	if (numberOfEnemies > MAX_NUMBER_OF_ENEMIES):
		return
	# Called when the Timer times out.
	# var ene = default_enemy.instantiate()
	var ene = enemy_scene[0].instantiate()
	# random position
	var index = randi() % spawnPoints.size()
	ene.position = spawnPoints[index].position
	get_parent().add_child(ene)

func spawn_random_enemy():
	pass

func _on_modifier_increased():
	MAX_NUMBER_OF_ENEMIES *= LevelManager.MAX_NUMBER_OF_ENEMIES_MODIFIER
	spawnWaitTimer /= LevelManager.spawnRateModifier
	timer.wait_time = spawnWaitTimer
