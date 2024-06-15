extends Control


func _ready():
	$MarginContainer/VBoxContainer/Retry.grab_focus();
	
func _on_retry_pressed():
	$"..".get_tree().reload_current_scene()
	
func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn");
