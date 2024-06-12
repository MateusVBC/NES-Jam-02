extends Node2D
class_name BaseEnemy

@export var SPEED := Vector2(0.0, 0.0);
@export var LIFE := 1;
@export var DIRECTION := 1;

func move(delta):
	$"..".global_position += DIRECTION * SPEED * delta
	
func take_damage(damage):
	LIFE -= damage;
	if LIFE <= 0:
		$"..".die();
