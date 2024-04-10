extends Area2D
class_name Enemy

export var speed = 50
var hp = 5

var playerContact : Player = null

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		queue_free()

func _physics_process(delta):
	var player = get_parent().get_node("Player")
	
	if playerContact != null:
		playerContact.take_damage(1)
	
	if player != null:
		var player_position = player.position
		var target_position = (player_position - position).normalized()
	 
		if position.distance_to(player_position) > 3:
			target_position = position - player_position
			position = position - target_position.normalized()

func get_class():
	return "Enemy"


func _on_Enemies_body_entered(body):
	if body.get_class() == "Player":
		playerContact = body
		
	if body.get_class() == "Projectile":
		take_damage(1)
		print("ARGGHHH SIGER ENEMY")
	pass # Replace with function body.


func _on_Enemies_body_exited(body):
	if body.get_class() == "Player":
		playerContact = null
	pass # Replace with function body.
