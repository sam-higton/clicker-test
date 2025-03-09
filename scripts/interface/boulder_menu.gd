extends Control

var game_manager:GameManager
var selected_boulder:Boulder:
	set(value):
		selected_boulder = value
		selected_boulder.property_changed.connect(update_boulder_properties)
		update_boulder_properties()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	$add_miner.pressed.connect(add_miner)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_boulder_properties():
	$boulder_name.text = selected_boulder.boulder_name
	
func add_miner():
	selected_boulder.add_miner()
