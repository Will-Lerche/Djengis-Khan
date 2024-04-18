extends Area2D
class_name Enemy

export var speed = 50

onready var player = get_parent().get_node("Player")

var hp = 5

var playerContact : Player = null

func take_damage(damage):
	hp -= damage
	if hp <= 0:
		Global.Kill_count = Global.Kill_count+1
		queue_free()

func _physics_process(delta):
	if !is_instance_valid(player):
		return
	
	if playerContact != null:
		playerContact.take_damage(1)

	var player_position = player.position
	var target_position = (player_position - position).normalized()


	if position.distance_to(player_position) > 25:
		$Enemy.play("Idle")
		target_position = position - player_position
		position = position - target_position.normalized()
		
	else: 
		$Enemy.play("Attack")

func get_class():
	return "Enemy"


func _on_Enemies_body_entered(body):
	if body.get_class() == "Player":
		playerContact = body
		
	if body.get_class() == "Projectile":
		take_damage(1)


func _on_Enemies_body_exited(body):
	if body.get_class() == "Player":
		playerContact = null


func melee(body):
	if body.get_class() == "Player":
		playerContact = null
	pass

