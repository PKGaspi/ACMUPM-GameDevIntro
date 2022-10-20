extends CharacterBody2D

const SPEED = 50 # Píxeles / segundo.

var target
var hp = 2


func _physics_process(delta):
    if is_instance_valid(target):
        # Moverse hacia to_follow
        var move_dir = global_position.direction_to(target.global_position)
        rotation = move_dir.angle()
        velocity = move_dir * SPEED
        move_and_slide()
        var collision = get_last_slide_collision()
        if collision and collision.get_collider().has_method("take_damage"):
            collision.get_collider().take_damage()
        
func take_damage():
    hp -= 1
    # Comprobar si me muero.
    if hp <= 0:
        die() # Me muero.

func die():
    queue_free() # Borrar de la escena principal.
