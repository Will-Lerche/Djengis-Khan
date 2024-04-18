extends KinematicBody2D

signal experience_gained(growth_data)

class_name Player

const bulletPath = preload("res://scenes/Projectiles.tscn")
var velo : Vector2= Vector2()
var speed = 100
var direction : Vector2 = Vector2() 
var hp = 1000
const BULLET_SPEED = 500
const BULLET_DAMAGE = 1
onready var bullet = preload("res://scenes/Projectiles.tscn")
var cooldown = false



func _process(delta):
	if Input.is_action_pressed("attack") and !cooldown:
		cooldown = true
		$ShootCooldown.start()
		match $"../CanvasLayer/Hotbar".current_slot:
			0:
				$Djengis.play("Bue")
				shoot()
			1:
				$Djengis.play("Melee")
				melee()
	
	print(velo.length())
	if velo.length() < 0.5:
		$Horse.play("Idle")
	else:
		$Horse.play("Run")
	handle_input()

func shoot():
	var direction = (get_global_mouse_position() - global_position).normalized()
	var bullet_instance = bullet.instance()
	get_parent().add_child(bullet_instance)
	bullet_instance.look_at (direction)
	bullet_instance.velocity = direction * BULLET_SPEED
	bullet_instance.global_position = global_position
	$Djengis.play("Bue")

func melee():
	for area in $Melee.get_overlapping_areas():
					if area.is_in_group("Hit"):
						area.take_damage(5)

func _on_ShootCooldown_timeout():
	print(cooldown)
	cooldown = false

func handle_input():
	if Input.is_action_pressed("up"):
		velo.y -= 1
		direction = Vector2(0, -1)
	
	if Input.is_action_pressed("right"):
		velo.x += 1
		direction = Vector2(0, 1)
		$Horse.flip_h = false
		$Djengis.flip_h = false
		$Melee.scale.x = 1
	
	if Input.is_action_pressed("left"):
		velo.x -= 1
		direction = Vector2(-1, 0)
		$Horse.flip_h = true
		$Djengis.flip_h = true
		$Melee.scale.x = -1
	
	if Input.is_action_pressed("down"):
		velo.y += 1
		direction = Vector2(1, 0)
	
	if !Input.is_action_pressed("up") and !Input.is_action_pressed("down") and !Input.is_action_pressed("right") and !Input.is_action_pressed("left"):
		velo = Vector2(0, 0)
	
	
	velo = velo.normalized()
	
onready var _HP_Orb = get_parent().get_node("CanvasLayer/Health/Healthbubble")
const MAX_health = 1000

func healthBubble():
	set_health_bubble()
	_HP_Orb.max_value = MAX_health
	

func set_health_bubble()-> void:
	_HP_Orb.value = hp

	
func take_damage(damage):
	hp -= damage
	if hp <=0:
		get_tree().change_scene("res://scenes/GameoverScene.tscn")
	set_health_bubble()
	

func _physics_process(delta):
	handle_input()
	var collision = move_and_collide(velo * delta * speed)
	if collision:
		var collider = collision.collider
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

#level system
export (int) var level = 1

var experience = 0
var experience_total = 0 
var experience_required = get_required_experience(level + 1)

func get_required_experience(level):
	return round (pow(level, 1.8) + level * 4)

func gain_experience(amount):
	experience_total += amount 
	experience += amount
	var growth_data = []
	while experience >= experience_required:
		experience -= experience_required
		growth_data.append([experience_required, experience_required])
		level_up()
	growth_data.append([experience, experience_required])
	emit_signal("experience_gained",growth_data)

func level_up():
	level += 1
	experience_required = get_required_experience(level + 1)

func _on_Djengis_animation_finished():
	match $"../CanvasLayer/Hotbar".current_slot:
		0:
			$Djengis.play("Idle Bue")
		1:
			$Djengis.play("Idle Melee")
