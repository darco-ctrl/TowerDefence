extends Node3D

@export var camera: Camera3D
@export var placing_block: MeshInstance3D

var current_selected_grid: Vector3i = Vector3i.ZERO
var current_intersecting_pos: Vector3 = Vector3.ZERO


func _ready() -> void:
	pass

func _process(delta: float) -> void:
	update_mouse_3d_position()

func update_mouse_3d_position() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var to = from + camera.project_ray_normal(mouse_pos) * 100.0

	var space_state: PhysicsDirectSpaceState3D = get_world_3d().direct_space_state
	var ray_cast: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(from, to)
	ray_cast.collide_with_areas = true
	ray_cast.collision_mask = 1

	var shape_collided: Dictionary = space_state.intersect_ray(ray_cast)

	if shape_collided.has("position"):
		placing_block.visible = true
		current_intersecting_pos = shape_collided["position"]
		update_selection_box()
	else:
		placing_block.visible = false
	
	#print("block position: %s \nMouse position: %s" % [placing_block.position, current_intersecting_pos])


func update_selection_box() -> void:
	var snapped_pos: Vector3 = Vector3i(current_intersecting_pos)
	placing_block.global_position = snapped_pos + Vector3(0.5, 0.51, 0.5)

func grid_to_posiiton() -> void:
	pass
