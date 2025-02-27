extends Timer

var enemy_scene = preload("res://scenes/Enemies.tscn")
var enemies = 40

func _ready():
	pass

func _process(delta):
	pass
		

func _on_Enemyspawner_timeout():
	
	if enemies == 0:
		get_tree().change_scene_to(load("res://scenes/WinScene.tscn")) 
		
	
	enemies = enemies - 1
	
	var enemy = enemy_scene.instance()

	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rndX = rng.randi_range(-500, 500)
	var rndY = rng.randi_range(-500, 500)

	enemy.position = Vector2(rndX,rndY)

	if get_node("../Player")!=null:
		enemy.global_position = Vector2(rndX, rndY) + $"../Player".global_position
	
	get_parent().add_child(enemy)
