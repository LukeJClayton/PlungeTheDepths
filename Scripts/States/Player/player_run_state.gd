class_name PlayerRunState
extends StateMachine

@export_category('States')
@export var idle_state: PlayerIdleState
@export var walk_state: PlayerWalkState
@export var dodge_state: PlayerDodgeState
@export var jump_state: PlayerJumpState

@export_category('Variables')
@export var run_speed: float = 5

func enter() -> void:
	entity.movement_component.speed = run_speed
	
func process_entity() -> void:
	if entity.input_direction.length() < 0.2:
		parent_state.change_state(idle_state)
		return
	
	if not entity.holding_down_run:
		parent_state.change_state(walk_state)
		return
	
	if Input.is_action_just_pressed("dodge"):
		parent_state.change_state(dodge_state)
		return
		
	if Input.is_action_just_pressed("jump"):
		parent_state.change_state(jump_state)
		return
		
	entity.set_rotation_target_to_lock_on_target()
	
	if entity.lock_on_target and entity.input_direction.z < 0:
		entity.rotation_component.rotate_towards_target = true
	else:
		entity.rotation_component.rotate_towards_target = false
