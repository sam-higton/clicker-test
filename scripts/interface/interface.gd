class_name GameInterface extends Control

var game_manager:GameManager
var selected_item:Node2D
var selected_truck:Truck

signal adding_truck
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	game_manager.dollars_changed.connect(update_dollars)
	update_dollars(game_manager.dollars)
	$selected_boulder.visible = false
	$selected_refinery.visible = false
	$selected_truck.visible = false
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_dollars(dollars:int):
	$dollar_count.text = "$%s" % dollars

func set_selected_item(item):
	selected_item = item
	
	$selected_boulder.visible = false
	$selected_refinery.visible = false
	$selected_truck.visible = false
	
	if selected_item is Boulder:
		$selected_boulder.visible = true
		$selected_boulder.selected_boulder = selected_item
		
	if selected_item is Refinery:
		$selected_refinery.visible = true
		$selected_refinery.selected_refinery = selected_item
		
	if selected_item is Truck:
		$selected_truck.visible = true
		$selected_truck.selected_truck = selected_item
		selected_truck = selected_item
	
	
