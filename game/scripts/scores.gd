extends Node2D

signal show_game

var player_score = {'name': '', 'miss': 0, 'time': 0}
var fade_in_count = 0

onready var input_node = get_node('panel/input')
onready var entries_node = get_node('score_entries')
onready var timer_node = get_node('timer')

func _ready():
	input_node.connect('input_done', self, '_on_input_done')
	timer_node.connect('timeout', self, '_on_timeout')
	entries_node.connect('entries_fadded_in', self, '_on_entries_fadded_in')
	entries_node.connect('entries_fadded_out', self, '_on_entries_fadded_out')

	if not entries_node.has_entries():
		return

	entries_node.show_entries()

func _on_input_done(text):
	if text.length() > 0:
		get_node('panel').hide()
		player_score['name'] = text
		entries_node.save_score(player_score)
		if entries_node.is_first_entry():
			entries_node.show_entries()
			fade_in_count += 1
		else:
			entries_node.hide_entries()

func _on_timeout():
	emit_signal('show_game')
	print('lol')

func _on_entries_fadded_in():
	fade_in_count += 1
	if fade_in_count <= 1:
		return
	timer_node.start()

func _on_entries_fadded_out():
	entries_node.show_entries()