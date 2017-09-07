extends Node2D

const MAX_SIZE = 20

var name = ''
var score = ''

onready var text_node = get_node('text')

func _ready():
	pass

func set_name(value):
	name = value
	_upload_text()

func set_score(value):
	score = value
	_upload_text()

func  _upload_text():
	var dots = ''
	for i in range(name.length() + score.length(), MAX_SIZE):
		dots += '.'
	text_node.set_text(name + dots + score)