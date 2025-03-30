extends Node2D

signal state_changed(old_state, new_state)
enum test { STATE_0, STATE_1, STATE_2, STATE_3 }

var test_state:test = test.STATE_0:
	set(value):
		var old_value = test_state
		test_state = value
		state_changed.emit(old_value, value)
		
func _ready():
	state_changed.connect(on_state_change)
	test_state = test.STATE_1

func on_state_change(old_state, new_state):
	print('CHANGED FROM %s TO %s' % [old_state, new_state])
	
	if test_state == test.STATE_1:
		test_state = test.STATE_2
	elif test_state == test.STATE_2:
		test_state = test.STATE_3
		
