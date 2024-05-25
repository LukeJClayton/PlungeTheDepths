class_name Level
extends Node3D

@export var player: Player
@export var camera_controller: CameraController
@export var lock_on_system: LockOnSystem

func _enter_tree():
	Globals.camera_controller = camera_controller
	Globals.player = player
	Globals.lock_on_system = lock_on_system
