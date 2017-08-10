extends Node2D

const CARD_SIZE = Vector2(22, 32)
const CARD_MARGIN = Vector2(5, 8)
const CARDS_PER_ROW = 3
const CARDS_PER_COLUMN = 6
enum Card {
	BLANK, ONE_UP, COIN10, COIN20, FLOWER, MUSHROOM, N, STAR
}

var cards = []
var selection = Vector2(0, 0)

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

func create_cards():
	for i in range(CARDS_PER_ROW):
		cards.append([])
		cards[i] = []
		for j in range(CARDS_PER_COLUMN):
			cards[i].append([])
			cards[i][j] = Card.N
			create_card(i, j)

func create_card(i, j):
	var card_instance = card_node.instance()
	card_instance.connect('card_selected', self, '_on_card_selected')
	card_instance.connect('card_hovered', self, '_on_card_hovered')
	var position = Vector2(
		CARD_MARGIN.x * j + CARD_SIZE.x * j,
		CARD_MARGIN.y * i + CARD_SIZE.y * i)
	card_instance.set_pos(position)
	card_instance.get_node('sprite').set_texture(card_textures[Card.N])
	cards_node.add_child(card_instance)
	
func _on_card_selected(card):
	print('Selected')

func _on_card_hovered(card):
	var offset = Vector2(3, 3)
	selection_node.set_pos(card.get_global_pos() - offset)
	selection_node.show()