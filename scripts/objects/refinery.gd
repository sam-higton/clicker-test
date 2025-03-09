class_name Refinery extends Area2D

var game_manager:GameManager
var refinery_name:String = "Refinery 1"
var trucks:Array[Truck] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	body_entered.connect(on_enter)
	body_exited.connect(on_exit)
	game_manager.interface.adding_truck.connect(add_truck)
	get_tree().create_timer(0.1).timeout.connect(add_truck)
	
func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			game_manager.interface.set_selected_item(self)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func on_enter(body):
	if body.has_method('enter_refinery'): body.enter_refinery()

func on_exit(body):
	if body.has_method('exit_refinery'): body.exit_refinery()
	
func add_truck():
	var new_truck:Truck = game_manager.masters.master_truck.duplicate()
	trucks.append(new_truck)
	new_truck.truck_name = "%s truck %s" % [refinery_name, trucks.size()]
	new_truck.global_position = $truck_spawn.global_position
	get_parent().add_child(new_truck)
	new_truck.init_truck()
