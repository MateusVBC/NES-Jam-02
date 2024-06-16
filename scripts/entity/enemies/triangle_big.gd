extends AnimatableBody2D

@onready var ray_bottom_left: RayCast2D = $RayBottom1
@onready var ray_bottom_right: RayCast2D = $RayBottom2
@onready var ray_top: RayCast2D = $RayTop

@onready var enemyComponent = $EnemyComponent

func _physics_process(delta):
	enemyComponent.move(delta);

func _process(_delta):
	if ray_bottom_left.is_colliding() || ray_bottom_right.is_colliding():
		enemyComponent.DIRECTION = 1;
	elif ray_top.is_colliding():
		enemyComponent.DIRECTION = -1;

func take_damage(damage):
	enemyComponent.take_damage(damage);

func die():
	queue_free();
