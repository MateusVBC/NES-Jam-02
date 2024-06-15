extends Node2D

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS

@onready var player = $".."
@export var spike_damage = 1;

func _on_left_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.LEFT, area);

func _on_right_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.RIGHT, area);

func _on_top_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.UP, area);

func _on_bottom_damage_area_area_entered(area):
	if  area.is_in_group("damage_area"):
		_process_damage(player.SIDES.DOWN, area);

func _process_damage(side, area):
	match player.power_ups[side]:
		POWER_UPS.SPIKES:
			player.take_damage(side);
			area.get_parent().take_damage(spike_damage);
		POWER_UPS.METAL:
			if !player.is_side_on_current_direction(side, player.SIDES.DOWN):
				player.take_damage(side);
		POWER_UPS.FIRE:
			area.get_parent().die();
		_:
			player.take_damage(side);
