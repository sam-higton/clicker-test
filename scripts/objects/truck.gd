class_name Truck extends CharacterBody2D
enum truck_state {
	STORAGE, 
	IDLE, 
	FINDING_ROCK, 
	RETRIEVING_ROCK, 
	LOADING_ROCK, 
	RETURNING_TO_REFINERY,
	UNLOADING_ROCKS
}

signal state_changed(old_state, new_state)

var current_state:truck_state:
	set(value):
		state_changed.emit(current_state, value)
		current_state = value

var truck_name:String = 'Truck 1'
var selected_boulder:Boulder
var rock_capacity:int = 1
var rock_count:int = 0:
	set(value):
		rock_count = value
		if rock_count == 0:
			$Sprite2D.texture = empty_sprite
		elif rock_count < rock_capacity / 2:
			$Sprite2D.texture = one_third_sprite
		elif rock_count < rock_capacity:
			$Sprite2D.texture = two_third_sprite
		else:
			$Sprite2D.texture = full_sprite

var rocks:Array[Rock.RockType] = []
var target_rock:Rock
var game_manager:GameManager
var refinery_spawn:Node2D
var speed:float = 50

var full_sprite = load('res://assets/images/truck/truck_full.png')
var one_third_sprite = load('res://assets/images/truck/truck_1_3.png')
var two_third_sprite = load('res://assets/images/truck/truck_2_3.png')
var empty_sprite = load('res://assets/images/truck/truck_empty.png')

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	refinery_spawn = get_tree().current_scene.get_node('refinery').get_node('truck_spawn')
	state_changed.connect(on_state_change)

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			game_manager.interface.set_selected_item(self)
			
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	# print(state_name(current_state))
	match current_state:
		truck_state.STORAGE:
			pass
		truck_state.RETRIEVING_ROCK:
			move_towards_rock(delta)
		truck_state.RETURNING_TO_REFINERY:
			move_towards_refinery(delta)
	pass
	
func init_truck():
	current_state = truck_state.IDLE
	# look_for_rock()
	
func on_state_change(old_state, new_state):
	print('state changed from %s to %s' % [state_name(old_state), state_name(new_state)])
	var method = null
	match new_state:
		truck_state.FINDING_ROCK:
			method = look_for_rock
		truck_state.LOADING_ROCK:
			method = load_rock
		truck_state.UNLOADING_ROCKS:
			method = unload_rocks
			
	if method == null: return
	
	get_tree().create_timer(0.1).timeout.connect(method)
	
			
func look_for_rock():
	print('looking for rock')
	var rocks:Array[Node] = get_tree().get_nodes_in_group(selected_boulder.rock_group()) 
	
	if rocks.size() < 1:
		get_tree().create_timer(1.0).timeout.connect(look_for_rock)
		return
		
	var nearest_rock = null
	var nearest_distance = INF
	for rock in rocks:
		var distance = global_position.distance_to(rock.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_rock = rock
	
	target_rock = nearest_rock
	target_rock.remove_from_group(selected_boulder.rock_group())
	current_state = truck_state.RETRIEVING_ROCK
	
func move_towards_rock(delta:float):
	if global_position.distance_to(target_rock.global_position) < 45.0:
		current_state = truck_state.LOADING_ROCK
		return
	
	move_towards(target_rock, delta)
	
func move_towards_refinery(delta:float):
	if global_position.distance_to(refinery_spawn.global_position) < 45.0:
		current_state = truck_state.UNLOADING_ROCKS
		return
		
	move_towards(refinery_spawn, delta)
	
func move_towards(target, delta):
	var direction = global_position.direction_to(target.global_position)
	velocity = direction * speed
	$Sprite2D.rotation = lerp_angle($Sprite2D.rotation, direction.angle() + PI/2, 5 * delta)
	position += velocity * delta
	
func load_rock():
	print('loading rock')
	rock_count += 1
	rocks.append(target_rock.rock_type)
	target_rock.queue_free()
	
	if rock_count >= rock_capacity:
		current_state = truck_state.RETURNING_TO_REFINERY
		
		
	elif  get_tree().get_nodes_in_group(selected_boulder.rock_group()).size() < 1:
		print('no rocks')
		current_state = truck_state.RETURNING_TO_REFINERY
		
	else:	
		print('find next rock')
		get_tree().create_timer(0.5).timeout.connect(func (): current_state = truck_state.FINDING_ROCK)
		

func unload_rocks():
	game_manager.add_rocks(rocks)
	rock_count = 0
	rocks = []
	current_state = truck_state.FINDING_ROCK
	
func set_boulder(boulder:Boulder):
	selected_boulder = boulder
	current_state = truck_state.FINDING_ROCK	
	
func state_name(val):
	for key in truck_state:
		if truck_state[key] == val:
			return key
	
