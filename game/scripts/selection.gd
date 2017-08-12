extends Sprite

func _on_mouse_enter(card):
	if get_tree().is_paused():
		return

	var offset = Vector2(3, 3)
	set_pos(card.get_global_pos() - offset)
	show()