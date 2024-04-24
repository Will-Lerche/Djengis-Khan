extends Node2D

onready var _player = $Level1/Player
#onready var _xp_label = $Level1/CanvasLayer/Xp_label
#onready var _bar = $Level1/CanvasLayer/ExperienceBar

#func _ready():
	#_bar.initialize(_player.experience, _player.experience_required)
	#_xp_label.update_text(_player.level, _player.experience, _player.experience_required)

#func _input(event):
	#if not event.is_action_pressed("Level"):
	#	return
	#_player.gain_experience(50)
	#_xp_label.update_text(_player.level, _player.experience, _player.experience_required)
