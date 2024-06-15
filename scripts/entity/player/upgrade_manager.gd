extends Node
class_name PowerUpManager

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;
const SIDES = preload("res://scripts/entity/player.gd").SIDES;
const SPIKE_HEALTH = 1;
const METAL_HEALTH = 2;
@export var collidingSides := {SIDES.UP: false, SIDES.DOWN: false, SIDES.RIGHT: false, SIDES.LEFT: false};;

@onready var spUp = $SpriteUp
@onready var spDown = $SpriteDown
@onready var spRight = $SpriteRight
@onready var spLeft = $SpriteLeft

@onready var up = $Up
@onready var down = $Down
@onready var right = $Right
@onready var left = $Left

func get_touching_sides():
	return collidingSides;
	
func set_power_up(side, power_up: PowerUp, player: Player):
	set_sprite_from_side(side, power_up.sprite);
	match power_up.type:
				POWER_UPS.METAL:
					player.health_sides[side] = METAL_HEALTH;
				POWER_UPS.SPIKES:
					player.health_sides[side] = SPIKE_HEALTH;

func set_sprite_from_side(side, sprite):
	match side:
		SIDES.UP:
			spUp.texture = sprite;
		SIDES.DOWN:
			spDown.texture = sprite;
		SIDES.LEFT:
			spLeft.texture = sprite;
		SIDES.RIGHT:
			spRight.texture = sprite;

#UP
func _on_up_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.UP] = area.type;

func _on_up_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.UP] = false;

#DOWN
func _on_down_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.DOWN] = area;

func _on_down_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.DOWN] = false;

#LEFT
func _on_right_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.RIGHT] = area.type;

func _on_right_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.RIGHT] = false;

#RIGHT
func _on_left_area_entered(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.LEFT] = area.type;

func _on_left_area_exited(area):
	if area.is_in_group("power_up"):
		collidingSides[SIDES.LEFT] = false;
