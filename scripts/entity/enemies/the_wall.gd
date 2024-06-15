extends Area2D

@export var SPEED := 0.2;
var velocity := 0.0;
var add_speed := 0.0;

func _process(delta):
	if(add_speed > SPEED): 
		velocity += SPEED * delta;
		add_speed = 0.0;
	else:
		add_speed += 0.01;
	global_position.x += velocity;
