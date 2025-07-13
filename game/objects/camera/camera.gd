extends Node3D

# Nodes
@export var camera_pivot: Node3D
@export var camera: Camera3D

@export var camera_sensivity: float = 0.01

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("camera_motion"):
		camera_pivot.rotation.x = -event.relative.y * camera_sensivity
		rotation.y = -event.relative.x * camera_sensivity
