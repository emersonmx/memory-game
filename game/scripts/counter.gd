extends Node2D

signal finished_counting;

enum Mode {
	INCREMENT, DECREMENT
}

export(int) var count = 0
export(int) var to = 999
export(int, 'Increment', 'Decrement') var mode = Mode.INCREMENT
var _rounded_count = 0
var _is_finished_counting = false
var stop_count = false

onready var value_label = get_node('value')

func _ready():
	_rounded_count = count
	_update_text_value()

func is_finished_counting():
	return _is_finished_counting

func update(value):
	if stop_count:
		return

	if _is_finished_counting:
		return

	if mode == Mode.DECREMENT:
		count -= value
		if count <= to:
			count = to
			_is_finished_counting = true
	else:
		count += value
		if count >= to:
			count = to
			_is_finished_counting = true

	_update_text_value()

	if _is_finished_counting:
		emit_signal('finished_counting')

func _update_text_value():
	_rounded_count = round(count)
	value_label.set_text(str(_rounded_count))