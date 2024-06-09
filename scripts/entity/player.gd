extends CharacterBody2D
class_name Player

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var powerUpManager = $"PowerUp Manager"

@export var powerUps := {"up": false, "down": false, "right": false, "left": false};

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var leaf_gravity = gravity / 2;

var target_rotation: float = 0.0
var rotation_elapsed: float = 2.0
var rotation_direction := 1
var initial_rotation: float = 0



func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		print(rotation_degrees);
		rotation_elapsed = 0;
		initial_rotation = rotation;
		target_rotation += deg_to_rad(90)
		find_rotation_direction();
		
		velocity.y = JUMP_VELOCITY
		
	if rotation_elapsed <= 1:
		rotate_player_90_degrees(delta);
		
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _process(_delta):
	if Input.is_action_just_pressed("absorb"):
		powerUps = powerUpManager.get_touching_sides();
		print(powerUps);

func rotate_player_90_degrees(delta):
	target_rotation = fmod(target_rotation, (2 * PI))
	rotation = lerp_angle(initial_rotation, rotation_direction * target_rotation, rotation_elapsed);
	rotation_elapsed += delta * 5;
	rotation_elapsed = min(1, rotation_elapsed);
	
func find_rotation_direction():
	if Input.is_action_pressed("ui_left"):
		rotation_direction = -1;
	else:
		rotation_direction = 1;
