extends Node2D

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS

@onready var player = $".."
@export var spike_damage = 1;

func _on_left_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.LEFT, area);
	elif area.is_in_group("kill_area"):
		player.die();

func _on_right_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.RIGHT, area);
	elif area.is_in_group("kill_area"):
		player.die();

func _on_top_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.UP, area);
	elif area.is_in_group("kill_area"):
		player.die();

func _on_bottom_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.DOWN, area);
	elif area.is_in_group("kill_area"):
		player.die();

func _process_damage(side, area):
	if player.power_ups[side] is PowerUp:
		match player.power_ups[side].type:
			POWER_UPS.SPIKES:
				area.get_parent().take_damage(spike_damage);
			POWER_UPS.METAL:
				if player.is_side_on_current_direction(side, player.SIDES.DOWN):
					return;
			POWER_UPS.FIRE:
				area.get_parent().die();
				return;
	player.take_damage(side);
