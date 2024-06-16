extends RigidBody2D

@onready var ray_top: RayCast2D = $RayTop
@onready var ray_bottom: RayCast2D = $RayBottom

@onready var enemyComponent = $EnemyComponent

func _physics_process(delta):
	enemyComponent.move(delta);
	

func _process(_delta):
	if ray_top.is_colliding():
		enemyComponent.DIRECTION = -1;
	elif ray_bottom.is_colliding():
		enemyComponent.DIRECTION = 1;

func take_damage(damage):
	enemyComponent.take_damage(damage);

func die():
	queue_free();
