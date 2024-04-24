extends Control



func _on_Start_pressed():
	Global.Kill_count = 0
	get_tree().change_scene_to(load("res://scenes/Level 1.tscn"))



func _on_Controls_pressed():
	get_tree().change_scene_to(load("res://scenes/ControlsScene.tscn"))
