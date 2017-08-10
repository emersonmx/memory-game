extends Area2D

signal card_selected
signal card_hovered

func _ready():
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON
			and event.button_index == BUTTON_LEFT
			and event.pressed):
		emit_signal('card_selected', self)
	if (event.type == InputEvent.MOUSE_MOTION):
		emit_signal('card_hovered', self)