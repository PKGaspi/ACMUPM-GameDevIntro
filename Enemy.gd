extends KinematicBody2D

const SPEED = 50 # Píxeles / segundo.

var to_follow


func _physics_process(delta: float) -> void:
	if is_instance_valid(to_follow):
		# Moverse hacia to_follow
		var move_dir = global_position.direction_to(to_follow.global_position)
		rotation = move_dir.angle()
		move_and_collide(move_dir * SPEED * delta)
