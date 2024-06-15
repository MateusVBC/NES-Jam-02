extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://scenes/game/game.tscn");


func _on_options_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/control.tscn");


func _on_exit_pressed():
	get_tree().quit();
