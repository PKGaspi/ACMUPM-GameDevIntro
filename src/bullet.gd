extends Area2D

const SPEED = 500 # Píxeles / segundo.

var move_dir


func _ready():
    # Calcular la dirección de movimiento en función de la rotación.
    move_dir = Vector2(cos(rotation), sin(rotation))


func _physics_process(delta):
    # Mover la bala.
    position += move_dir * SPEED * delta # Física de 4º de la ESO chavales


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
    # La bala se ha salido de la pantalla. 
    queue_free() # Libera esta instancia.


func _on_body_entered(body: Node2D) -> void:
    if body.has_method("take_damage"):
        body.take_damage()
        queue_free()
