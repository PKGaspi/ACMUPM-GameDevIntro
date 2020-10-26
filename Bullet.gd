extends Area2D

const SPEED = 500 # Píxeles / segundo.

var move_dir = Vector2.RIGHT

func _ready() -> void:
	# Calcular la dirección de movimiento en función de la rotación.
	move_dir = Vector2(cos(rotation), sin(rotation))


func _physics_process(delta: float) -> void:
	# Mover la bala.
	position += move_dir * SPEED * delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	# La bala se ha salido de la pantalla. 
	queue_free() # Borrar esta instancia.
