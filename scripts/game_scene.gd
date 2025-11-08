class_name GameScene extends Control

@onready var letter_container: HBoxContainer = $WordsContainer/LetterContainer
@onready var check_button: Button = $CheckButton

var guessed_word: Array[String] = []

func _on_check_button_pressed() -> void:
	for letter: LineEdit in letter_container.get_children():
		if not letter.editable: return
		if letter.text == "": return
		
		letter.editable = false
		guessed_word.append(letter.text)
	print(guessed_word)
