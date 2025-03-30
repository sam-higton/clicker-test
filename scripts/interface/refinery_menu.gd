extends Control

var game_manager:GameManager

var selected_refinery:Refinery:
	set(value):
		selected_refinery = value
		update_properties()
		
func _ready():
	game_manager = get_tree().current_scene
	$buy_truck.pressed.connect(add_truck)
	game_manager.dollars_changed.connect(can_afford_truck)
	$buy_truck.disabled = true

func can_afford_truck(dollars:int):
	if(selected_refinery == null):
		return
	$buy_truck.disabled = dollars < selected_refinery.truck_cost()
	$buy_truck.text = "buy truck ($%s)" % selected_refinery.truck_cost()

	
func add_truck():
	selected_refinery.add_truck()
	
func update_properties():
	$refinery_name.text = selected_refinery.refinery_name
	$buy_truck.text = "buy truck ($%s)" % selected_refinery.truck_cost()
