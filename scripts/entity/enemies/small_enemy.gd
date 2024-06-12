extends RigidBody2D

@onready var rayLeft = $RayLeft
@onready var rayRight = $RayRight
@onready var rayBottom = $RayBottom

@onready var enemyComponent = $EnemyComponent

@onready var sprite = $Sprite2D
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") / 7

func _physics_process(delta):
	enemyComponent.move(delta);
	if !rayBottom.is_colliding():
		global_position.y += gravity * delta
	

func _process(delta):
	var x =1;
		
	if rayLeft.is_colliding():
		enemyComponent.DIRECTION = 1;
		sprite.flip_h = false;
	elif rayRight.is_colliding():
		enemyComponent.DIRECTION = -1;
		sprite.flip_h = true;

func take_damage(damage):
	enemyComponent.take_damage(damage);

func die():
	queue_free();
