
# Introducción

## Introducir Godot
## Descargar Godot
## Crear Proyecto
## Interfaz de Godot
### Importar assets
Opciones de importado (desactivar filtrado bilineal)
### Ajustes de proyecto
Vamos a cambiar algunos ajustes (Proyecto -> Ajustes de Proyecto).
Bajo Display -> Window:
- Size
    + Width: 480
    + Height: 270
- Stretch
    + Mode: 2D
    + Aspect: Keep
## Orientación a objetos

# Programar el juego

## Crear Jugador
### Nodos
### Script
#### Introducción básica a GDScript
#### Rotación

Empezaremos por algo básico. Vamos a hacer que nuestro jugador esté siempre apuntando hacia el cursor.

```
func _physics_process(delta: float):
    rotation = get_local_mouse_position().angle()
```

Si ejecutamos el juego nos encontramos con nuestro primer bug. El jugador está rotando continuamente. Resulta que al rotar el jugador rotamos también el los ejes de coordenadas locales, y por lo tanto, las coordenadas locales del cursor son distintas.

Para evitar esto podemos usar las coordenadas globales.

``` 
func _physics_process(delta: float):
    rotation = global_position.direction_to(get_global_mouse_position()).angle()
```

#### Acciones

Primero vamos a echar un vistazo al Mapa de Entrada (Proyecto -> Ajustes del Proyecto -> Mapa de Entrada). Aquí podemos añadir acciones y asociarles eventos. Vamos a añadir cinco eventos, cuatro para movimiento y otro para disparar.

[//]: < (TODO: Añadir imágenes)

**Nota.-** *Para añadir una acción, escribe el nombre de la acción en el campo de arriba y dale al botón de Añadir de la derecha. Para añadir eventos a una acción, busca la acción y pulsa el botón "+" que tiene a la derecha.*

#### Movimiento

Ahora volvamos al script de nuestro personaje. Vamos a calcular la dirección en la que el jugador quiere mover a su personaje. Para ello usaremos la clase Input. Esta clase nos facilita el método `get_action_strength(action)`, el cual nos devuelve un valor entre 0 y 1 según si algún evento está activando la acción `action` o no. En otras palabras, `get_action_strength("move_left")` devolverá 1 si el jugador está pulsando la tecla A o la flecha izquierda y 0 en otro caso.

```
func _physics_process(delta: float):

    [...]

    # Calcular la dirección de movimiento.
    var input_dir = Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    ).normalized()
```

Hemos creado una variable `input_dir` que contiene un vector de 2 coordenadas (`x`, `y`) y representa la dirección del input de movimiento marcado por el jugador en este fotograma. Por lo tanto, esta es la dirección en la que queremos mover a nuestro personaje. El valor `x` de `input_dir` lo calculamos restando la fuerza de la acción `move_left` a la fuerza de la acción `move_right`. Por lo tanto, `x` nos queda con uno de estos valores:
- 1 si se está pulsando hacia la derecha.
- -1 si se está pulsando hacia la izquierda.
- 0 si no se pulsa nada o se pulsa hacia derecha e izquierda.
El valor `y` se calcula con una resta semejante. Por último, normalizamos el vector (mediante `Vector2.normalized()`) ya que este es solo una dirección.

Ahora que tenemos la dirección en la que se quiere mover el jugador y la velocidad a la que se mueve el personaje (declarada en la constante `SPEED` arriba del todo), nos falta aplicar el movimiento.

```
func _physics_process(delta: float):

    [...]

    # Mover.
    move_and_slide(input_dir * SPEED)
```

#### Disparo

Antes de plantearnos cómo disparar... Necesitaremos algo que disparar, ¿no? Vamos a crear una escena para representar una bala. La raíz será un nodo Area2D y tendrá un nodo Sprite y un nodo CollissionShape2D de hijos.

[//]: < (TODO: Añadir imagen)

Como con el personaje, vamos a añadirle un script a la bala. De momento solo vamos a hacer que se mueva.

```
extends Area2D

const SPEED = 500 # Píxeles / segundo.

var move_dir = Vector2.RIGHT


func _ready() -> void:
    # Calcular la dirección de movimiento en función de la rotación.
    move_dir = Vector2(cos(rotation), sin(rotation))


func _physics_process(delta: float) -> void:
    # Mover la bala.
    position += move_dir * SPEED * delta
```

¿Por qué no usar el método `move_and_slide()` como con el personaje? Porque ese es un método para los nodos `KinematicBody2D` que no sirve para nuestro nodo `Area2D`, así que vamos a modificar directamente el valor de la variable `position`.

#### Optimización

Si ejecutamos el juego y disparamos unas cuantas balas, vemos que rápidamente se salen de la ventana visible. No obstante, las instancias de dichas balas siguen ahí. Siguen consumiendo recursos de nuestro ordenador y, a la larga, podríamos tener miles o millones de balas. Para ello, vamos a hacer que las balas se "destruyan" o desaparezcan al salir de la ventana de juego.


[//]: < (TODO: Añadir imagen)

Añadimos un nodo hijo a la bala de tipo `VisibilityNotifier2D`. Este tipo de nodo son muy útiles cuando queremos monitorizar si una instancia de un objeto sale o entra en pantalla. Vamos a aprovecharnos de la señal `screen_exited`, la cual es emitida cuando el nodo sale de la pantalla. Conectamos la señal a un nuevo método.

[//]: < (TODO: Añadir imágenes de cómo conectar la señal.)

Y rellenamos el cuerpo del método con la función `queue_free()`, la cual elimina un nodo de la escena.

```
func _on_VisibilityNotifier2D_screen_exited() -> void:
    # La bala se ha salido de la pantalla. 
    queue_free() # Borrar esta instancia.
```
