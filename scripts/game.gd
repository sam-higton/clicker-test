class_name GameManager extends Node

# var interface_scene = load("//res://interface.tscn")

signal dollars_changed(dollars:int)

var game_seed:int = 10101010
var interface:GameInterface
var masters:MasterRepository
var price_list:Dictionary = {
	'truck': 1000,
	'miner': 50
}

var picking_boulder:bool = false:
	set(value):
		picking_boulder = value
		if value:
			Input.set_default_cursor_shape(Input.CURSOR_POINTING_HAND)
		else:
			Input.set_default_cursor_shape(Input.CURSOR_ARROW)

var truck_cost:int = 0

var dollars:int = 0:
	set(value):
		dollars = value
		if dollars < 0: dollars = 0
		dollars_changed.emit(dollars)

		
# Called when the node enters the scene tree for the first time.
func _enter_tree() -> void:
	# interface = interface_scene.instantiate()
	# add_child(interface)
	interface = $interfaceCanvas/interface
	masters = $masters
	seed(game_seed)
	
func _ready():
	if FileAccess.file_exists('save.json'):
		load_game()
	else:
		build_level()
		save_game()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_rocks(rocks:Array[Rock.RockType]):
	for rock_type in rocks:
		dollars += 10

func build_level():
	for i in range(600, 4000, 400):
		var base_quantity = i / 150
		generate_boulder_ring(i, randi_range(base_quantity - (base_quantity / 5), base_quantity + (base_quantity / 5)))

func generate_boulder_ring(radius:float, quantity: int ):
	var segment_size = (2 * PI) / quantity
	var center_x = $refinery.global_position.x
	var center_y = $refinery.global_position.y
	var i = 0
	var angle_offset = randf_range(0, 2 * PI)
	while i < 2 * PI:
		var new_boulder = masters.master_boulder.duplicate()
		var angle = randf_range(i - 0.5, i + 0.5) + angle_offset
		var rand_radius = randf_range(radius - (radius / 10), radius + (radius / 10))
		new_boulder.global_position.x = center_x + radius * cos(angle)
		new_boulder.global_position.y = center_y + radius * sin(angle)
		new_boulder.boulder_name = "boulder %s %s" % [int(rand_radius), int(angle)]
		add_child(new_boulder)
		if new_boulder.get_overlapping_areas().size() > 0:
			new_boulder.queue_free()
		i += segment_size

func load_game():
	print('loading game!')

func save_game():
	print('saving the game')
	var save_state = {
		"saved_at" : Time.get_unix_time_from_system(),
		"game_seed" : game_seed,
		"dollars" : dollars,
		"game_objects" : []
	}
	
	for child in get_children():
		if child.has_method('save_data'): 
			var child_data = child.save_data()
			child_data['position'] = {
				'x' : child.global_position.x,
				'y' : child.global_position.y
			}
			save_state['game_objects'].append(child_data)
	var file = FileAccess.open('save.json', FileAccess.WRITE)
	file.store_string(JSON.stringify(save_state))
	
