class_name Player
extends CharacterBody3D

@export_category("Mechanisms")
@export var state_machine: StateMachine
#@export var character: CharacterAnimations
@export var movement_component: MovementComponent
@export var rotation_component: PlayerRotationComponent
@export var dodge_component: DodgeComponent
@export var hitbox_component: HitboxComponent
@export var jump_component: JumpComponent

var active_motion_component: MotionComponent

var input_direction: Vector3 = Vector3.ZERO
var last_input_on_ground: Vector3 = Vector3.ZERO

var lock_on_target: LockOnComponent = null
var locked_on_turning_in_place: bool = false

var holding_down_run: bool = false
var _holding_down_run_timer: Timer

func _ready() -> void:
	active_motion_component = movement_component
	state_machine.enter_state_machine()
	
	_holding_down_run_timer = Timer.new()
	_holding_down_run_timer.timeout.connect(
		func():
			holding_down_run = true
	)
	add_child(_holding_down_run_timer)

func _physics_process(_delta: float) -> void:
	state_machine.process_state_machine()
	
	# player inputs
	input_direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	input_direction.z = Input.get_action_strength("backward") - Input.get_action_strength("forward")

	last_input_on_ground = input_direction if is_on_floor() else last_input_on_ground
	
	movement_component.move_direction = rotation_component.move_direction
	
	if Input.is_action_just_pressed("run"):
		_holding_down_run_timer.start(0.1)
	if Input.is_action_just_released("run"):
		_holding_down_run_timer.stop()
		holding_down_run = false
		
func _on_lock_on_system_lock_on(target: LockOnComponent) -> void:
	lock_on_target = target
	
func set_rotation_target_to_lock_on_target() -> void:
	rotation_component.target = lock_on_target
