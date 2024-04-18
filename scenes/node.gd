extends Node2D
#
#var enemy_scene = preload("res://scenes/Enemies.tscn")
#func _ready():
#	$Timer.start()
#
#func _on_Timer_timeout():
#	var enemy = enemy_scene.instance()
#
#	var screenSize = get_viewport().get_visible_rect().size
#	var rng = RandomNumberGenerator.new()
#	var rndX = rng.randi_range(0, screenSize.x)
#	var rndY = rng.randi_range(0, screenSize.y)
#
#
#	#enemy.get_parent()
#
#
#	enemy.global_position = Vector2(rndX, rndY)
#
#
#	add_child(enemy)
#	enemy.global_position = get_parent().global_position 
#	print("SPAWN enemy", enemy.get_parent().global_position)
#
#	print("1")
#
