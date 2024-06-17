extends Node2D

const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS

const LANDING_ENEMY_HEAVY = preload("res://assets/SFX/player/landingEnemyHeavy.ogg")
const LANDING_ENEMY_LIGHT = preload("res://assets/SFX/player/landingEnemyLight.ogg")

@onready var player = $".."
@export var spike_damage = 1;

@onready var hurt_area_0: Area2D = $TopHurtArea
@onready var hurt_area_1: Area2D = $RightHurtArea
@onready var hurt_area_2: Area2D = $BottomHurtArea
@onready var hurt_area_3: Area2D = $LeftHurtArea

@onready var landing_sfx: AudioStreamPlayer = $LandingSFX

func _process_damage(side, area):
	if player.power_ups[side] is PowerUp:
		match player.power_ups[side].type:
			POWER_UPS.SPIKES:
				if area.get_parent().is_in_group("enemy"):
					area.get_parent().take_damage(spike_damage);
				else:
					return;
			POWER_UPS.METAL:
				if player.is_side_on_current_direction(side, player.SIDES.DOWN):
					if player.count_elements(POWER_UPS.METAL) < 2:
						landing_sfx.stream = LANDING_ENEMY_LIGHT;
						landing_sfx.play();
					else:
						landing_sfx.stream = LANDING_ENEMY_HEAVY;
						landing_sfx.play();
					if !area.get_parent().is_in_group("enemy"):
						player.take_damage(side);
					return;
			POWER_UPS.FIRE:
				if area.get_parent().is_in_group("enemy"):
					area.get_parent().die();
				return;
	player.take_damage(side);

func refresh_hitbox(power_ups):
	for side in power_ups:
		if power_ups[side] is PowerUp:
			var a = get("hurt_area_"+str(side));
			get("hurt_area_"+str(side)).monitoring = power_ups[side].type == POWER_UPS.SPIKES || power_ups[side].type == POWER_UPS.FIRE;
		else:
			get("hurt_area_"+str(side)).monitoring = false;

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


func _on_right_hurt_area_area_entered(area: Area2D) -> void:
	if player.is_element_on_current_side(POWER_UPS.SPIKES, player.get_direction_side(player.SIDES.RIGHT)) || player.is_element_on_current_side(POWER_UPS.FIRE, player.get_direction_side(player.SIDES.RIGHT)):
		if  area.is_in_group("damage_area"):
			_process_damage(player.SIDES.RIGHT, area);


func _on_left_hurt_area_area_entered(area: Area2D) -> void:
	if player.is_element_on_current_side(POWER_UPS.SPIKES, player.get_direction_side(player.SIDES.LEFT)) || player.is_element_on_current_side(POWER_UPS.FIRE, player.get_direction_side(player.SIDES.LEFT)):
		if  area.is_in_group("damage_area"):
			_process_damage(player.SIDES.LEFT, area);


func _on_top_hurt_area_area_entered(area: Area2D) -> void:
	if player.is_element_on_current_side(POWER_UPS.SPIKES, player.get_direction_side(player.SIDES.UP)) || player.is_element_on_current_side(POWER_UPS.FIRE, player.get_direction_side(player.SIDES.UP)):
		if  area.is_in_group("damage_area"):
			_process_damage(player.SIDES.UP, area);


func _on_bottom_hurt_area_area_entered(area: Area2D) -> void:
	if player.is_element_on_current_side(POWER_UPS.SPIKES, player.get_direction_side(player.SIDES.DOWN)) || player.is_element_on_current_side(POWER_UPS.FIRE, player.get_direction_side(player.SIDES.DOWN)):
		if  area.is_in_group("damage_area"):
			_process_damage(player.SIDES.DOWN, area);
