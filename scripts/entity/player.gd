extends CharacterBody2D
class_name Player

enum SIDES {UP, DOWN, LEFT, RIGHT};
enum DIRECTIONS {TOP, BOTTOM, BACk, FRONT};

const SPEED = 300.0;
const JUMP_VELOCITY = -400.0;
const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;

@onready var powerUpManager = $"PowerUp Manager"
@export var power_ups := {SIDES.UP: false, SIDES.DOWN: false, SIDES.RIGHT: false, SIDES.LEFT: false};
var current_directions := {DIRECTIONS.TOP: SIDES.UP, DIRECTIONS.BOTTOM: SIDES.DOWN, DIRECTIONS.FRONT: SIDES.RIGHT, DIRECTIONS.BACk: SIDES.LEFT};

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var leaf_gravity = gravity / 4;

var target_rotation: float = 0.0
var rotation_elapsed: float = 2.0
var rotation_direction := 1
var initial_rotation: float = 0


func _physics_process(delta):
	#if not is_on_floor():
		#if(rotation == 0):
			#velocity.y += leaf_gravity * delta
		#else:
			#velocity.y += gravity * delta

	if Input.is_action_just_pressed("spin_left") || Input.is_action_just_pressed("spin_right"):
		rotation_elapsed = 0;
		initial_rotation = rotation;
		#if Input.is_action_just_pressed("spin_left"):
		target_rotation += Input.get_axis("spin_left", "spin_right") * deg_to_rad(90);
		#else: 
			#target_rotation += deg_to_rad(90);
		var x = 1;
		
	if rotation_elapsed <= 1:
		rotate_player_90_degrees(delta);

	# Handle jump.
	if Input.is_action_just_pressed("ui_up"):
		velocity.y = JUMP_VELOCITY
		
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		var touching_sides = powerUpManager.get_touching_sides();
		for side in touching_sides:
			if typeof(touching_sides[side]) == TYPE_INT:
				power_ups[side] = touching_sides[side];
			if typeof(power_ups[side]) == TYPE_INT:
				powerUpManager.set_sprite_from_power_up(side, power_ups[side])

func rotate_player_90_degrees(delta):
	target_rotation = fmod(target_rotation, (2 * PI))
	rotation = lerp_angle(initial_rotation, target_rotation, rotation_elapsed);
	rotation_elapsed += delta * 5;
	rotation_elapsed = min(1, rotation_elapsed);

func refresh_sides(new_rotation):
	var degrees_rotation = rad_to_deg(new_rotation);
	for direction in current_directions:
		pass
	

#func is_element_on_current_side(power_up, side):
	#var elements_position = [];
	#for element in power_ups:
		#if power_ups[element] == power_up:
			#elements_position.append(element);
	#if !elements_position.is_empty():
		
