extends CharacterBody3D

#jump
@export var jump_height : float = 2.25
@export var jump_time_to_peak : float = 0.4
@export var jump_time_to_descent : float = 0.3

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak ** 2)) * -1.0
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent ** 2)) * -1.0
# source: https://youtu.be/IOe1aGY6hXA?feature=shared

@export var base_speed := 4.0
@export var run_speed := 6.0

@onready var camera: Node3D = $CameraController/Camera3D

var movement_input := Vector2.ZERO

func _physics_process(delta: float) -> void:
	move_logic(delta)
	jump_logic(delta)
	move_and_slide()

func move_logic(delta: float) -> void:
	movement_input = Input.get_vector("left", "right", "forward", "backward").rotated(-camera.global_rotation.y)
	var vel_2d = Vector2(velocity.x, velocity.z)
	var is_running: bool = Input.is_action_pressed("run")

	if movement_input != Vector2.ZERO:
		var speed = run_speed if is_running else base_speed

		vel_2d += movement_input * speed * delta
		vel_2d = vel_2d.limit_length(speed)
	else:
		vel_2d = vel_2d.move_toward(Vector2.ZERO, base_speed * 4.0 * delta)

	velocity.x = vel_2d.x
	velocity.z = vel_2d.y


func jump_logic(delta: float) -> void:
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = -jump_velocity
	#if Input.is_action_just_released("jump"):
		#velocity.y = 0.0
	var gravity = jump_gravity if velocity.y > 0.0 else fall_gravity
	velocity.y -= gravity * delta
