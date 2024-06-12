extends CharacterBody2D
class_name Player

enum SIDES {UP, RIGHT, DOWN, LEFT};
enum DIRECTIONS {TOP, FRONT, BOTTOM, BACk};

const SPEED = 150.0;
const JUMP_VELOCITY = -300.0;
const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;

@onready var coyote_timer = $Timer
@onready var powerUpManager = $"PowerUp Manager"
@export var power_ups := {SIDES.UP: false, SIDES.DOWN: false, SIDES.RIGHT: false, SIDES.LEFT: false};
var current_directions := {DIRECTIONS.TOP: SIDES.UP, DIRECTIONS.BOTTOM: SIDES.DOWN, DIRECTIONS.FRONT: SIDES.RIGHT, DIRECTIONS.BACk: SIDES.LEFT};
var health_sides := {SIDES.UP: 0, SIDES.DOWN: 0, SIDES.RIGHT: 0, SIDES.LEFT: 0};
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var leaf_gravity = gravity / 6; #gravity / 4.5;

@export var coyote_time := 0.1;
var avaliable_jumps := 1;

var target_rotation: float = 0.0
var rotation_elapsed: float = 2.0
var rotation_direction := 1
var initial_rotation: float = 0
var tracking_rotation = 0;


func _physics_process(delta):
	if !is_on_floor():
		
		if avaliable_jumps > 0 && coyote_timer.is_stopped():
			coyote_timer.start(coyote_time);
			
		if Input.is_action_just_pressed("spin_left") || Input.is_action_just_pressed("spin_right"):
			var axis = Input.get_axis("spin_left", "spin_right");
			tracking_rotation += axis
			if(tracking_rotation > 3 || tracking_rotation < -3):
				tracking_rotation = 0;
			rotation_elapsed = 0;
			initial_rotation = rotation;
			target_rotation += axis * deg_to_rad(90);
		
		if(is_element_on_current_side(powerUpManager.POWER_UPS.LEAF, DIRECTIONS.TOP)
		&& velocity.y > 0 && Input.is_action_pressed("ui_up")):
			velocity.y += leaf_gravity * delta
		else:
			velocity.y += gravity * delta
	else:
		avaliable_jumps = 1;
		coyote_timer.stop();
		
	if Input.is_action_just_pressed("ui_up") && avaliable_jumps > 0:
		avaliable_jumps -= 1;
		velocity.y = JUMP_VELOCITY
	
	if rotation_elapsed <= 1:
		_rotate_player_90_degrees(delta);

	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) #velocity.x = move_toward(velocity.x, 0, SPEED/100)

	move_and_slide()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		var touching_sides = powerUpManager.get_touching_sides();
		for side in touching_sides:
			if typeof(touching_sides[side]) == TYPE_INT:
				power_ups[side] = touching_sides[side];
			if typeof(power_ups[side]) == TYPE_INT:
				powerUpManager.set_sprite_from_power_up(side, power_ups[side])

func is_element_on_current_side(power_up, side):
	var side_tracking = tracking_rotation;
	#não lida com negativos
	if tracking_rotation < 0:
		side_tracking += 4;
	for element in power_ups:
		if typeof(power_ups[element]) == TYPE_INT:
			if power_ups[element] == power_up:
				#digo qual a "real" posicao do elemento
				element += side_tracking;
				#faço ficar dentro do array de lados
				if element > 3:
					element -= 4;
				if element == side:
					return true;
	return false;

func take_damage(side):
	health_sides[side] -= 1;
	if health_sides[side] < 0:
		die();

func die():
	pass

func _rotate_player_90_degrees(delta):
	target_rotation = fmod(target_rotation, (2 * PI))
	rotation = lerp_angle(initial_rotation, target_rotation, rotation_elapsed);
	rotation_elapsed += delta * 5;
	rotation_elapsed = min(1, rotation_elapsed);
	
func _coyote_timeout():
	avaliable_jumps -= 1;
