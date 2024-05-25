class_name PlayerJumpState
extends StateMachine

@export var walk_state: PlayerWalkState

func _ready():
	super._ready()
	
	entity.jump_component.just_landed.connect(
		func():
			if parent_state.current_state == self:
				parent_state.transition_to_previous_state()
	)


func enter():
	entity.jump_component.start_jump()
	
	if parent_state.previous_state == walk_state:
		entity.movement_component.speed = 3.5
		
func process_entity():
	entity.set_rotation_target_to_lock_on_target()
	
	if parent_state.previous_state is PlayerRunState or \
	not entity.lock_on_target:
		entity.rotation_component.rotate_towards_target = false
	else:
		entity.rotation_component.rotate_towards_target = true
