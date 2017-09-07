extends Node2D

signal show_game

var player_score = {'name': '', 'miss': 0, 'time': 0}
var wait_click = false

onready var input_node = get_node('panel/input')
onready var entries_node = get_node('score_entries')
onready var timer_node = get_node('timer')

func _ready():
	input_node.connect('input_done', self, '_on_input_done')
	timer_node.connect('timeout', self, '_on_timeout')

func _on_input_done(text):
	if text.length() > 0:
		get_node('panel').hide()
		player_score['name'] = text
		entries_node.save_score(player_score)
		entries_node.show_entries()
		timer_node.start()

func _on_timeout():
	emit_signal('show_game')