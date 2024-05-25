class_name PlayerDodgeState
extends StateMachine

@export var run_state: PlayerRunState
@export var i_frame_timer: float

func _ready():
	super._ready()
	
func enter():
	#player.attack_component.interrupt_attack()
	entity.dodge_component.intent_to_dodge = true
	
	entity.hitbox_component.enabled = false
	
	var timer:SceneTreeTimer = get_tree().create_timer(i_frame_timer)  
	timer.timeout.connect(enable_hitbox) 

func enable_hitbox():
	entity.hitbox_component.enabled = true
	
func process_entity():
	if entity.holding_down_run:
		parent_state.change_state(run_state)
		return
	elif not entity.dodge_component.dodging:
		parent_state.transition_to_default_state()
		return
		
	entity.set_rotation_target_to_lock_on_target()
