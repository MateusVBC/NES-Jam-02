extends Node2D
class_name BaseEnemy

signal enemy_hurt;

@export var SPEED := Vector2(0.0, 0.0);
@export var LIFE := 1;
@export var DIRECTION := 1;

func _ready() -> void:
	connect("enemy_hurt", get_parent().get_parent().get_parent()._play_sfx_enemy_hut);

func move(delta):
	$"..".global_position += DIRECTION * SPEED * delta
	
func take_damage(damage):
	LIFE -= damage;
	emit_signal("enemy_hurt");
	if LIFE <= 0:
		$"..".die();
