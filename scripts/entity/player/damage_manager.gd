extends Node2D

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS

@onready var player = $".."
@export var spike_damage = 1;

@onready var spike_collision_0: CollisionShape2D = $TopDamageArea/SpikeCollision
@onready var spike_collision_1: CollisionShape2D = $RightDamageArea/SpikeCollision
@onready var spike_collision_2: CollisionShape2D = $BottomDamageArea/SpikeCollision
@onready var spike_collision_3: CollisionShape2D = $LeftDamageArea/SpikeCollision

func _process_damage(side, area):
	if player.power_ups[side] is PowerUp:
		match player.power_ups[side].type:
			POWER_UPS.SPIKES:
				if area.get_parent().is_in_group("enemy"):
					area.get_parent().take_damage(spike_damage);
			POWER_UPS.METAL:
				if player.is_side_on_current_direction(side, player.SIDES.DOWN):
					return;
			POWER_UPS.FIRE:
				if area.get_parent().is_in_group("enemy"):
					area.get_parent().die();
				return;
	player.take_damage(side);

func refresh_hitbox(power_ups):
	for side in power_ups:
		if power_ups[side] is PowerUp:
			get("spike_collision_"+str(side)).disabled = power_ups[side].type != POWER_UPS.SPIKES;
		else:
			get("spike_collision_"+str(side)).disabled = true;
	pass

#region Collision Connection
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
#endregion
