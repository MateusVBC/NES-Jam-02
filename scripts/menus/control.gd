extends Control


func _ready():
	$MarginContainer/VBoxContainer/Back.grab_focus();

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn");
