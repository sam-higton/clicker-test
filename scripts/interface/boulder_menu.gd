extends Control

var game_manager:GameManager
var selected_boulder:Boulder:
	set(value):
		selected_boulder = value
		selected_boulder.property_changed.connect(update_boulder_properties)
		selected_boulder.miner_added.connect(update_miner_cost)
		
		update_boulder_properties()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	$add_miner.pressed.connect(add_miner)
	$add_miner.disabled = true	
	game_manager.dollars_changed.connect(can_afford_miner)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_boulder_properties():
	$boulder_name.text = selected_boulder.boulder_name
	$add_miner.text = "add miner ($%s)" % selected_boulder.miner_cost()
	
func add_miner():
	selected_boulder.add_miner()

	
func can_afford_miner(dollars:int):
	print('evaluating cost')
	if game_manager.dollars >= selected_boulder.miner_cost():
		$add_miner.disabled = false
	else:
		$add_miner.disabled = true

func update_miner_cost(miner:Miner):
	$add_miner.text = "add miner ($%s)" % selected_boulder.miner_cost()

