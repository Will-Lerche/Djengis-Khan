extends Control



func _on_BackButton_pressed():
	get_tree().change_scene_to(load("res://scenes/Startscreen.tscn"))


func _on_SaveScoreButton_pressed():
	get_tree().change_scene_to(load("res://scenes/Database.tscn"))
