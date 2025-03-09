extends Control

var selected_refinery:Refinery:
	set(value):
		selected_refinery = value
		update_properties()
		
func _ready():
	$buy_truck.pressed.connect(add_truck)
	$buy_truck.disabled = false
	
func add_truck():
	selected_refinery.add_truck()
	
func update_properties():
	$refinery_name.text = selected_refinery.refinery_name
