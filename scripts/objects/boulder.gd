class_name Boulder extends Area2D

signal property_changed
signal rock_created(rock:Rock)

var has_mouse:bool = false
var game_manager:GameManager
var boulder_name:String = 'Boulder 1'

var miner_rate:float = 0.1
var miner_frequency:float = 0.5
var miner_active:bool = false
var click_rate:float = 0.1
var progress_to_rock:float = 0.0:
	set(value):
		progress_to_rock = value
		if(value >= 1):	
			make_new_rock()
			progress_to_rock = 0.0
		$ProgressBar.value = progress_to_rock
		$ProgressBar.visible = (progress_to_rock > 0.0)
		
			
			

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			rock_clicked()

func rock_clicked():
	if(game_manager.picking_boulder):
		game_manager.interface.selected_truck.set_boulder(self)
		game_manager.picking_boulder = false
	else:
		progress_to_rock += click_rate
		game_manager.interface.set_selected_item(self)
		
func make_new_rock() -> void:
	var master_rock = game_manager.masters.master_rock
	var new_rock = master_rock.duplicate()
	var current_position = get_global_position()
	var distance = randi_range(50,100)
	var angle = randi_range(0, 360)
	var posX = distance * cos(angle)
	var posY = distance * sin(angle)

	new_rock.global_position = Vector2(current_position.x + posX, current_position.y + posY)
	new_rock.add_to_group(rock_group())
	get_parent().add_child(new_rock)	
	rock_created.emit(new_rock)

func miner_group():
	return 'miners_%s' % boulder_name
	
func rock_group():
	return 'rocks_%s' % boulder_name

func move_miners():
	for miner in get_tree().get_nodes_in_group(miner_group()):
		miner.global_position.x += 15
		miner.global_position.y += randi_range(-5, 5)

func add_miner():
	move_miners()
	var new_miner = game_manager.masters.master_miner.duplicate()
	new_miner.global_position = $miner_spawn.global_position
	new_miner.boulder = self
	new_miner.add_to_group(miner_group())
	get_parent().add_child(new_miner)
	
func do_mine(progress_amount:float):
	progress_to_rock += progress_amount
	
	
