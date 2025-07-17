extends Node3D # Map1

# map data
@export var enemy_packedscenes: Array[PackedScene]
@export var wave_data: Array[Wave_Data]
@export var enemy_spawn_interval: Array[float]
var enemies: Array[PathFollow3D] = []
var current_wave: Wave_Data

# Node
@export var path: Path3D
@export var enemy_group_node: Node3D
@export var wave_interval: Timer
@export var enemy_interval: Timer

var spawn_on_next_frame: bool = false
var is_wave_on_cooldown: bool = false
var is_enemy_spawn_on_cooldown: bool = false
var has_enemy_type_changed: bool = false
var request_to_update_wave: bool = false
var is_wave_spawning_done: bool = false
var end_game_wave_loop: bool = false

var current_wave_index: int = 0
var current_enemy_index: int = 0
var current_enemy_number_index: int = 0

var current_spawn_interval: float = 0.1

func _ready() -> void:
	print(enemies)

func _process(delta: float) -> void:
	print(enemies.size())
	if request_to_update_wave and enemies.size() == 0:
		change_wave()
	
	if current_wave_index < wave_data.size():
		current_wave = wave_data[current_wave_index]
		if can_spawn_enemy():
			game_loop()
		
		
	enemy_movement(delta)

func game_loop() -> void:
	if !current_wave: return

	var enemy_scene: PackedScene = enemy_packedscenes[current_wave.enemies_type[current_enemy_index]]
	print(is_wave_spawning_done)
	if current_enemy_number_index < current_wave.enemies_number[current_enemy_index]:
		spawn_enemy(enemy_scene)
		current_spawn_interval = enemy_spawn_interval[current_enemy_index]
		if enemies.size() >= current_wave.total_enemies:
			request_to_update_wave = true
			is_wave_spawning_done = true
			
		#print(" spawning : ", current_enemy_index, " : ", current_enemy_number_index)
	else:
		current_enemy_index += 1
		current_spawn_interval = 2
		current_enemy_number_index = 0
	
	# Reached end
	if current_enemy_index > current_wave.enemies_type.size() - 1:
		current_enemy_index = 0
		request_to_update_wave = true
		print(enemies.size())
	
	start_enemy_interval(current_spawn_interval)
		
func enemy_movement(deltatime: float)-> void:
	for i in range(enemies.size()):
		var enemy: PathFollow3D = enemies[i]
		var enemy_area: Area3D = enemy.get_node("Enemy")
		var enemy_data: Enemy_Data = enemy_area.data as Enemy_Data
		
		enemy.progress += enemy_data.speed * deltatime
		
func spawn_enemy(scene: PackedScene) -> void:
	if !scene.can_instantiate(): return
	

	current_enemy_number_index += 1
 	
	var new_path_follow: PathFollow3D = PathFollow3D.new()
	new_path_follow.progress = 0
	new_path_follow.visible = true
	new_path_follow.position = Vector3.ZERO
	path.add_child(new_path_follow)
	
	var new_enemy: Area3D = scene.instantiate()
	new_enemy.visible = true
	new_enemy.position = Vector3.ZERO
	new_path_follow.add_child(new_enemy)
	
	spawn_on_next_frame = false
	enemies.append(new_path_follow)

func change_wave()-> void:
	if current_wave_index + 1 >= wave_data.size():
		end_game_wave_loop = true
		return
	
	request_to_update_wave = false
	current_wave_index += 1
	is_wave_on_cooldown = true
	wave_interval.start(current_wave.wave_interval)
	is_wave_spawning_done = false

## <-------- LOGIC FUNCTIONS -------->
func can_spawn_enemy()-> bool:
	return !(is_wave_on_cooldown or is_enemy_spawn_on_cooldown or end_game_wave_loop or is_wave_spawning_done)

## <-------- SIGNALS --------> ##
func start_enemy_interval(time: float)-> void:
	is_enemy_spawn_on_cooldown = true
	enemy_interval.start(time)

func _on_enemy_interval_timeout() -> void:
	is_enemy_spawn_on_cooldown = false


func _on_wave_interval_timeout() -> void:
	is_wave_on_cooldown = false

## <-------- HOME COLLISION LOGIC --------> ##
func _on_home_area_entered(area: Area3D) -> void:
	if area.name == "Enemy":
		var path_follow = area.get_parent()
		var enemy_index: int = enemies.find(path_follow)
		
		if enemy_index > 0 and enemies.size() > enemy_index:
			enemies.remove_at(enemy_index)
			path_follow.queue_free()
			print("quee freed")
