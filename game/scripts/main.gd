extends Node2D

var game_scene = preload('res://scenes/game.tscn')
var scores_scene = preload('res://scenes/scores.tscn')
onready var scene_animation = get_node('scene_animation')

func _ready():
	_add_game_scene()
	scene_animation.connect('finished', self, '_on_animation_finished')

func _add_game_scene():
	var game = game_scene.instance()
	add_child(game)
	game.connect('show_scores', self, '_on_show_scores')

func _add_scores_scene(score):
	var scores = scores_scene.instance()
	add_child(scores)
	scores.connect('show_game', self, '_on_show_game')
	scores.set_pos(Vector2(0, 152))
	scores.player_score = score

func _on_animation_finished():
	if scene_animation.get_current_animation() == 'show_scores':
		get_node('game').queue_free()
	elif scene_animation.get_current_animation() == 'show_game':
		get_node('scores').queue_free()

func _on_show_scores(score):
	_add_scores_scene(score)
	scene_animation.stop_all()
	scene_animation.play('scroll_down')

func _on_show_game():
	_add_game_scene()
	scene_animation.stop_all()
	scene_animation.play('scroll_up')