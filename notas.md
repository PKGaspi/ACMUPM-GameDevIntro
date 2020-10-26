
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