extends Node
class_name PowerUpManager

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;
const SIDES = preload("res://scripts/entity/player.gd").SIDES;
const SPRITES := {
	POWER_UPS.LEAF: preload("res://assets/player/leaf_upgrade.png"),
	POWER_UPS.CLOUD: preload("res://assets/player/cloud_upgrade.png"),
	POWER_UPS.METAL: preload("res://assets/player/metal_up.png"),
	POWER_UPS.SPIKES: preload("res://assets/player/spike_upgrade.png"),
	POWER_UPS.SLIME: preload("res://assets/player/slime_upgrade.png"),
	POWER_UPS.ICE: preload("res://assets/player/ice_upgrade.png"),
	POWER_UPS.FIRE: preload("res://assets/player/fire_upgrade.png")
}
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
	
func set_sprite_from_power_up(side, power_up: int, health):
	match power_up:
				POWER_UPS.LEAF:
					set_sprite_from_side(side, SPRITES[POWER_UPS.LEAF]);
				POWER_UPS.ICE:
					set_sprite_from_side(side, SPRITES[POWER_UPS.ICE]);
				POWER_UPS.METAL:
					health[side] = METAL_HEALTH;
					set_sprite_from_side(side, SPRITES[POWER_UPS.METAL]);
				POWER_UPS.SPIKES:
					health[side] = SPIKE_HEALTH;

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
