extends KinematicBody2D


const SPEED = 200

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float):
#	pass


func _physics_process(delta: float):
	# Rotar el jugador para que mire al cursor.
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	# Calcular la dirección de movimiento.
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	# Mover.
	move_and_slide(input_dir * SPEED)


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		shoot()


func shoot():
	pass
