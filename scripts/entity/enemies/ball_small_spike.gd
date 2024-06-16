extends RigidBody2D

@onready var ray_right: RayCast2D = $RayRight
@onready var ray_left: RayCast2D = $RayLeft

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var enemyComponent = $EnemyComponent

func _physics_process(delta):
	enemyComponent.move(delta);
	

func _process(_delta):
	if ray_right.is_colliding():
		enemyComponent.DIRECTION = -1;
		animated_sprite.flip_h = true
	elif ray_left.is_colliding():
		animated_sprite.flip_h = false
		enemyComponent.DIRECTION = 1;

func take_damage(damage):
	enemyComponent.take_damage(damage);

func die():
	queue_free();
