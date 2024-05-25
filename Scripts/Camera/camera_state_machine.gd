class_name CameraStateMachine
extends StateMachine

@export var camera_controller: CameraController
@export var camera: Camera3D

@onready var player: Player =  Globals.player
@onready var lock_on_system: LockOnSystem = Globals.lock_on_system

func process_unhandled_input_state_machine(event: InputEvent) -> void:
	process_unhandled_input(event)
	
	if not has_sub_states:
		return
	
	current_state.process_unhandled_input_state_machine(event)

func process_unhandled_input(_event: InputEvent) -> void:
	pass

func process_entity() -> void:
	#parent_state.parent_state.change_state(
		#normal_state
	#)
	
	camera_controller.global_position = camera_controller.global_position.lerp(
		player.global_position + Vector3(0, 0.5, 0), 
		0.05
	)
