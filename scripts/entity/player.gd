extends CharacterBody2D
class_name Player

signal player_death;

enum SIDES {UP, RIGHT, DOWN, LEFT};
enum DIRECTIONS {TOP, FRONT, BOTTOM, BACk};

const SPEED = 135.0;
const JUMP_VELOCITY = -300.0;
const POWER_UPS = preload("res://scripts/resources/power_up_list.gd").POWER_UPS;

const HURT_1 = preload("res://assets/SFX/player/hurt_1.ogg")
const HURT_2 = preload("res://assets/SFX/player/hurt_2.ogg")
const HURT_3 = preload("res://assets/SFX/player/hurt_3.ogg")
const HURT_4 = preload("res://assets/SFX/player/hurt_4.ogg")
const HURT_5 = preload("res://assets/SFX/player/hurt_5.ogg")

#region Variables

#region Childs
@onready var coyote_timer: Timer = $CoyoteTimer
@onready var fire_timer: Timer = $FireTimer

@onready var power_up_manager = $"PowerUp Manager"
@onready var damage_manager: Node2D = $"Damage Manager"
@onready var hurt_sfx: AudioStreamPlayer = $HurtSFX

#endregion

#region Sides Stats
@export var power_ups := {SIDES.UP: false, SIDES.DOWN: false, SIDES.RIGHT: false, SIDES.LEFT: false};
var health_sides := {SIDES.UP: 0, SIDES.DOWN: 0, SIDES.RIGHT: 0, SIDES.LEFT: 0};
var is_dead = false;
#endregion

#region Speed Stats
var speed_moment = SPEED;
var speed_debuff = 0.0;
var speed_buff = 0.0;
var fire_time = 999;
#endregion

#region Gravity
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var leaf_gravity = gravity / 6; #gravity / 4.5;
#endregion

#region Jumps
@export var coyote_time := 0.1;
var avaliable_jumps := 1;
var did_jump := false;
var jump_buff := 0;
#endregion

#region Spin Stats
var target_rotation: float = 0.0
var rotation_elapsed: float = 2.0
var rotation_direction := 1
var initial_rotation: float = 0
var tracking_rotation = 0;
#endregion

#endregion

func _physics_process(delta):

	if !is_on_floor():
		#Coyote Time
		if !did_jump && coyote_timer.is_stopped():
			coyote_timer.start(coyote_time);
			
		#Rotation
		if Input.is_action_just_pressed("spin_left") || Input.is_action_just_pressed("spin_right"):
			do_rotate_player();
			_validate_speed();
		
		#Gravity
		if(is_element_on_current_side(power_up_manager.POWER_UPS.LEAF, DIRECTIONS.TOP)
		&& velocity.y > 0 && Input.is_action_pressed("ui_up")):
			velocity.y += leaf_gravity * delta
		else:
			velocity.y += gravity * delta
	else:
		if is_element_on_current_side(POWER_UPS.CLOUD, DIRECTIONS.BOTTOM):
			avaliable_jumps = 2;
		elif is_element_on_current_side(POWER_UPS.FIRE, DIRECTIONS.BOTTOM):
			avaliable_jumps = 3;
		else:
			avaliable_jumps = 1;
		coyote_timer.stop();

	#Jump
	if Input.is_action_just_pressed("ui_up"):
		if avaliable_jumps > 0:
			did_jump = true;
			avaliable_jumps -= 1;
			velocity.y = JUMP_VELOCITY + jump_buff;
	
	#Do rotate
	if rotation_elapsed <= 1:
		_rotate_player_90_degrees(delta);
	
	#Movement
	var direction = Input.get_axis("ui_left", "ui_right");
	if direction:
		velocity.x = direction * max(SPEED - speed_debuff + speed_buff, 10)
	else:
		velocity.x = move_toward(velocity.x, 0, speed_moment)
	
	move_and_slide()

func _process(delta):
	#Get upgrades
	if Input.is_action_just_pressed("ui_down"):
		var touching_sides = power_up_manager.get_touching_sides();
		for side in touching_sides:
			if touching_sides[side] is PowerUp:
				if touching_sides[side].type == POWER_UPS.FIRE:
					power_ups[SIDES.UP] = touching_sides[side];
					power_ups[SIDES.DOWN] = touching_sides[side];
					power_ups[SIDES.LEFT] = touching_sides[side];
					power_ups[SIDES.RIGHT] = touching_sides[side];
					fire_timer.start(fire_time);
					break;
				power_ups[side] = touching_sides[side];
		power_up_manager.refresh_sprites(self, power_ups);
		_validate_speed();
		if damage_manager != null:
			damage_manager.refresh_hitbox(power_ups);
	
	if is_dead:
		create_tween().tween_property(Engine, "time_scale", 0.1, delta * 100);

#region Damage
func take_damage(side):
	if !$AnimationPlayer.is_playing():
		health_sides[side] -= 1;
		$AnimationPlayer.play("take_damage");
		if health_sides[side] == 0:
			hurt_sfx.stream = get("HURT_"+str(randi_range(1, 5)));
			hurt_sfx.play()
			power_ups[side] = false;
			_validate_speed();
			power_up_manager.refresh_sprites(self, power_ups);
			damage_manager.refresh_hitbox(power_ups);
		elif health_sides[side] < 0:
			die();

func die():
	speed_debuff = SPEED;
	is_dead = true
	velocity.y = JUMP_VELOCITY;
	$CornerCollision1.queue_free()
	$CornerCollision2.queue_free()
	$CornerCollision3.queue_free()
	$CornerCollision4.queue_free()
	$SideCollision1.queue_free()
	$SideCollision2.queue_free()
	$SideCollision3.queue_free()
	$SideCollision4.queue_free()
	damage_manager.queue_free()
	get_tree().create_tween().tween_property(self, "rotation", 360, 10);
	await get_tree().create_timer(0.5).timeout
	emit_signal("player_death");
#endregion

#region Speed
func _validate_speed():
	if is_element_on_current_side(POWER_UPS.ICE, DIRECTIONS.BOTTOM):
		speed_moment = SPEED / 100;
		speed_buff = 50;
	elif is_element_on_current_side(POWER_UPS.FIRE, DIRECTIONS.BOTTOM):
		speed_moment = SPEED;
		speed_buff = 100;
		jump_buff = -150
	else:
		speed_moment = SPEED;
		speed_buff = 0;
	
	speed_debuff = count_elements(POWER_UPS.METAL) * 25;

	if is_element_on_current_side(POWER_UPS.SPIKES, DIRECTIONS.BOTTOM):
		speed_debuff += 40;
#endregion

#region Rotation
func do_rotate_player():
	var axis = Input.get_axis("spin_left", "spin_right");
	tracking_rotation += axis
	if(tracking_rotation > 3 || tracking_rotation < -3):
		tracking_rotation = 0;
	rotation_elapsed = 0;
	initial_rotation = rotation;
	target_rotation += axis * deg_to_rad(90);

func _rotate_player_90_degrees(delta):
	target_rotation = fmod(target_rotation, (2 * PI))
	rotation = lerp_angle(initial_rotation, target_rotation, rotation_elapsed);
	rotation_elapsed += delta * 5;
	rotation_elapsed = min(1, rotation_elapsed);
#endregion

#region Side validations
func is_element_on_current_side(power_up: int, side: int):
	var side_tracking = tracking_rotation;
	#não lida com negativos
	if tracking_rotation < 0:
		side_tracking += 4;
	for element in power_ups:
		if power_ups[element] is PowerUp:
			if power_ups[element].type == power_up:
				#digo qual a "real" posicao do elemento
				element += side_tracking;
				#faço ficar dentro do array de lados
				if element > 3:
					element -= 4;
				if element == side:
					return true;
	return false;
	
func is_side_on_current_direction(side, direction):
	var side_tracking = tracking_rotation;
	#não lida com negativos
	if tracking_rotation < 0:
		side_tracking += 4;
	side += side_tracking;
	if side > 3:
		side -= 4;
	return direction == side;
	
func get_direction_side(side):
	var side_tracking = tracking_rotation;
	#não lida com negativos
	if tracking_rotation < 0:
		side_tracking += 4;
	side += side_tracking;
	if side > 3:
		side -= 4;
	return side;
	
func count_elements(power_up: int):
	var qtt_element = 0;
	for side in power_ups:
		if power_ups[side] is PowerUp && power_ups[side].type == power_up:
			qtt_element += 1;
	return qtt_element;
#endregion

func _coyote_timeout():
	if !did_jump:
		avaliable_jumps -= 1;

func _on_fire_timer_timeout() -> void:
	power_ups[SIDES.UP] = false;
	power_ups[SIDES.DOWN] = false;
	power_ups[SIDES.LEFT] = false;
	power_ups[SIDES.RIGHT] = false;
	power_up_manager.refresh_sprites(self, power_ups);
	_validate_speed();
	if damage_manager != null:
		damage_manager.refresh_hitbox(power_ups);
