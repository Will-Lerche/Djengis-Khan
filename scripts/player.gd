extends KinematicBody2D
const bulletPath = preload("res://scenes/Projectiles.tscn")
var velo : Vector2 = Vector2()
var direction : Vector2 = Vector2() 
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		shoot()
	$Node2D.look_at(get_global_mouse_position())
func shoot():
	var bullet = bulletPath.instance()
	
	get_parent().add_child(bullet)
	bullet.position = $Node2D/Position2D.global_position
	
	bullet.velocity = get_global_mouse_position() - bullet.position
func read_input():
	if Input.is_action_pressed("up"):
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
		
	velo = velo.normalized()
	
func _physics_process(delta):
	read_input()
	move_and_slide(velo * 200)
	velo = Vector2.ZERO
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		get_tree().change_scene("res://scenes/Level 1.tscn")
		print("Hej", collision.collider.name)
