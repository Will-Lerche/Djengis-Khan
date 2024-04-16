extends HBoxContainer

var hotbar_slots : Array


var current_slot = 0


func _ready():
	hotbar_slots = [$HotbarSlot, $HotbarSlot2, $HotbarSlot3]

func _process(delta):
	pass 

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			if Input.is_action_pressed("Hotbar_slot_1"):
				switch_to_slot(0)
			elif Input.is_action_pressed("Hotbar_slot_2"):
				switch_to_slot(1)
			elif Input.is_action_pressed("Hotbar_slot_3"):
				switch_to_slot(2)
			elif Input.is_action_pressed("ui_accept") and current_slot == 0:
				get_parent().get_parent().get_node("Player").shoot()
			

func switch_to_slot(slot_index):
	if slot_index != current_slot:
		print("Selected hotbar slot:", slot_index + 1)
		
		current_slot = slot_index
