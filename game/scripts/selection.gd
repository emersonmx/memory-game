extends Sprite

func _ready():
	pass

func _on_card_hovered(card):
	var offset = Vector2(3, 3)
	set_pos(card.get_global_pos() - offset)
	show()