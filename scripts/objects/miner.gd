class_name Miner extends Sprite2D

var boulder:Boulder
var mine_rate:float = 0.1
var mine_frequency:float = 0.5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().create_timer(randi_range(0.3, 1)).timeout.connect(mine)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func mine():
	if boulder is Boulder:
		boulder.do_mine(mine_rate)
		get_tree().create_timer(mine_frequency).timeout.connect(mine)
