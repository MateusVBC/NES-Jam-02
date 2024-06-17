extends Control

@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	$MarginContainer/VBoxContainer/Continue.grab_focus();
	
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_down") || Input.is_action_just_pressed("ui_up"):
		audio_stream_player.play();

func _on_retry_pressed():
	get_tree().paused = false;
	get_parent().on_menu = false;
	queue_free()
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn");
