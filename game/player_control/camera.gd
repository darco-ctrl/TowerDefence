extends Node3D

# Nodes
@export var camera_pivot: Node3D
@export var camera: Camera3D

@export var camera_sensivity: float = 0.01
@export var camera_zoom: float = 3

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion && Input.is_action_pressed("camera_motion"):
		rotate_y(-event.relative.x * camera_sensivity)
		camera_pivot.rotate_x(-event.relative.y * camera_sensivity)


func _process(delta: float) -> void:
	if Input.is_action_just_released("mouse_wheel_up"):
		camera.position.z -= 0.1
	elif Input.is_action_just_released("mouse_wheel_down"):
		camera.position.z += 0.1
