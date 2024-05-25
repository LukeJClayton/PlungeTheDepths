class_name JumpComponent
extends Node3D

signal just_landed

@export_category("Configuration")
@export var entity: CharacterBody3D
@export var movement_component: MovementComponent
@export var jump_strength: float = 8

@export_category("Audio")
@export var jump_sfx: AudioStreamPlayer3D
@export var land_sfx: AudioStreamPlayer3D

var actually_jump: bool = false
var jumping: bool = false

var _can_emit_just_landed: bool = true

@onready var _jump_raycast: RayCast3D = $JumpRaycast

func _ready():
	pass;
	
func _process(_delta: float) -> void:
	
	if not jumping: 
		if not entity.is_on_floor():
			_can_emit_just_landed = true

	if entity.is_on_floor() and _can_emit_just_landed:
		_can_emit_just_landed = false
		jumping = false
		entity.rotation_component.can_rotate = true
		just_landed.emit()
		if land_sfx:
			land_sfx.play()

	if actually_jump:
		actually_jump = false
		movement_component.desired_velocity.y = jump_strength
		movement_component.vertical_movement = true
		
		# wait before setting flag because just_landed
		# gets emitted while it is still on the ground.
		var timer: SceneTreeTimer = get_tree().create_timer(0.05)
		timer.timeout.connect(
			func():
				_can_emit_just_landed = true
		)

func start_jump() -> void:
	jumping = true
	actually_jump = true
	entity.rotation_component.can_rotate = false
	if jump_sfx:
		jump_sfx.play()

func _receive_vertical_movement_ended() -> void:
	movement_component.can_disable_vertical_movement = true
	if movement_component.move_direction.length() > 0.2:
		movement_component.vertical_movement = false
