class_name Rock extends Area2D

enum RockType {
	STONE,
	IRON,
	COPPER,
	DIAMOND
}

var rock_type: int = RockType.STONE
var rocks: Array = [RockType.STONE, RockType.IRON, RockType.COPPER, RockType.DIAMOND]
var dragging:bool = false
var over_refinery:bool = false
var game_manager:GameManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_manager = get_tree().current_scene
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	get_viewport().set_input_as_handled()
	
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			start_dragging()
		elif !event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			stop_dragging()
					
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		if dragging:
			global_position = get_global_mouse_position()
			
func start_dragging():
	dragging = true
	
func stop_dragging():
	dragging = false
	if(over_refinery): feed_refinery()
		
	
func enter_refinery():
	over_refinery = true
	
func exit_refinery():
	over_refinery = false
	
func feed_refinery():
	game_manager.add_rock()
	queue_free()
	
