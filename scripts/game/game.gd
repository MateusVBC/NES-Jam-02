extends Node2D

const GAME_OVER = preload("res://scenes/menus/game_over.tscn");

const MUSIC = preload("res://assets/SFX/UI/music for loop.mp3");
const DAMAGE_1 = preload("res://assets/SFX/enemy/damage_1.ogg")
const DAMAGE_2 = preload("res://assets/SFX/enemy/damage_2.ogg")
const DAMAGE_3 = preload("res://assets/SFX/enemy/damage_3.ogg")
const DAMAGE_4 = preload("res://assets/SFX/enemy/damage_4.ogg")
const DAMAGE_5 = preload("res://assets/SFX/enemy/damage_5.ogg")

@onready var player = $Player
@onready var player_camera = player.get_node("Camera2D");
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_player: AudioStreamPlayer = $SfxPlayer


func _ready():
	music_player.play();
	player.connect("player_death", _game_over);
	Engine.time_scale = 1;
	get_tree().paused = false;

func _process(_data):
	if Input.is_action_just_pressed("pause"):
		get_tree().paused = true;
		create_gui(GAME_OVER.instantiate());
	if !music_player.playing:
		music_player.stream = MUSIC
		music_player.play()

func _game_over():	
	create_gui(GAME_OVER.instantiate());
	player_camera.enabled = false;

func _play_sfx_enemy_hut():
	sfx_player.stream = get("DAMAGE_"+str(randi_range(1, 5)));
	sfx_player.play()

func create_gui(gui):
	var actual_camera = Camera2D.new();
	actual_camera.global_position = player_camera.global_position;
	actual_camera.limit_top = player_camera.limit_top
	actual_camera.limit_bottom = player_camera.limit_bottom
	gui.global_position = actual_camera.global_position;
	gui.global_position.y = clampf(actual_camera.global_position.y,
	 actual_camera.limit_top + get_viewport_rect().size.y / 2,
	 actual_camera.limit_bottom - get_viewport_rect().size.y / 2
	);
	
	add_child(gui);
	add_child(actual_camera);
