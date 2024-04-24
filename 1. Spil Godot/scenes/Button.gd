extends Button

func _on_Button_pressed():
	get_tree().change_scene_to(load("res://scenes/Startscreen.tscn"))


func _on_SaveScoreButton_pressed():
	get_tree().change_scene_to(load("res://scenes/Database.tscn"))
