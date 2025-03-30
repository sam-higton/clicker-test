extends Control

var game_manager:GameManager
var selected_truck:Truck:
	set(value):
		selected_truck = value
		selected_truck.property_changed.connect(update_properties)
		selected_truck.state_changed.connect(update_state)
		update_properties()

func _ready():
	$select_boulder.pressed.connect(select_boulder_clicked)
	game_manager = get_tree().current_scene
		
func update_properties():
	$truck_name.text = selected_truck.truck_name
	$truck_state.text = selected_truck.state_text()
	$capacity.text = "%s of %s" % [selected_truck.rock_count, selected_truck.rock_capacity]

func select_boulder_clicked():
	game_manager.picking_boulder = true

func update_state(old_state, new_state):
	update_properties()
	
