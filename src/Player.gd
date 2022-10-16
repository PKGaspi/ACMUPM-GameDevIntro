extends CharacterBody2D


const SPEED = 200 # Píxeles / segundo.
# Cargar la escena de la bala.
const BULLET = preload("res://src/Bullet.tscn")


var hp = 3
# Para acceder al nodo InvencibilityTimer.
@onready var _invencibility_timer = $InvencibilityTimer



func _physics_process(delta):
	# Rotar el jugador para que mire al cursor.
	rotation = global_position.direction_to(get_global_mouse_position()).angle()
	
	# Calcular la dirección de movimiento.
	var input_dir = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	).normalized()
	
	# Mover.
	set_velocity(input_dir * SPEED)
	move_and_slide()


func _unhandled_input(event):
	if event.is_action_pressed("shoot"):
		shoot() # Disparar.


func shoot():
	# Crear nueva instancia.
	var bullet = BULLET.instantiate() 
	# Dar propiedades a la nueva instancia de la bala.
	bullet.rotation = rotation
	bullet.position = position
	# Añadir la bala como hijo del nodo padre.
	get_parent().add_child(bullet)


func take_damage():
	# Comprobar si la nave es invencible.
	if _invencibility_timer.is_stopped():
		# No es invencible, recibir daño.
		hp -= 1
		# Iniciar temporizador de invencibilidad.
		_invencibility_timer.start()
		# Comprobar si me muero.
		if hp <= 0:
			die() # Me muero.


func die():
	queue_free() # Borrar de la escena principal.
