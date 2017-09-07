extends Node2D

onready var name_node = get_node('name')
onready var score_node = get_node('score')

func _ready():
	pass

func set_name(value):
	name_node.set_text(value.to_upper())

func set_score(value):
	score_node.set_text(value.to_upper())