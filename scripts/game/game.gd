extends Node2D

const GAME_OVER = preload("res://scenes/menus/game_over.tscn");
@onready var player = $Player

func _ready():
	player.connect("player_death", _game_over);

func _game_over():
	add_child(GAME_OVER.instantiate());
	pass
