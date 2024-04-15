extends KinematicBody2D

class_name Player

const bulletPath = preload("res://scenes/Projectiles.tscn")
var velo : Vector2= Vector2()
var speed = 100
var direction : Vector2 = Vector2() 
var hp = 1000
const BULLET_SPEED = 500
const BULLET_DAMAGE = 1



func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	$Node2D2.look_at(get_global_mouse_position())
	handle_input()
func shoot():
	var bullet = preload("res://scenes/Projectiles.tscn").instance()
	var direction = (get_global_mouse_position() - global_position).normalized()
	bullet.velocity = direction * BULLET_SPEED
	get_parent().add_child(bullet)
	bullet.global_position = global_position

func handle_input():
	#print("hej")
	
	if Input.is_action_pressed("up"):
		print("Up key pressed")
		velo.y -= 1
		direction = Vector2(0, -1)
	if Input.is_action_pressed("right"):
		velo.x += 1
		direction = Vector2(0, 1)
	if Input.is_action_pressed("left"):
		velo.x -= 1
		direction = Vector2(-1, 0)
	if Input.is_action_pressed("down"):
		velo.y += 1
		direction = Vector2(1, 0)
		
	if !Input.is_action_pressed("up") and !Input.is_action_pressed("down") and !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		velo = Vector2(0, 0)
	
	
	velo = velo.normalized()
	
func take_damage(damage):
	hp -= damage
	if hp <=0:
		queue_free()

func _physics_process(delta):
	handle_input()
	var collision = move_and_collide(velo * delta * speed)
	if collision:
		
		#queue_free()
		var collider = collision.collider
		print("collider er ",collider.get_class())
		if collider.get_class() == "Enemy":
			take_damage(BULLET_DAMAGE)
		if collider.get_class() == "Enemy":
			take_damage(BULLET_DAMAGE)
		elif collider.get_class() == "MainMap":
			Level1()


func get_class():
	return "Player"
func Level1():
	get_tree().change_scene_to(load("res://scenes/Level 1.tscn"))
