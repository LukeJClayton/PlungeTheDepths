class_name PlayerWalkState
extends StateMachine

@export var idle_state: PlayerIdleState
@export var run_state: PlayerRunState
@export var dodge_state: PlayerDodgeState

func enter() -> void:
	entity.movement_component.can_move = true
	entity.movement_component.speed = 3

func process_entity() -> void:
	if entity.input_direction.length() < 0.2:
		parent_state.change_state(idle_state)
		return
	
	if Input.is_action_just_pressed("dodge"):
		parent_state.change_state(dodge_state)
		return
	
	if entity.holding_down_run:
		parent_state.change_state(run_state)
		return
		
	entity.set_rotation_target_to_lock_on_target()
	
	if entity.lock_on_target:
		entity.rotation_component.rotate_towards_target = true
	else:
		entity.rotation_component.rotate_towards_target = false
