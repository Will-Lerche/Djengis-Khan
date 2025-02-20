extends KinematicBody2D

class_name Projectile

var velocity = Vector2(1, 0)
var speed = 300

func _physics_process(delta):
	var collision_info = move_and_collide(velocity.normalized() * delta * speed)


func get_class():
	return "Projectile"
