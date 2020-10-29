extends KinematicBody2D

var hp = 1

const SPEED = 50 # Píxeles / segundo.

var to_follow


func _physics_process(delta: float) -> void:
	if is_instance_valid(to_follow):
		# Moverse hacia to_follow
		var move_dir = global_position.direction_to(to_follow.global_position)
		rotation = move_dir.angle()
		var collision = move_and_collide(move_dir * SPEED * delta)
		if collision and to_follow.has_method("take_damage") and collision.collider == to_follow:
			to_follow.take_damage()


func take_damage():
	hp -= 1
	# Comprobar si me muero.
	if hp <= 0:
		die() # Me muero.


func die():
	queue_free() # Borrar de la escena principal.
