extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	$MarginContainer/VBoxContainer/Retry.grab_focus();
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		audio_stream_player.play();

func _on_retry_pressed():
	$"..".get_tree().reload_current_scene()
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn");
