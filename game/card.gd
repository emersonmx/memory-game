extends Area2D

signal card_selected
signal card_hovered

var type
var front
var back
var flipped = false setget set_flipped

func init(front, back, type):
	self.front = front
	self.back = back
	self.type = type
	flipped = false

func _ready():
	set_process_input(true)

func _input_event(viewport, event, shape_idx):
	if (event.type == InputEvent.MOUSE_BUTTON
			and event.button_index == BUTTON_LEFT
			and event.pressed):
		emit_signal('card_selected', self)
	if (event.type == InputEvent.MOUSE_MOTION):
		emit_signal('card_hovered', self)

func set_flipped(value):
	flipped = value
	var sprite_node = get_node('sprite')
	if value:
		sprite_node.set_texture(front)
	else:
		sprite_node.set_texture(back)