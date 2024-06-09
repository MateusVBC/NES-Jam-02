extends Node
class_name PowerUpManager

@export var collidingSides := {"up": false, "down": false, "right": false, "left": false};

@onready var up = $Up
@onready var down = $Down
@onready var right = $Right
@onready var left = $Left

func get_touching_sides():
	return collidingSides;

#UP
func _on_up_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides["up"] = area;

func _on_up_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides["up"] = false;

#DOWN
func _on_down_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides["down"] = area;


func _on_down_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides["down"] = false;

#LEFT
func _on_right_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides["right"] = area;


func _on_right_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides["right"] = false;

#RIGHT
func _on_left_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides["left"] = area;


func _on_left_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides["left"] = false;
