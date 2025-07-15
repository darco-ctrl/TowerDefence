extends Node3D # Map1

# map data
@export var enemy_packedscenes: Array[PackedScene]
@export var wave_data: Array[Wave_Data]
var enemies: Array[Area3D]
var current_wave_index: int = 0

# Node
@export var path_follow: PathFollow3D
@export var enemy_group_node: Node3D


func _ready() -> void:
	enemies.resize(enemy_packedscenes.size())


func _process(delta: float) -> void:
	var current_wave: Wave_Data = wave_data[current_wave_index]
	
	
	
