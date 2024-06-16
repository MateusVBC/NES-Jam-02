extends Area2D
class_name PowerUp

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;

@export var type: POWER_UPS;
@export var sprite := preload("res://assets/sprites/player/leaf_upgrade.png");

