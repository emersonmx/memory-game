extends Node2D

signal show_game

func _ready():
	set_process_input(true)
	set_process(true)

func _input(event):
	if event.is_action_pressed("ui_select") and not event.is_echo():
		emit_signal('show_game')