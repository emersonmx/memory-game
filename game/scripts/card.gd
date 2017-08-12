extends Control

var type
var front
var back
var flipped = false setget set_flipped

func init(front, back, type):
	self.front = front
	self.back = back
	self.type = type
	flipped = false

func set_flipped(value):
	flipped = value
	var sprite_node = get_node('sprite')
	if value:
		sprite_node.set_texture(front)
	else:
		sprite_node.set_texture(back)