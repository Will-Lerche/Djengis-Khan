extends Node2D

var enemy_scene = preload("res://scenes/Enemies.tscn")
func _ready():
	$Timer.start()

func _on_Timer_timeout():
	var enemy = enemy_scene.instance()
	add_child(enemy)
	print("1")
