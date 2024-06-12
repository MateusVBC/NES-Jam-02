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
	if player.is_element_on_current_side(POWER_UPS.METAL, side):
		pass
	elif player.is_element_on_current_side(POWER_UPS.SPIKES, side):
		area.get_parent().take_damage(spike_damage);
		#quebra espinho
		player.power_ups[side] = false;
	elif player.is_element_on_current_side(POWER_UPS.FIRE, side):
		area.get_parent().die();
