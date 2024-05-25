class_name PlayerIdleState
extends StateMachine

@export var walk_state: PlayerWalkState
@export var dodge_state: PlayerDodgeState

var _locked_on_turning_in_place: bool = false

@onready var lock_on_system: LockOnSystem = Globals.lock_on_system

func _ready():
	super._ready()
	
	lock_on_system.lock_on.connect(_on_lock_on_system_lock_on)
	
func process_entity() -> void:
	if entity.input_direction.length() > 0:
		parent_state.change_state(walk_state)
		return

	entity.set_rotation_target_to_lock_on_target()
	
	if entity.lock_on_target:
		entity.rotation_component.rotate_towards_target = true
	else:
		entity.rotation_component.rotate_towards_target = false
		
func _on_lock_on_system_lock_on(target: LockOnComponent) -> void:
	if target and \
	entity.rotation_component.get_lock_on_rotation_difference() > 0.1:
		
		var diff: float = entity.rotation_component\
			.get_lock_on_rotation_difference()
		
		_locked_on_turning_in_place = true
		
		var duration: float = clamp(diff / PI * 0.18, 0.1, 0.18)
		var pressed_lock_on_timer: SceneTreeTimer = get_tree()\
			.create_timer(duration)
		
		pressed_lock_on_timer.timeout.connect(
			func():
				_locked_on_turning_in_place = false
		)

