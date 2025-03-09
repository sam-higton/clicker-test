extends Control

var game_manager:GameManager
var selected_truck:Truck:
	set(value):
		selected_truck = value
		update_properties()

func _ready():
	$select_boulder.pressed.connect(select_boulder_clicked)
	game_manager = get_tree().current_scene
		
func update_properties():
	$truck_name.text = selected_truck.truck_name

func select_boulder_clicked():
	game_manager.picking_boulder = true
	
