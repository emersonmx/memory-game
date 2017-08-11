extends Node2D

const CARD_SIZE = Vector2(22, 32)
const CARD_MARGIN = Vector2(5, 8)
const CARDS_PER_ROW = 3
const CARDS_PER_COLUMN = 6
enum Card {
	BLANK, ONE_UP, COIN10, COIN20, FLOWER, MUSHROOM, N, STAR
}

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

var card_node = preload('res://card.tscn')

onready var cards_node = get_node('cards')
onready var selection_node = get_node('selection')

func _ready():
	create_cards()
	set_process(true)

func _process(delta):
	if _is_gameover():
		print('Game Over')

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
	card_instance.connect('card_selected', self, '_on_card_selected')
	card_instance.connect('card_hovered', selection_node, '_on_card_hovered')

	var position = Vector2(
		CARD_MARGIN.x * j + CARD_SIZE.x * j,
		CARD_MARGIN.y * i + CARD_SIZE.y * i)
	card_instance.flipped = false
	card_instance.set_pos(position)
	cards_node.add_child(card_instance)

func _is_gameover():
	var all_cards_flipped = true
	for card in cards_node.get_children():
		all_cards_flipped = all_cards_flipped and card.flipped
	return all_cards_flipped

func _on_card_selected(card):
	if card.flipped:
		return

	if first_card and second_card:
		if get_node('timer').get_time_left() > 0:
			return

		first_card = null
		second_card = null

	if first_card and first_card == card:
		print('same')
		return

	card.flipped = true

	if first_card == null:
		first_card = card
		return

	second_card = card

	if first_card.type != second_card.type:
		get_node('timer').start()

func _on_timer_timeout():
	first_card.flipped = false
	second_card.flipped = false