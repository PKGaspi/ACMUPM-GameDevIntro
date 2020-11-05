# Introducción

## Godot
Godot es un motor de videojuegos gratuito, multiplataforma y de código abierto. Es lo que usaremos para hacer nuestro juego en este taller. Puedes aprender más sobre godot y descargarlo desde su página web: godotengine.org.

Antes de empezar con nuextro juego vamos a ver unos conceptos básicos sobre Godot.

### Crear Proyecto
Nada más iniciar Godot nos aparece una pantalla de bienvenida con nuestros proyectos más recientes. En el panel de la derecha podemos buscar proyectos existentes o crear uno nuevo. 

Vamos a crear un proyecto desde cero. Al pulsar el botón nos pide indicar la ruta donde guardar el proyecto y qué motor de renderizado queremos usar. Elige la ruta que quieras y en el renderizador deja marcado OpenGL ES 3.0.

### Interfaz
Al confirmar la pantalla anterior nos encontramos con el editor de Godot. Aquí es donde se cocina la magia. Podemos distinguir cuatro paneles.

![primera vista de godot](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/001.png?raw=true)

1.- Vista principal: aquí podremos ver nuestra escena y nuestro código. Más adelante vemos lo que es una escena.
2.- Explorador de archivos: un navegador simple que muestra los archivos de nuestro proyecto.
3.- Árbol de la escena: los nodos que pertenecen a cada escena aparecerán aquí. De nuevo, más sobre nodos y escenas más adelante.
4.- Inspector: ver y editar información sobre el nodo o recurso seleccionado.

Además, algunos de los paneles tienen varias pestañas. En el panel amarillo 3 vemos también la pestaña Importación y en el morado 4 la pestaña Nodos. Las explicaré conforme las vayamos usando.

### Importar assets
Lo primero que vamos a hacer en nuestro proyecto es importar los assets. He preparado unos pocos muy simples para este taller, pero puedes hacer los tuyos propios si prefieres. [Descarga mis assets aquí](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/tree/master/assets).

**Nota.-** *Con los ficheros `.png` es suficiente.*

Para importar los assets basta con moverlos a alguna carpeta del proyecto. Puedes hacerlo mediante tu explorador de archivos o arrastrarlos al panel de Godot. A mí me gusta guardarlos bajo la carpeta `assets/`, separando luego sprites de sonidos y música.

Por último, conviene comprobar las opciones de importación seleccionando un sprite en el explorador de archivos y cambiando a la pestaña Importación del panel amarillo 3. Para sprites de un tamaño pequeño como los nuestros, conviene desactivar filtrado bilineal. Después reimportamos el sprite y hacemos esto con los otros dos. También podemos cambiar el *preset* o plantilla para los próximos sprites que importemos en este proyecto.

![opciones de importación](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/002.png?raw=true)

### Ajustes de proyecto
Vamos a cambiar algunos ajustes (Proyecto -> Ajustes de Proyecto).
Bajo Display -> Window:
- Size
    + Width: 480
    + Height: 270
- Stretch
    + Mode: 2D
    + Aspect: Keep

### Nodos, Escenas y Programación Orientada a Objetos

# Programando el juego

## Introducción básica a GDScript
## Rotación
[//]: <> (TODO: Juntar todo lo básico del jugador en una sección)

Empezaremos por algo básico. Vamos a hacer que nuestro jugador esté siempre apuntando hacia el cursor.

```
func _physics_process(delta: float):
    rotation = get_local_mouse_position().angle()
```

Si ejecutamos la escena (F6 o Reproducir Escena arriba a la derecha) nos encontramos con nuestro primer *bug*. El personaje no apunta hacia el ratón como teníamos planeado. Resulta que al rotarlo estamos rotando también los ejes de coordenadas locales, y por lo tanto, las coordenadas locales del cursor son distintas en cada fotograma.

Para evitar esto podemos usar las coordenadas globales.

``` 
func _physics_process(delta: float):
    rotation = global_position.direction_to(get_global_mouse_position()).angle()
```

## Escena principal 
[//]: <> (TODO: Mover esto a lo primero)

Hay prepararlo todo para ejecutar el juego por primera vez. Vamos a crear una nueva escena, yo le suelo dar de nombre `Main.tscn` o `Game.tscn`. El nodo raíz va a ser de tipo `Node`. De momento vamos a darle un nodo hijo de tipo `Node2D` y lo llamaremos *World*. Como hijo de *World* podemos poner la escena de nuestro jugador, arrastrando `Player.tscn` hacia el nodo *World*. Podéis mover al personaje por el escenario para que no se quede en la esquina.

[//]: <> (TODO: Añadir imagen)

Ya tenemos la escena principal preparada. Vamos a ejecutarla pulsando F5 o el botón de Reproducir arriba a la derecha. La primera vez nos pedirá establecer una escena principal, elegiremos la que acabamos de crear.

## Acciones

Primero vamos a echar un vistazo al Mapa de Entrada (Proyecto -> Ajustes del Proyecto -> Mapa de Entrada). Aquí podemos añadir acciones y asociarles eventos. Vamos a añadir cinco eventos, cuatro para movimiento y otro para disparar.

[//]: <> (TODO: Añadir imágenes)

**Nota.-** *Para añadir una acción, escribe el nombre de la acción en el campo de arriba y dale al botón de Añadir de la derecha. Para añadir eventos a una acción, busca la acción y pulsa el botón "+" que tiene a la derecha.*

## Movimiento

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

## Disparo

Antes de plantearnos cómo disparar... Necesitaremos algo que disparar, ¿no? Vamos a crear una escena para representar una bala. La raíz será un nodo Area2D y tendrá un nodo Sprite y un nodo CollissionShape2D de hijos.

[//]: <> (TODO: Añadir imagen)

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

Ahora que le hemos añadido lógica a la bala, toca hacer que el personaje dispara al hacer click. Esto, en otras palabras, sería crear una *instancia* de la escena `Bullet.tscn`. Para ello vamos volvemos al script del jugador. Godot nos proporciona unos métodos muy util para manejar los inputs, `_input(event)` y `_unhandeled_input(event)`. La diferencia entre ambos es un poco sutil, pero para esto nos viene mejor el segundo. Este método se llama cuando hay un evento de input que no ha sido tratado, y dentro del mismo podemos comprobar de qué evento se trata. En particular nos interesa un evento relacionado con la acción `shoot` (la cual hemos definido antes).

```
func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("shoot"):
        shoot() # Disparar.
```

Ahora mismo nuestro código está incompleto. He hecho referencia a un método `shoot()` que no está definido. Lo tenemos que crear nosotros. Este método es el que va a instanciar la bala. En Godot esto se hace de una manera un poco peculiar y que asusta un poco al principio. Los pasos a seguir son crear una instancia de la escena `Bullet.tscn`, darle las propiedades que nos interesan y añadirlas a algún lugar de la escena principal. Para crear una instancia de una escena tendremos que cargar dicha escena anteriormente. Al final nos queda algo así:

```
# Cargar la escena de la bala.
const BULLET = preload("res://src/Bullet.tscn")

[...]

func shoot():
    # Crear nueva instancia.
    var bullet = BULLET.instance() 
    # Dar propiedades a la nueva instancia de la bala.
    bullet.rotation = rotation
    bullet.position = position
    # Añadir la bala como hijo del nodo padre.
    get_parent().add_child(bullet)
```

Todo esto ha sido mucho de golpe para una simple bala, ¿no? Ahora mismo ya debería estar todo. ¡Toca probar si funciona!

### Optimización

Si ejecutamos el juego y disparamos unas cuantas balas, vemos que rápidamente se salen de la ventana visible. No obstante, las instancias de dichas balas siguen ahí. Siguen consumiendo recursos de nuestro ordenador y, a la larga, podríamos tener miles o millones de balas. Para ello, vamos a hacer que las balas se "destruyan" o desaparezcan al salir de la ventana de juego.

[//]: <> (TODO: Añadir imagen)

Añadimos un nodo hijo a la bala de tipo `VisibilityNotifier2D`. Este tipo de nodo son muy útiles cuando queremos monitorizar si una instancia de un objeto sale o entra en pantalla. Vamos a aprovecharnos de la señal `screen_exited`, la cual es emitida cuando el nodo sale de la pantalla. Conectamos la señal a un nuevo método.

[//]: <> (TODO: Añadir imágenes de cómo conectar la señal.)

Y rellenamos el cuerpo del método con la función `queue_free()`, la cual elimina un nodo de la escena.

```
func _on_VisibilityNotifier2D_screen_exited() -> void:
    # La bala se ha salido de la pantalla. 
    queue_free() # Borrar esta instancia.
```

## Enemigo

Ahora que ya podemos movernos y disparar necesitamos algo de lo que huir y a lo que disparar. Vamos a hacer unos enemigos simples que sigan al jugador. Para ello creamos una nueva escena `Enemy.tscn` con los mismos nodos que en `Player.tscn` (raíz KinematicBody2D, hijos Sprite y CollisionShape2D) y le damos un nuevo script `Enemy.gd`. El código de los enemigos es bastante parecido a lo que ya hemos visto, solo que en este caso usaremos `move_and_collide()` para el movimiento.

```
extends KinematicBody2D

const SPEED = 50 # Píxeles / segundo.

var to_follow


func _physics_process(delta: float) -> void:
    if is_instance_valid(to_follow):
        # Moverse hacia to_follow
        var move_dir = global_position.direction_to(to_follow.global_position)
        rotation = move_dir.angle()
        move_and_collide(move_dir * SPEED * delta)
```

**Nota.-** *Observa que esta vez estamos usando `move_and_collide()`. Este método exige que el movimiento sea multiplicado por el parámetro delta a diferencia de `move_and_slide()`.*

Si añadimos un enemigo a la escena principal veremos que no se mueve. Esto es porque la variable `to_follow` está sin inicializar, y por tanto el enemigo no tiene objetivo que seguir. Le daremos valor a esta variable desde un nuevo script en el nodo *World* de la escena principal, `World.gd`.

```
extends Node2D


onready var _player = $Player
onready var _enemy = $Enemy


func _ready() -> void:
    _enemy.to_follow = _player
```

Ahora el enemigo persigue al jugador, pero este no reacciona a las balas que le disparamos, y el jugador tampoco recibe daño si el enemigo choca con nosotros. Para ello tendremos que añadir nueva lógica a las balas, el personaje y el enemigo.

## Colisiones

Godot ya nos ofrece un sistema de colisiones muy robusto. Como hemos podido probar, el enemigo se detiene al chocar con el personaje del jugador y viceversa. Sin embargo, sería lógico que el jugador recibiera daño al chocar con un enemigo. Vamos a ver cómo podemos detectar estos casos.

Vamos a empezar añadiendo una variable `hp` (que significa *hit points*) para controlar cuánta vida le queda a nuestro jugador o enemigo. También añadiremos unas funciones muy simples para recibir daño y morir. Tanto en `Player.gd` como en `Enemy.gd`:

```
var hp = 3

[...]

func take_damage():
    hp -= 1
    # Comprobar si me muero.
    if hp <= 0:
        die() # Me muero.


func die():
    queue_free() # Borrar de la escena principal.
```

Al jugador he decidido darle 3 puntos de vida y al enemigo tan solo 1. Ahora, cuando ocurra una colisión con una bala o con un enemigo, tendremos que llamar a la función `take_damage()` de la instancia que debería recibir daño.

Primero vamos con la bala. Los nodos de tipo `Area2D` tienen varias señales que emiten en función de si un cuerpo o área entra en su porpia área, es decir, si colisionan con algo. En este caso nos interesa la señal `body_entered`, que se emite cuando un cuerpo (como un `KinematicBody2D`) entra en contacto con el `Area2D`. Vamos a conectar dicha señal a un nuevo método:

```
func _on_Bullet_body_entered(body: Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage()
        queue_free()
```

Si probamos el juego ahora mismo y disparamos veremos que las balas no aparecen... Es más, cuando disparamos una tercera bala nuestra nave desaparece. ¿Qué ocurre? Parece ser que hemos introducido un nuevo *bug* en el código. La bala no ignora la colisión con nuestra nave, por lo que nos estamos haciendo daño a nosotros mismos.

Para tratar esto, Godot tiene un sistema de capas y máscaras de colisión. Vamos a crear 3 capas de colisión: *player*, *enemy* y *player_bullet*. Solo con crear las capas no basta, hay que añadir nuestros nodos a las capas a las que nos interesa, y también indicarles con qué capas deben colisionar.

[//]: <> (TODO: Añadir imágenes de crear capas de colisión y bits.)

Con esto ya debería funcionar todo como esperábamos. Las balas no colisionan con nuestra nave, pero sí con la enemiga.

Por último, vamos a hacer que el enemigo haga daño a nuestra nave al chocar con nosotros. Podemos obtener información de la colisión al mover un cuerpo con el valor que devuelve `move_and_collide()`. Vamos a cambiar un poco el código del enemigo:

```
func _physics_process(delta: float) -> void:

    [...]

        var collision = move_and_collide(move_dir * SPEED * delta)
        if collision and to_follow.has_method("take_damage") and collision.collider == to_follow:
            to_follow.take_damage()
```

El código tiene sentido... ¿No? Sin embargo, al probarlo parece que nuestra nave muere de un solo golpe. ¿Qué está pasando? Como hemos visto al principio, el método `_physics_process(delta)` se ejecuta en cada fotograma en el que se deban procesar las físicas. Esto es, por defecto, 60 fotogramas cada segundo. Como nuestra nave solo tiene 3 puntos de vida, esta muere en tan solo 3 fotogramas. Tenemos que añadir un temporizador que evite recibir daño de forma tan seguida. Esto, en el mundo del desarrollo de videojuegos, se conoce como *frames de invencibilidad* o *iframes*. 

Para implementar esto vamos a añadirle a la nave del jugador un nodo de tipo `Timer`. La función de este nodo es muy sencilla, llevar cuenta de un temporizador. Le podemos poner estos parámetros.

[//]: <> (TODO: Añadir imagen del nodo Timer)

- `wait_time`: el tiempo del temporizador. Cuando llegue a 0 emitirá la señál `timeout`.
- `one_shot`: indica si queremos que el temporizador se quede parado al llegar a 0 (*True*) o si queremos que vuelva a contar desde `wait_time` (*False*). 
- `autostart`: si está a *True* el temporizador empezará a contar cuando el nodo entre en la escena. Si está a *False* solo lo hará al llamar al método `start()`.

Ahora que tenemos el temporizador tenemos que añadir la lógica al código.

```
# Para acceder al nodo InvencibilityTimer.
onready var _invencibility_timer = $InvencibilityTimer

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
```


Ahora sí, la nave aguanta bastante más de 3 fotogramas.

## Interfaz

El jugador debería poder ver en todo momento cuánta vida le queda a su nave. Vamos a hacer una interfaz sencilla que haga el trabajo. Godot tiene una serie de nodos diseñados justo para esto, los nodos que heredan de `Control` (los verdes). Vamos a añadir nuevos nodos a nuestra escena principal. Un nodo `Control` llamado *UI* y un nodo `ProgressBar` llamado *HPBar*.

[//]: <> (TODO: Añadir imagen de los nuevos nodos)

Estos nodos tienen mogollón de variables de configuración, pero de momento vamos a ignorar la gran mayoría. Vamos a seleccionar el nodo *UI*. En la parte superior aparece un botón que dice *Layout*. Lo pulsamod para desplegar un menú y elegimos *Completo* para que el nodo ocupe toda la parte visible de la escena.  Ajustamos también el tamaño de *HPBar* para que sea bien visible y le damos los siguientes valores.

[//]: <> (TODO: Añadir imagen de los valores de HPBar)

Además, vamos a darle un script a *HPBar* para que monitorize la variable `hp` del nodo que le digamos. En `HPBar.gd`:

```
extends ProgressBar


var to_monitor

func _process(delta):
    if is_instance_valid(to_monitor):
        value = to_monitor.hp
    else:
        value = 0
```

Por último, tenemos que darle valor a la variable `to_monitor`. Esto lo haremos desde el nodo *Main*, la raíz de la escena principal. Le damos script a este nodo (`Main.gd`) y añadimos lo siguiente:

```
extends Node

onready var _player = $World/Player
onready var _hp_bar = $UI/HPBar

func _ready() -> void:
    _hp_bar.to_monitor = _player
```

# Conclusión

Ahora mismo no tenemos un juego terminado, pulido y que podamos encontrar a la venta. Este no era el objetivo de este taller, sino tener algo jugable hecho por uno mismo.

Después de lo anterior, deberías saber:

- Los conceptos básicos del desarrollo y la programación de videojuegos.
- Crear escenas y nodos en *Godot*.
- Programar utilizando *GDScript*.
- La diferencia entre un objeto y una instancia.
- Pensar en la lógica necesaria para un videojuego e implementarla.
- Cómo identificar y solucionar bugs.

# Para continuar

Te reto a continuar con el desarrollo de este juego. Aquí tienes una lista de ideas que implementar, aunque puedes añadir y cambiar todo lo que quieras. 

- **Fondo**: Buscar un *background* molón y ponerlo de fondo. Es importante que no distraiga mucho y que aún así se puedan ver las balas y los personajes con claridad.
- **Salir del juego**: Hacer una forma sencilla de cerrar el juego. Por ejemplo, manteniendo pulsada la tecla *Esc* durante un segundo.
- **Puntuación**: Dar puntos al jugador al matar a un enemigo. Mostrar los puntos en la interfaz del juego.
- **Sonidos al disparar**: Echa un vistazo a [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html), en particular al nodo `AudioStreamPlayer2D`. Para hacer sonidos de forma rápida puedes utilizar [bfxr](https://www.bfxr.net/).
- **Fuego rápido**: Disparar un chorro de balas al mantener pulsado el botón de disparo, en lugar de disparar una bala por click. Limitar el número de balas por segundo que se disparan.
- **Pantalla de título y de *Game Over***: Puedes utilizar nodos `Control` para mostrar mensajes de manera sencilla.
- **Balas enemigas**: Hacer que los enemigos disparen al personaje del jugador cada cierto tiempo.
- **Animación de morir**: Al morir una nave molaría que generara una explosión. Puedes probar con unas cuantas [partículas](https://docs.godotengine.org/en/stable/classes/class_particles2d.html#class-particles2d). Ah, también debería hacer algún ruido.
- **Aparición de enemigos**: Poner todos los enemigos de uno en uno no es efectivo. Hay que hacer que aparezcan más enemigos de forma automática al matar los que ya hay. Se puede hacer de forma parecida a como creamos las balas.

Están ordenados (más o menos) por orden de dificultad. No te preocupes si no puedes con alguno de ellos. Para cualquier cosa, al final de estas notas están mis redes y métodos de contacto. ¡Estaré encantado de ayudaros y ver vuestros resultados!

# Contacto
Si todavía no estás apuntado a ACM, ¿a qué esperas? Es gratis y hacemos cosas de este tipo a menudo. Te recomendamos echarle un vistazo a los siguientes enlaces:

- Página Web: https://upm.acm.org/
- Telegram de GameDev: https://t.me/joinchat/GXu1OFCoE3drXGvjxQlfKg

Si después del taller te quedas con alguna duda, me la puedes preguntar por:
- Twitter: [@_Gaspi](https://twitter.com/_gaspi)
- Telegram: [@PK_Gaspi](https://t.me/PK_Gaspi)
