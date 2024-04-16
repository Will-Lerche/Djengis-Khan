extends Node2D

var enemy_scene = preload("res://scenes/Enemies.tscn")
var merkit = 300
	
func _ready():
	$Timer.start()

func _on_Timer_timeout():
	if merkit == 0:
		get_tree().change_scene_to(load("res://scenes/MainScene.tscn")) 
		
	
	merkit = merkit - 1
	
	var enemy = enemy_scene.instance()

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rndX = rng.randi_range(-500, 500)
	var rndY = rng.randi_range(-500, 500)

	enemy.position = Vector2(rndX,rndY)

	

	$Player.get_parent().add_child(enemy)
	
	enemy.position = Vector2(rndX, rndY) + $Player.position
	print("Enemy spawn ", enemy.position)
	#enemy.global_position = get_parent().global_position 
	#print("SPAWN enemy", enemy.get_parent().global_position)

	print("1")

