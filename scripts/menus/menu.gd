extends Control
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer


func _ready():
	$MarginContainer/VBoxContainer/Play.grab_focus();

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		audio_stream_player.play();

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn");


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/control.tscn");


func _on_exit_pressed():
	get_tree().quit();
