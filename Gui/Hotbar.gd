extends HBoxContainer
var ha = 0
var hotbar_slots : Array


var current_slot = 0


func _ready():
	hotbar_slots = [$HotbarSlot, $HotbarSlot2]

func _process(delta):
	weNeed(delta)


func _input(event):
	if event is InputEventKey: 
		if event.pressed:
			if Input.is_action_pressed("Hotbar_slot_1"):
				switch_to_slot(0)
				get_parent().get_parent().get_node("Player").get_node("Djengis").play("Bue skift")
				
			elif Input.is_action_pressed("Hotbar_slot_2"):
				switch_to_slot(1)
				get_parent().get_parent().get_node("Player").get_node("Djengis").play("Melee skift")
			
			elif Input.is_action_pressed("Hotbar_slot_3"):
				switch_to_slot(2)
			
			elif Input.is_action_pressed("ui_accept") and current_slot == 0:
				get_parent().get_parent().get_node("Player").shoot()
			
			elif Input.is_action_pressed("ui_accept") and current_slot == 1:
				get_parent().get_parent().get_node("Player").attack()

func switch_to_slot(slot_index):
	if slot_index != current_slot:
		
		
		current_slot = slot_index

func weNeed(var yes):
	if ha == 6 :
		yes=5
	ha= ha + 1
