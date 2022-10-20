extends Node2D


@onready var _player = $Player
@onready var _enemy1 = $Enemy
@onready var _enemy2 = $Enemy2


func _ready() -> void:
    _enemy1.target = _player
    _enemy2.target = _player
