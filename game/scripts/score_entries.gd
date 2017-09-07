extends Node2D

const MAX_SCORES = 10

onready var entry_scene = preload('res://scenes/score_entry.tscn')

func _ready():
	_setup_entries()

func _setup_entries():
	var base_pos = Vector2()
	var i = 0
	for score in _load_scores():
		var entry = entry_scene.instance()
		add_child(entry)
		entry.set_pos(Vector2(base_pos.x, base_pos.y + (i * 10)))
		entry.set_name(score['name'])
		entry.set_score("%s/%s" % [str(score['miss']).pad_zeros(2),
						str(score['time']).pad_zeros(3)])
		i += 1

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
	var scores = _load_scores()
	scores.append(score)
	scores.sort_custom(self, '_score_sort')
	if scores.size() > MAX_SCORES:
		scores.resize(MAX_SCORES)

	var f = File.new()
	f.open('user://scores.csv', File.WRITE)
	for s in scores:
		f.store_string('%s,%s,%s\n' % [s['name'], s['miss'], s['time']])
	f.close()

func _score_sort(a, b):
	if a['miss'] < b['miss']:
		return true
	elif a['miss'] == b['miss']:
		if a['time'] < b['time']:
			return true

	return false