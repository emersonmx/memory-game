extends Node2D

signal show_game

var player_score = {}

onready var input_node = get_node('panel/input')
onready var entries_node = get_node('score_entries')

func _ready():
	input_node.connect('input_done', self, '_on_input_done')

	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed("ui_select") and not event.is_echo():
		emit_signal('show_game')

func _on_input_done(text):
	if text.length() > 0:
		get_node('panel').hide()
		player_score['name'] = text
		entries_node.save_score(player_score)
		entries_node.show_entries()