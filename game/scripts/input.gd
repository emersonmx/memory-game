extends LineEdit

signal input_done

func _ready():
	grab_focus()
	self.connect('text_changed', self, '_on_text_changed')
	self.connect('input_event', self, '_on_input_event')

func _on_text_changed(text):
	var new_text = text.to_upper()
	var cursor = get_cursor_pos()
	set_text(new_text)
	set_cursor_pos(cursor)

func _on_input_event(ev):
	if ev.is_action_pressed('ui_accept'):
		emit_signal('input_done', get_text())