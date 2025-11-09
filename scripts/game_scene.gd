class_name GameScene extends Control

@onready var letter_container: HBoxContainer = $WordsContainer/LetterContainer
@onready var check_button: Button = $CheckButton

var current_word: String = ""
var guessed_word_sequence: Array[String] = []
var word_file_path: String = "res://assets/list_of_words/5-letter-words.txt"
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	var words := load_from_file(word_file_path)
	var i = rng.randi_range(0, words.size())
	var get_random_word = words.get(i)
	current_word = get_random_word
	print(current_word)

func _on_check_button_pressed() -> void:
	for letter: LineEdit in letter_container.get_children():
		if not letter.editable: return
		if letter.text == "": return
		
		letter.editable = false
		guessed_word_sequence.append(letter.text)
	
	var guessed_word: String = "".join(guessed_word_sequence).to_lower()
	if guessed_word == current_word:
		print("U GJUESSED RIGHT")
	else:
		print("WRONG!")

func load_from_file(path) -> PackedStringArray:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	var words_list: PackedStringArray = content.split("\n")
	return words_list
