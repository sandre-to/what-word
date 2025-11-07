class_name LetterContainer extends HBoxContainer

var current_letter: int = 0

func _ready() -> void:
	get_child(0).grab_focus()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("erase"):
		if get_child(current_letter).text != "":
			return
		current_letter -= 1
		get_child(current_letter).grab_focus()

func _on_letter_text_changed(new_text: String) -> void:
	get_child(current_letter).text = new_text.to_upper()
	current_letter += 1
	if current_letter < 5:
		get_child(current_letter).grab_focus()
