extends Node2D

const GAME_OVER = preload("res://scenes/menus/game_over.tscn");
@onready var player = $Player

func _ready():
	player.connect("player_death", _game_over);
	Engine.time_scale = 1;

func _process(_data):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true;
		var player_camera = $Player/Camera2D;
		var game_over = GAME_OVER.instantiate();
		var death_camera = Camera2D.new();
		death_camera.global_position = player_camera.global_position;
		death_camera.limit_top = player_camera.limit_top
		death_camera.limit_bottom = player_camera.limit_bottom
		game_over.global_position = death_camera.global_position;
		game_over.global_position.y = clampf(death_camera.global_position.y, death_camera.limit_top - get_viewport_rect().size.y / 2, death_camera.limit_bottom - get_viewport_rect().size.y / 2);
		#player_camera.enabled = false;
		
		add_child(game_over);
		add_child(death_camera);
		

func _game_over():
	var player_camera = $Player/Camera2D;
	var game_over = GAME_OVER.instantiate();
	var death_camera = Camera2D.new();
	death_camera.global_position = player_camera.global_position;
	death_camera.limit_top = player_camera.limit_top
	death_camera.limit_bottom = player_camera.limit_bottom
	game_over.global_position = death_camera.global_position;
	game_over.global_position.y = clampf(death_camera.global_position.y, death_camera.limit_top - get_viewport_rect().size.y / 2, death_camera.limit_bottom - get_viewport_rect().size.y / 2);
	player_camera.enabled = false;
	
	add_child(game_over);
	add_child(death_camera);
