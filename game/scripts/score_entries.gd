extends Node2D

signal entries_fadded_in
signal entries_fadded_out

const MAX_SCORES = 10
const FADE_TIME = 0.1

enum { FADE_NONE, FADE_OUT, FADE_IN }

var fade_type = FADE_NONE
var entries_count = 0
var scores = []

onready var entry_scene = preload('res://scenes/score_entry.tscn')

func _ready():
	_reset()

func _reset():
	fade_type = FADE_NONE
	entries_count = 0
	scores = _load_scores()

func has_entries():
	return scores.size() > 0

func is_first_entry():
	return scores.size() == 1

func show_entries():
	if fade_type != FADE_NONE:
		return

	_reset()
	fade_type = FADE_IN

	var base_pos = Vector2()
	var i = 0
	for score in scores:
		var entry = entry_scene.instance()
		add_child(entry)
		entry.connect('fadded_in', self, '_on_entry_fadded_in')
		entry.connect('fadded_out', self, '_on_entry_fadded_out')
		entry.set_pos(Vector2(base_pos.x, base_pos.y + (i * 10)))
		entry.set_name(score['name'])
		entry.set_score("%s/%s" % [str(score['miss']).pad_zeros(2),
						str(score['time']).pad_zeros(3)])
		entry.fade_in(FADE_TIME * (i + 1))
		i += 1

func hide_entries():
	if fade_type != FADE_NONE:
		return

	_reset()
	fade_type = FADE_OUT

	for i in range(0, get_child_count()):
    	get_child(i).fade_out(FADE_TIME * (i + 1))

func _load_scores():
	var scores = []
	var f = File.new()
	f.open('user://scores.csv', File.READ)
	while not f.eof_reached():
		var row = f.get_csv_line()
		if row.size() != 3:
			break
		scores.append({ 'name': row[0], 'miss': int(row[1]), 'time': int(row[2]) })
	f.close()

	scores.sort_custom(self, '_score_sort')
	return scores

func save_score(score):
	scores = _load_scores()

	scores.append(score)
	scores.sort_custom(self, '_score_sort')
	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)

	var f = File.new()
	f.open('user://scores.csv', File.WRITE)
	for s in scores:
		f.store_string('"%s","%s","%s"\n' % [s['name'], s['miss'], s['time']])
	f.close()

func _score_sort(a, b):
	if a['miss'] < b['miss']:
		return true
	elif a['miss'] == b['miss']:
		if a['time'] < b['time']:
			return true

	return

func _fade_emit_signal(fade_signal, fade_type):
	if self.fade_type != fade_type:
		return
	entries_count += 1
	if entries_count >= scores.size()-1:
		_reset()
		emit_signal(fade_signal)

func _on_entry_fadded_in():
	_fade_emit_signal('entries_fadded_in', FADE_IN)

func _on_entry_fadded_out():
	_fade_emit_signal('entries_fadded_out', FADE_OUT)