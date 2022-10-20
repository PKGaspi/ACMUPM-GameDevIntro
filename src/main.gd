extends Node

@onready var _player = $World/Player
@onready var _hp_bar = $GUILayer/GUI/HPBar

func _ready():
    _hp_bar.to_monitor = _player
