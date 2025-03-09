class_name MasterRepository extends Node2D

var master_truck:Truck
var master_rock:Rock
var master_miner:Miner
var master_boulder:Boulder
var camera_speed = 400


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	master_truck = $master_truck
	master_rock = $master_rock
	master_miner = $master_miner
	master_boulder = $master_boulder

func _process(delta):
	var input_dir = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_dir.x += 1
	if Input.is_action_pressed("ui_left"):
		input_dir.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_dir.y += 1
	if Input.is_action_pressed("ui_up"):
		input_dir.y -= 1
	
	input_dir = input_dir.normalized()
	global_position += input_dir * camera_speed * delta
