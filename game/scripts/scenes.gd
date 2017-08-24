extends Node2D

var game_scene = preload('res://scenes/game.tscn')
var scores_scene = preload('res://scenes/scores.tscn')
onready var animation_node = get_node('animation')

func _ready():
	_add_game_scene()
	animation_node.connect('finished', self, '_on_animation_finished')

func _add_game_scene():
	var game = game_scene.instance()
	game.connect('show_scores', self, '_on_show_scores')
	add_child(game)

func _add_scores_scene():
	var scores = scores_scene.instance()
	scores.connect('show_game', self, '_on_show_game')
	scores.set_pos(Vector2(0, 152))
	add_child(scores)

func _on_animation_finished():
	if animation_node.get_current_animation() == 'show_scores':
		get_node('game').queue_free()
	elif animation_node.get_current_animation() == 'show_game':
		get_node('scores').queue_free()

func _on_show_scores():
	_add_scores_scene()
	animation_node.stop_all()
	animation_node.play('show_scores')

func _on_show_game():
	_add_game_scene()
	animation_node.stop_all()
	animation_node.play('show_game')