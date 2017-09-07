extends Node2D

const CARD_SIZE = Vector2(22, 32)
const CARD_MARGIN = Vector2(6, 8)
const CARDS_PER_ROW = 3
const CARDS_PER_COLUMN = 6
enum Card {
	BLANK, ONE_UP, COIN10, COIN20, FLOWER, MUSHROOM, N, STAR
}

signal show_scores

var time = 999
var misses = 0
var cards = []
var _card_pool = [
	Card.ONE_UP, Card.ONE_UP,
	Card.COIN10, Card.COIN10, Card.COIN20, Card.COIN20,
	Card.FLOWER, Card.FLOWER, Card.FLOWER, Card.FLOWER,
	Card.MUSHROOM, Card.MUSHROOM, Card.MUSHROOM, Card.MUSHROOM,
	Card.STAR, Card.STAR, Card.STAR, Card.STAR
]
var selection = Vector2(0, 0)
var first_card = null
var second_card = null
var gameover = false

var card_textures = {
	Card.BLANK: preload('res://assets/images/cards/blank.tex'),
	Card.ONE_UP: preload('res://assets/images/cards/1up.tex'),
	Card.COIN10: preload('res://assets/images/cards/coin10.tex'),
	Card.COIN20: preload('res://assets/images/cards/coin20.tex'),
	Card.FLOWER: preload('res://assets/images/cards/flower.tex'),
	Card.MUSHROOM: preload('res://assets/images/cards/mushroom.tex'),
	Card.N: preload('res://assets/images/cards/n.tex'),
	Card.STAR: preload('res://assets/images/cards/star.tex'),
}

var card_node = preload('res://scenes/card.tscn')

onready var start_timer_node = get_node('start_timer')
onready var cards_node = get_node('cards')
onready var selection_node = get_node('selection')
onready var click2start_panel_node = get_node('click2start_panel')
onready var time_countdown_node = (
	get_node('status_panel').get_node('time_countdown'))
onready var miss_counter_node = (
	get_node('status_panel').get_node('miss_counter'))

func _ready():
	create_cards()
	get_tree().set_pause(true)
	set_process(true)

func _process(delta):
	if Input.is_action_pressed('action'):
		click2start_panel_node.get_node('text').set_text('SHUFFLING')
		start_timer_node.start()

	if get_tree().is_paused():
		return

	time_countdown_node.update(delta)

func create_cards():
	var card_list = _create_card_list()
	for i in range(CARDS_PER_ROW):
		cards.append([])
		cards[i] = []
		for j in range(CARDS_PER_COLUMN):
			cards[i].append([])
			var cardType = card_list.back()
			cards[i][j] = cardType
			create_card(i, j, cardType, Card.N)
			card_list.pop_back()

func _create_card_list():
	randomize()
	_card_pool = utils.shuffle_array(_card_pool)
	var result = []
	for card in _card_pool:
		result.append(card)
	return result

func create_card(i, j, type, back_type):
	var card_instance = card_node.instance()
	card_instance.init(card_textures[type], card_textures[back_type], type)
	card_instance.connect('mouse_enter', selection_node, '_on_mouse_enter', [card_instance])
	card_instance.connect('input_event', self, '_on_input_event', [card_instance])

	var position = Vector2(
		CARD_MARGIN.x * j + CARD_SIZE.x * j,
		CARD_MARGIN.y * i + CARD_SIZE.y * i)
	card_instance.flipped = false
	card_instance.set_pos(position)
	cards_node.add_child(card_instance)

func _is_gameover():
	if gameover:
		return gameover

	var all_cards_flipped = true
	for card in cards_node.get_children():
		all_cards_flipped = all_cards_flipped and card.flipped

	gameover = all_cards_flipped
	return all_cards_flipped

func _show_gameover():
	gameover = true
	time_countdown_node.stop_count = true
	miss_counter_node.stop_count = true
	get_node('gameover_panel').show()
	selection_node.queue_free()
	emit_signal('show_scores', {
		'miss': int(miss_counter_node.count),
		'time': int(time_countdown_node.count)
	})

func _start_game():
	click2start_panel_node.hide()
	get_tree().set_pause(false)

func _on_input_event(event, card):
	if _ignore_selection(event, card):
		return

	if first_card and second_card:
		if get_node('timer').get_time_left() > 0:
			return
		first_card = null
		second_card = null

	if first_card and first_card == card:
		return

	card.flipped = true

	if first_card == null:
		first_card = card
		return

	second_card = card

	if first_card.type != second_card.type:
		miss_counter_node.update(1)
		if !miss_counter_node.is_finished_counting():
			get_node('timer').start()

	if _is_gameover():
		_show_gameover()

func _ignore_selection(event, card):
	if !event.is_action_pressed('action'):
		return true
	if get_tree().is_paused():
		return true
	if gameover:
		return true
	if card.flipped:
		return true
	return false

func _on_timer_timeout():
	first_card.flipped = false
	second_card.flipped = false