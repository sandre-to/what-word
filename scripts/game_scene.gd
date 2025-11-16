class_name GameScene extends Control

const WORD_MAX_LENGTH: int = 4
const WORD_PATH_FILE: String = "res://assets/list_of_words/5-letter-words.txt"

@onready var letter_container: HBoxContainer = $WordsContainer/LetterContainer
@onready var check_button: Button = $CheckButton

var current_word: String = ""
var guessed_word_sequence: Array[String] = []
var rng := RandomNumberGenerator.new()

func _ready() -> void:
	SignalBus.changed_letter.connect(_updated_letter_box)
	random_word_from_list()

func _on_check_button_pressed() -> void:
	if guessed_word_sequence.size() < current_word.length() - 1: return
	
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

func random_word_from_list() -> void:
	var words := load_from_file(WORD_PATH_FILE)
	var i = rng.randi_range(0, words.size())
	var get_random_word = words.get(i)
	current_word = get_random_word
	print(current_word)

func _updated_letter_box(letter: String, source: LineEdit) -> void:
	var index := letter_container.get_children().find(source)
	if index == -1: return
	
	# resize the guessed word to max 5 letters
	if guessed_word_sequence.size() < current_word.length(): 
		guessed_word_sequence.resize(current_word.length())
	
	guessed_word_sequence[index] = letter
	print("".join(guessed_word_sequence).to_lower())
