extends Node2D

signal fadded_in
signal fadded_out

const MAX_SIZE = 20

var name = ''
var score = ''

onready var text_node = get_node('text')
onready var fade_in_timer_node = get_node('fade_in_timer')
onready var fade_out_timer_node = get_node('fade_out_timer')

func _ready():
	fade_in_timer_node.connect('timeout', self, '_on_fade_in_timeout')
	fade_out_timer_node.connect('timeout', self, '_on_fade_out_timeout')

func set_name(value):
	name = value
	_upload_text()

func set_score(value):
	score = value
	_upload_text()

func fade_out(time):
	fade_out_timer_node.set_wait_time(time)
	fade_out_timer_node.start()

func fade_in(time):
	fade_in_timer_node.set_wait_time(time)
	fade_in_timer_node.start()

func  _upload_text():
	var dots = ''
	for i in range(name.length() + score.length(), MAX_SIZE):
		dots += '.'
	text_node.set_text(name + dots + score)

func _on_fade_in_timeout():
	emit_signal('fadded_in')
	show()

func _on_fade_out_timeout():
	emit_signal('fadded_out')
	queue_free()