extends Node2D


onready var _player = $Player
onready var _enemy = $Enemy


func _ready():
	_enemy.to_follow = _player
