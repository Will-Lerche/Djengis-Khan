extends HBoxContainer
var ha = 0
var hotbar_slots : Array
var current_slot = 0

func _ready():
	hotbar_slots = [$HotbarSlot, $HotbarSlot2]

func _input(event):
	if event is InputEventKey: 
		if event.pressed:
			match event.scancode:
				KEY_1:
					switch_to_slot(0)
					get_parent().get_parent().get_node("Player").get_node("Djengis").play("Bue skift")
				KEY_2:
					switch_to_slot(1)
					get_parent().get_parent().get_node("Player").get_node("Djengis").play("Melee skift")

func switch_to_slot(slot_index):
	if slot_index != current_slot:
		current_slot = slot_index
