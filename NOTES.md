# Introducción
Bienvenido al taller de Introducción al desarrollo de videojuegos. Mi objetivo es que salgas de aquí con tu pequeño primer proyecto, el cual te servirá para aprender lo básico y despejarte de dudas.

Estas notas nos guiarán por el taller. Si te pierdes, échales un vistazo. Si no te da tiempo a terminar hoy, deberías poder continuar siguiendo las notas. Si tienes alguna pregunta durante el taller, no dudes en pararme para preguntar. Si te surge la duda después de acabar, al final del todo puedes encontrar cómo contactar conmigo.

## Godot
Godot es un motor de videojuegos gratuito, multiplataforma, 3D/2D y de código abierto. Es lo que usaremos para hacer nuestro juego en este taller. Puedes aprender más sobre Godot y descargarlo desde su página web: [godotengine.org](godotengine.org). Si necesitas más información sobre algo en particular, puedes echarle un ojo a su [documentación](https://docs.godotengine.org/es/stable/) (aunque lanzarme una pregunta o una búsqueda en Google igual te lo soluciona antes).

Antes de empezar con nuestro juego vamos a ver unos conceptos básicos sobre Godot.

### Crear Proyecto
Nada más iniciar Godot nos aparece una pantalla de bienvenida con nuestros proyectos más recientes. En el panel de la derecha podemos buscar proyectos existentes o crear uno nuevo. 

Vamos a crear un proyecto desde cero. Al pulsar el botón nos pide indicar la ruta donde guardar el proyecto y qué motor de renderizado queremos usar. Elige la ruta que quieras y en el renderizador deja marcado OpenGL ES 3.0.

### Interfaz
Al confirmar la pantalla anterior nos encontramos con el editor de Godot. Aquí es donde se cocina la magia. Podemos distinguir cuatro paneles.

![primer vistazo de godot](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/001.png?raw=true)

1. **Vista principal**: aquí podremos ver nuestra escena y nuestro código. Más adelante vemos lo que es una escena.
2. **Explorador de archivos**: un navegador simple que muestra los archivos de nuestro proyecto.
3. **Árbol de la escena**: los nodos que pertenecen a cada escena aparecerán aquí. De nuevo, más sobre nodos y escenas más adelante.
4. **Inspector**: ver y editar información sobre el nodo o recurso seleccionado.

Además, algunos de los paneles tienen varias pestañas. En el panel Amarillo 3 vemos también la pestaña Importación y en el Morado 4 la pestaña Nodos.

### Importar assets
Lo primero que vamos a hacer en nuestro proyecto es importar los assets. He preparado unos pocos muy simples para este taller, pero puedes hacer los tuyos propios si prefieres. [Descarga mis assets aquí](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/tree/master/assets/sprites).

**Nota.-** *Con los ficheros `.png` es suficiente.*

Para importar los assets basta con moverlos a alguna carpeta del proyecto. Puedes hacerlo mediante tu explorador de archivos o arrastrarlos al panel Verde 2 de Godot. A mí me gusta guardarlos bajo la carpeta `assets/`, separando luego sprites de sonidos y música.

Conviene comprobar las opciones de importación. Selecciona un sprite en el explorador de archivos y cambia a la pestaña Importación del panel Amarillo 3. Para sprites de un tamaño pequeño como los nuestros, conviene desactivar el filtrado bilineal. Después reimportamos el sprite y hacemos esto con los otros dos. También podemos cambiar el *preset* o plantilla para los próximos sprites que importemos en este proyecto.

![opciones de importación](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/002.png?raw=true)

### Ajustes de proyecto
Vamos a cambiar algunos ajustes del proyecto antes de empezar.

Proyecto -> Ajustes de Proyecto -> Window:
- Size
    + Width: 480
    + Height: 270
- Stretch
    + Mode: 2D
    + Aspect: Keep

### Nodos y Escenas
Vamos a repasar un poco de programación orientada a objetos antes de ver lo que son los nodos y las escenas. A groso modo significa utilizar objetos como metáforas de los datos a representar en nuestro programa. Un objeto puede ser, por ejemplo, un coche. De un coche nos puede interesar guardar su marca, modelo, color, dueño, matrícula, etc. Una instancia de este objeto puede ser mi coche, con unos datos ya establecidos (Ford Fiesta rojo, matrícula 1234 BCD), el coche de mi hermana, el de mi vecino, etc.

Después de esta mediocre explicación, podemos fácilmente asociar los objetos con los nodos de Godot. A fin de cuentas, un nodo es un objeto. Godot nos trae de fábrica varios nodos ya hechos, que nos facilitan tareas comunes en el desarrollo de videojuegos (como personajes que obedecen físicas o interfaces).

Una escena es, en su esencia, un conjunto de nodos en estructura de árbol. Los nodos en una escena se pueden comunicar entre sí.

### GDScript
GDScript es uno de los lenguajes en los que podemos programar en Godot. Está basado en Python, así que puede que te resulte familiar. Aquí tienes una pequeña muestra de código para que te hagas a la idea.
```GDScript
# Esta línea empieza por '#', así que es un comentario.

# Hay que utilizar la palabra var para definir una variable.
# No hay que especificar el tipo de variable.
var name = "Juan"
var age = 21 * 365 * 24 * 60 * 60 # En segundos
var smart = true


# La palabra func sirve para definir una función o método.
func my_func(arg0, arg1):
    # Es obligatorio el indentado.
    return arg0 + arg1


# Este método se llama una vez cuando el nodo
# entra en la escena principal.
func _ready():
    var number = my_func(age, 3)
    # Imprimir en la consola
    print("Hello world!")


# Este método se llama en cada fotograma en el que se
# procesen físicas (60 fps por defecto). El parámetro
# delta es el tiempo que ha pasado entre esta llamada
# y la anterior en segundos.
func _physics_process(delta):
    age += delta
```
Para más información y ejemplos de GDScript, consulta su página en la [documentación](https://docs.godotengine.org/es/stable/getting_started/scripting/gdscript/gdscript_basics.html).


# Programando el juego
Ahora ya sí que sí, vamos a ponernos manos a la obra. El juego que vamos a hacer es un shooter básico de vista aérea. Controlamos una nave espacial y varias naves enemigas tratan de eliminarnos.

Vamos a seguir a partir del proyecto que ya hemos creado.

## Escenas *Player* y *Main*
Vamos a empezar creando un par de escenas, *Player* y *Main*.

En el panel del Árbol de la Escena (Amarillo 3) podemos elegir el nodo raíz de la escena. Como nodo raíz vamos a elegir Otro Nodo, y dentro de este menú elegimos un nodo de tipo `KinematicBody2D`. Este tipo de nodo está pensado para obedecer a físicas, moverse y detectar colisiones. Vamos a darle un nodo hijo de tipo `Sprite` y otro de tipo `CollisionShape2D`. Configuramos estos dos últimos nodos en el panel Inspector (Morado 4) con la textura de nuestra nave y una forma para la colisión. Para guardar la escena, pulsa Ctrl + S. Te recomiendo guardarla con el nombre `Player.tscn` en una carpeta llamada `src`.

![escena main](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/003.png?raw=true)

Para la escena *Main* nos interesa un simple nodo raíz de tipo `Node` (Otro Nodo -> Node) y de nombre le pondremos *Game*. Como hijo tendrá un nodo de tipo `Node2D` llamado *World*. El nodo *World* tendrá como hijo la escena que hemos creado antes, `Player.tscn`. Preuba a mover la escena de nuestra nave para que no se quede en una esquina. Recuerda guardar la escena al terminar.

![escena player](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/004.png?raw=true)

Ahora, ¡podemos ejecutar nuestro juego por primera vez! Todavía no hemos hecho mucho, así que nada realmente emocionante va a pasar. Para hacerlo, pulsamos F5 o el botón de Reproducir arriba a la derecha. La primera vez nos pedirá establecer una escena principal, elegiremos la escena `Main.tscn`.

## Nave del jugador
Nos preparamos para escribir nuestra primera pieza de código en el juego. Tranquilo que no va a ser muy duro. Volvemos a la escena `Player.tscn`, seleccionamos el nodo raíz y le damos al botón de añadir script. 

![añadir script](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/005.png?raw=true)

Nos saldrá una ventana para configurar algunas cosas, pero está todo bien tal y como viene. Le damos a Cargar y se abrirá el nuevo script.

Conviene tener una idea clara de lo que queremos que haga nuestra nave antes de meternos a programar a lo loco. Nuestra nave debería:
1. **Apuntar** hacia el cursor en todo momento.
2. **Moverse** cuando pulsemos las teclas WASD.
3. **Disparar** al hacer click.

### Rotación
Empezaremos por la más sencilla de la lista. Vamos a hacer que nuestra nave esté siempre apuntando hacia el cursor. Podemos controlar la rotación de nuestra nave cambiando el valor de la variable `rotation`. La posición del ratón la podemos obtener mediante `get_local_mouse_position()`, y el ángulo a esa posición con `angle()`.

```GDScript
# Recordatorio: esta función se ejecuta en bucle 60 veces por segundo.
func _physics_process(delta):
    rotation = get_local_mouse_position().angle()
```

Si ejecutamos el juego (F5 o Reproducir arriba a la derecha) nos vamos a encontrar con algo que no mola. La cosa no funciona como esperábamos. Te presento a tu primer *bug*. Resulta que al rotar la nave estamos rotando también sus ejes de coordenadas locales. Por lo tanto, las coordenadas locales del cursor son distintas en cada fotograma.

Para evitar esto podemos usar las coordenadas globales.

``` GDScript
func _physics_process(delta):
    rotation = global_position.direction_to(get_global_mouse_position()).angle()
```

### Movimiento
Primero vamos a echar un vistazo al Mapa de Entrada (Proyecto -> Ajustes del Proyecto -> Mapa de Entrada). Aquí podemos añadir acciones y asociarles eventos. Vamos a añadir cinco eventos, cuatro para movimiento y otro para disparar.

![mapa de entrada](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/006.png?raw=true)

**Para añadir una acción:** *escribe el nombre de la acción en el campo de arriba y dale al botón de Añadir de la derecha. Para añadir eventos a una acción, busca la acción y pulsa el botón "+" que tiene a la derecha.*

Ahora volvamos al script de nuestro personaje. Vamos a calcular la dirección en la que el jugador quiere mover a su personaje. Para ello usaremos la clase `Input`. Esta clase nos facilita el método `get_action_strength(action)`, el cual nos devuelve un valor entre 0 y 1 según haya algún evento activando la acción `action` o no. En otras palabras, `get_action_strength("move_left")` devolverá 1 si el jugador está pulsando la tecla A o la flecha izquierda y 0 en otro caso.

```GDScript
func _physics_process(delta):

    [...]

    # Calcular la dirección de movimiento.
    var input_dir = Vector2(
        Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
        Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
    ).normalized()
```

Hemos creado una variable `input_dir` que contiene un vector de 2 coordenadas (`x`, `y`) y representa la dirección del input de movimiento marcado por el jugador en este fotograma. Por lo tanto, esta es la dirección en la que queremos mover a nuestra nave. El valor `x` de `input_dir` lo calculamos restando la fuerza de la acción `move_left` a la fuerza de la acción `move_right`. Por lo tanto, `x` nos queda con uno de estos valores:
- 1 si se está pulsando hacia la derecha.
- -1 si se está pulsando hacia la izquierda.
- 0 si no se pulsa nada o se pulsa hacia derecha e izquierda a la vez.

El valor `y` se calcula con una resta semejante. Por último, normalizamos el vector (mediante `Vector2.normalized()`).


Vamos a definir la velocidad a la que se moverá la nave. Como no tengo pensado dejar que este valor cambie, lo voy a guardar en una constante llamada `SPEED`.

```GDScript
const SPEED = 200 # Píxeles / segundo.
```
Ahora que tenemos la dirección en la que se quiere mover el jugador y la velocidad a la que se mueve el personaje, nos falta aplicar el movimiento.

```GDScript
func _physics_process(delta):

    [...]

    # Mover.
    move_and_slide(input_dir * SPEED)
```

Ejecuta el juego de nuevo y prueba el movimiento. Si no te gusta la velocidad de la nave siempre puedes retocarla.

### Disparo
Antes de plantearnos cómo disparar... Necesitaremos algo que disparar, ¿no? Es hora de crear una nueva escena. Esta escena representará una bala. La raíz será un nodo `Area2D` y tendrá de hijos un nodo `Sprite` y un nodo `CollissionShape2D`.

Como con el personaje, vamos a añadirle un script al nodo raíz. De momento solo vamos a hacer que se mueva.

```GDScript
extends Area2D

const SPEED = 500 # Píxeles / segundo.

var move_dir = Vector2.RIGHT


func _ready() -> void:
    # Calcular la dirección de movimiento en función de la rotación.
    move_dir = Vector2(cos(rotation), sin(rotation))


func _physics_process(delta) -> void:
    # Mover la bala.
    position += move_dir * SPEED * delta
```

¿Por qué no usar el método `move_and_slide()` como con el personaje? Porque ese es un método para los nodos `KinematicBody2D` que no sirve para nuestro nodo `Area2D`, así que vamos a modificar directamente el valor de la variable `position`.

Ahora que le hemos añadido lógica a la bala, toca hacer que el personaje dispare al hacer click. Esto, en otras palabras, sería crear una *instancia* de la escena `Bullet.tscn`. Volvemos al script `Player.gd`. Godot nos proporciona dos métodos muy útiles para manejar los inputs, `_input(event)` y `_unhandeled_input(event)`. La diferencia entre ambos es sutil, pero para esto nos viene mejor el segundo. Este método se llama cuando hay un input que no ha sido tratado, y dentro del mismo podemos comprobar de qué evento se trata. En particular nos interesa un evento relacionado con la acción `shoot` (la cual ya hemos definido en el Mapa de Entrada).

```GDScript
func _unhandled_input(event: InputEvent):
    if event.is_action_pressed("shoot"):
        shoot() # Disparar.
```

Ahora mismo nuestro código está incompleto. He hecho referencia a un método `shoot()` que no está definido. Lo tenemos que crear nosotros. Este método es el que va a instanciar la bala. En Godot esto se hace de una manera un poco peculiar y que al principio asusta. Los pasos a seguir son:
1. Crear una instancia de la escena `Bullet.tscn`.
2. Darle las propiedades que nos interesen.
3. Añadir la instancia a algún lugar de la escena principal.

Al final nos queda algo así:

```GDScript
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

#### Optimización
Si ejecutamos el juego y disparamos unas cuantas balas, vemos que rápidamente se salen de la ventana visible. No obstante, las instancias de dichas balas siguen ahí. Siguen consumiendo recursos de nuestro ordenador y, a la larga, podríamos tener miles o millones de balas. Para ello, vamos a hacer que las balas se "destruyan" o desaparezcan al salir de la ventana de juego.

Añadimos un nodo hijo a la bala de tipo `VisibilityNotifier2D`. Este tipo de nodo es muy útil cuando queremos monitorizar si una instancia de un objeto sale o entra en pantalla. Vamos a aprovecharnos de la señal `screen_exited`, la cual es emitida cuando el nodo sale de la pantalla. Para conectar la señal, seleccionamos el nuevo nodo en el panel del Árbol de Escena (Amarillo 3) y luego cambiamos a la pestaña Nodos en el panel Morado 4. Doble click en la señal que nos interesa, en este caso `screen_exited`, y en la ventana que nos aparece le damos a Conectar dejando todo como viene. 

**¿Qué es una señal?** *En pocas palabras, un nodo puede emitir una señal para informar de que ha ocurrido algo en particular. Otros nodos pueden escuchar esta señal y actuar en consecuencia.*

![panel de nodos](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/007.png?raw=true)

Al conectar la señal nos aparece la cabecera de un nuevo método. Rellenamos el cuerpo con la función `queue_free()`, la cual libera un nodo de la escena.

```GDScript
func _on_VisibilityNotifier2D_screen_exited() -> void:
    # La bala se ha salido de la pantalla. 
    queue_free() # Libera esta instancia.
```

## Enemigo
Ahora que ya podemos movernos y disparar necesitamos algo de lo que huir y a lo que disparar. Vamos a hacer unos enemigos simples que sigan al jugador. Para ello creamos una nueva escena `Enemy.tscn` con los mismos nodos que en `Player.tscn` (raíz `KinematicBody2D`, hijos `Sprite` y `CollisionShape2D`). Configuramos los nodos y le damos un nuevo script `Enemy.gd` a la raíz. El código de los enemigos es bastante parecido a lo que ya hemos visto, solo que en este caso usaremos `move_and_collide()` para el movimiento.

```GDScript
const SPEED = 50 # Píxeles / segundo.

var to_follow


func _physics_process(delta) -> void:
    if is_instance_valid(to_follow):
        # Moverse hacia to_follow
        var move_dir = global_position.direction_to(to_follow.global_position)
        rotation = move_dir.angle()
        move_and_collide(move_dir * SPEED * delta)
```

**Nota.-** *Observa que esta vez estamos usando `move_and_collide()`. Este método exige que el movimiento sea multiplicado por el parámetro delta a diferencia de `move_and_slide()`.*

Si añadimos un enemigo a la escena principal veremos que no se mueve. Esto es porque la variable `to_follow` está sin inicializar, y por tanto el enemigo no tiene objetivo que seguir. Le daremos valor a esta variable desde un nuevo script en el nodo *World* de la escena principal, `World.gd`.

```GDScript
extends Node2D


onready var _player = $Player
onready var _enemy = $Enemy


func _ready() -> void:
    _enemy.to_follow = _player
```

Ahora el enemigo persigue al jugador, pero este no reacciona a las balas que le disparamos, y el jugador tampoco recibe daño si el enemigo choca con nosotros. Para ello tendremos que añadir nueva lógica a las balas, el personaje y el enemigo.

## Colisiones
Godot ya nos ofrece un sistema de colisiones muy robusto. Como hemos podido probar, el enemigo se detiene al chocar con el personaje del jugador y viceversa. Sin embargo, sería lógico que la nave del jugador reciba daño al chocar con un enemigo. Vamos a ver cómo podemos detectar estos casos.

Vamos a empezar añadiendo una variable `hp` (que significa *hit points*) para controlar cuánta vida le queda a una nave. También añadiremos unas funciones muy simples para recibir daño y morir. Tanto en `Player.gd` como en `Enemy.gd`:

```GDScript
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

A la nave del jugador he decidido darle 3 puntos de vida y al enemigo tan solo 1. Ahora, cuando ocurra una colisión con una bala o con un enemigo, tendremos que llamar a la función `take_damage()` de la instancia que debería recibir daño.

Primero vamos con la bala. Los nodos de tipo `Area2D` tienen varias señales que emiten en función de si un cuerpo o área entra en su propia área, es decir, si colisionan con algo. En este caso nos interesa la señal `body_entered`, que se emite cuando un cuerpo (como un `KinematicBody2D`) entra en contacto con el `Area2D`. Vamos a conectar dicha señal a un nuevo método:

```GDScript
func _on_Bullet_body_entered(body: Node) -> void:
    if body.has_method("take_damage"):
        body.take_damage()
        queue_free()
```

Si probamos el juego ahora mismo y disparamos veremos que las balas no aparecen... Es más, cuando disparamos una tercera bala nuestra nave desaparece. ¿Qué ocurre? Parece ser que hemos introducido un nuevo *bug* en el código. La bala no ignora la colisión con nuestra nave, por lo que nos estamos haciendo daño a nosotros mismos.

Para tratar esto, Godot tiene un sistema de capas y máscaras de colisión. Vamos a crear 3 capas de colisión: *player*, *enemy* y *player_bullet*. Esto se hace en Proyecto -> Ajustes de proyecto -> 2D Physics.

![capas de colisión](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/008.png?raw=true)

Solo con crear las capas no basta, hay que añadir nuestros nodos a las capas a las que nos interesa, y también indicarles con qué capas deben colisionar. Por ejemplo, la bala debe pertenecer a la capa *player_bullets* y que colisione con nodos en la capa *enemy*.

![capa y máscara de colisión de la bala](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/009.png?raw=true)

Piensa en qué capas deberían estar las naves del jugador y enemigo y con cuáles deberían colisionar. Una vez configurado, comprueba que el juego funciona como esperabas.

Ahora toca hacer que el enemigo haga daño a nuestra nave al chocar con nosotros. Podemos obtener información de la colisión al mover un cuerpo con el valor que devuelve `move_and_collide()`. Vamos a cambiar un poco el código del enemigo:

```GDScript
func _physics_process(delta) -> void:

    [...]

        var collision = move_and_collide(move_dir * SPEED * delta)
        if collision and to_follow.has_method("take_damage") and collision.collider == to_follow:
            to_follow.take_damage()
```

El código tiene sentido... ¿No? Sin embargo, al probarlo parece que nuestra nave muere de un solo golpe. ¿Qué está pasando? Como hemos visto al principio, el método `_physics_process(delta)` se ejecuta en cada fotograma en el que se deban procesar las físicas. Esto es, por defecto, 60 fotogramas cada segundo. Como nuestra nave solo tiene 3 puntos de vida, esta muere en tan solo 3 fotogramas. Tenemos que añadir un temporizador que evite recibir daño de forma tan seguida. Esto, en el mundo del desarrollo de videojuegos, se conoce como *fotogramas de invencibilidad* o *iframes*. 

Para implementar esto vamos a añadirle a la nave del jugador un nodo de tipo `Timer`. La función de este nodo es muy sencilla, llevar la cuenta de un temporizador. Le podemos poner estos parámetros.

![parámetros del nodo timer](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/010.png?raw=true)

- `wait_time`: el tiempo inicial del temporizador.
- `one_shot`: indica si queremos que el temporizador se quede parado al llegar a 0 (*True*) o si queremos que vuelva a contar desde `wait_time` (*False*). 
- `autostart`: si está a *True* el temporizador empezará a contar cuando el nodo entre en la escena. Si está a *False* solo lo hará al llamar al método `start()`.

Ahora que tenemos el temporizador tenemos que añadir la lógica al código.

```GDScript
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
Vamos a acabar con una interfaz sencilla. El jugador debería poder ver en todo momento cuánta vida le queda a su nave. Godot tiene una serie de nodos diseñados justo para esto, los nodos que heredan de `Control` (los verdes). Vamos a añadir nuevos nodos a nuestra escena principal. Un nodo `Control` llamado *UI* y un nodo `ProgressBar` llamado *HPBar*.

![escena main](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/011.png?raw=true)

Estos nodos tienen mogollón de variables de configuración, pero de momento vamos a ignorar la gran mayoría. Vamos a seleccionar el nodo *UI*. En la parte superior aparece un botón que dice *Layout*. Lo pulsamos para desplegar un menú y elegimos *Completo* para que el nodo ocupe toda la parte visible de la escena. Ajustamos también el tamaño de *HPBar* para que sea bien visible. A cada nodo le damos estos valores en el Inspector.

![configuración nodo UI](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/012.png?raw=true)
![configuración nodo HPBar](https://github.com/rapsaGnauJ/ACMUPM-GameDevIntro2020/blob/master/.notes/013.png?raw=true)

Además, vamos a darle un script a *HPBar* para que monitorice la variable `hp` del nodo que le digamos. En `HPBar.gd`:

```GDScript
extends ProgressBar


var to_monitor

func _process(delta):
    if is_instance_valid(to_monitor):
        value = to_monitor.hp
    else:
        value = 0
```

Por último, tenemos que darle valor a la variable `to_monitor`. Esto lo haremos desde el nodo *Main*, la raíz de la escena principal. Le damos script a este nodo (`Main.gd`) y añadimos lo siguiente:

```GDScript
extends Node

onready var _player = $World/Player
onready var _hp_bar = $UI/HPBar

func _ready() -> void:
    _hp_bar.to_monitor = _player
```

# Conclusión
¡Enhorabuena! Ahora ya deberías tener tu primer juego. No es un Triple A que puedas vender por 60€, pero nadie nace sabiendo. Poco a poco podrás ir aprendiendo cada vez más cosas y, con el tiempo, seguro que acabas desarrollando grandes éxitos.

Después de lo anterior, deberías saber:

- Los conceptos básicos del desarrollo y la programación de videojuegos.
- Crear escenas y nodos en *Godot*.
- Programar utilizando *GDScript*.
- La diferencia entre un objeto y una instancia.
- Pensar en la lógica necesaria para un videojuego e implementarla.
- Cómo identificar y solucionar *bugs*.

# Para continuar
Te reto a que sigas con el desarrollo de este juego. Aquí tienes una lista de ideas que implementar, aunque puedes añadir y cambiar todo lo que quieras. 

- **Fondo**: Buscar una imagen molona y ponerla de fondo. Es importante que no distraiga mucho y que aún así se puedan ver las balas y los personajes con claridad.
- **Salir del juego**: Programar una forma sencilla de cerrar el juego. Por ejemplo, manteniendo pulsada la tecla *Esc* durante un segundo.
- **Puntuación**: Dar puntos al jugador al matar a un enemigo. Mostrar los puntos en la interfaz del juego.
- **Sonidos al disparar**: ¡Que suenen los disparos! Echa un vistazo a [Audio streams](https://docs.godotengine.org/en/stable/tutorials/audio/audio_streams.html), en particular al nodo `AudioStreamPlayer2D`. Para hacer sonidos de forma rápida puedes utilizar [bfxr](https://www.bfxr.net/).
- **Fuego rápido**: Disparar un chorro de balas al mantener pulsado el botón de disparo, en lugar de disparar una bala por click. Limitar el número de balas por segundo que se disparan.
- **Pantalla de título y de *Game Over***: Puedes utilizar nodos `Control` para mostrar mensajes de manera sencilla.
- **Diferentes enemigos**: Crear varios tipos de enemigos. Por ejemplo, puedes hacer enemigos más grandes y lentos con varios puntos de vida o enemigos que se queden lejos y disparen a la nave.
- **Animación de morir**: Al morir una nave molaría que generara una explosión. Puedes probar con unas cuantas [partículas](https://docs.godotengine.org/en/stable/classes/class_particles2d.html#class-particles2d). Ah, también debería hacer algún ruido.
- **Aparición de enemigos**: Poner todos los enemigos de uno en uno no es efectivo. Hay que hacer que aparezcan más enemigos de forma automática al matar los que ya hay. Se puede hacer de forma parecida a como creamos las balas.

Están ordenados (más o menos) por orden de dificultad. No te preocupes si no puedes con alguno de ellos. Para cualquier cosa, al final de estas notas están mis redes y métodos de contacto. ¡Estaré encantado de ayudaros y ver vuestros resultados!

# Contacto
Si todavía no estás apuntado a ACM, ¿a qué esperas? Es gratis y hacemos cosas de este tipo a menudo. Te recomendamos echarle un vistazo a los siguientes enlaces:

- [Página Web](https://upm.acm.org/)
- [Telegram de GameDev](https://t.me/joinchat/GXu1OFCoE3drXGvjxQlfKg)

Si después del taller te quedas con alguna duda, me la puedes preguntar por:
- Twitter: [@_Gaspi](https://twitter.com/_gaspi)
- Telegram: [@PK_Gaspi](https://t.me/PK_Gaspi)
