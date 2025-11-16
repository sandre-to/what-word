class_name Letter extends LineEdit

const MAX_LENGTH: int = 1

func _ready() -> void:
	alignment = HORIZONTAL_ALIGNMENT_CENTER
	max_length = MAX_LENGTH

func _on_text_changed(new_text: String) -> void:
	text = new_text.to_upper()
	caret_column = text.length()
	SignalBus.changed_letter.emit(new_text, self)
