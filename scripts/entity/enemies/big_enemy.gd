extends AnimatableBody2D

@onready var rayLeftTop = $RayLeft1
@onready var rayLeftBottom = $RayLeft2
@onready var rayRightTop = $RayRight1
@onready var rayRightBottom = $RayRight2
@onready var rayBottomLeft = $RayBottom1
@onready var rayBottomRight = $RayBottom2

@onready var enemyComponent = $EnemyComponent

@onready var sprite = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 7

func _physics_process(delta):
	enemyComponent.move(delta);
	if !rayBottomLeft.is_colliding() && !rayBottomRight.is_colliding():
		global_position.y += gravity * delta
	

func _process(delta):
	var x =1;
		
	if rayLeftTop.is_colliding() || rayLeftBottom.is_colliding():
		enemyComponent.DIRECTION = 1;
		sprite.flip_h = false;
	elif rayRightTop.is_colliding() || rayRightBottom.is_colliding():
		enemyComponent.DIRECTION = -1;
		sprite.flip_h = true;

func die():
	queue_free();
