class_name GameScene extends Control

const WORD_PATH_FILE: String = "res://assets/list_of_words/5-letter-words.txt"
const LETTER_BOX: PackedScene = preload("res://scenes/letter_container.tscn")

@onready var new_box_timer: Timer = $NewBoxTimer

var current_word: String = ""
var guessed_word_sequence: Array[String] = []
var rng := RandomNumberGenerator.new()
var counter: int = 0
var has_played: bool = false

func _ready() -> void:
	SignalBus.changed_letter.connect(_updated_letter_box)
	random_word_from_list()
	_add_letter_box()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and not has_played:
		var letter_container := get_child(0)
		
		if counter >= 2:
			for letter_box in letter_container.get_children():
				letter_box.editable = false
			print("NO MORE TRIES")
			return
		
		if guessed_word_sequence.size() < current_word.length() - 1: 
			print("Word not filled out")
			return
		
		var guessed_word := "".join(guessed_word_sequence).to_lower()
		var list_of_words := load_from_file(WORD_PATH_FILE)
		has_played = true
		
		# GAMEPLAY LOOP -- Checking if the guessed word is the same as current word
		for word in list_of_words:
			if word == guessed_word:
				for letter_box in letter_container.get_children():
					letter_box.editable = false
				counter += 1
				print("The word exists")
				print(counter)
				
				for letter in word.length():
					if word[letter] in current_word:
						if word[letter] == current_word[letter]:
							letter_container.get_child(letter).modulate = Color.GREEN
						else:
							letter_container.get_child(letter).modulate = Color.ORANGE
						print("The letter [%s] is in the word" % word[letter])
					else:
						print("Letter [%s] not in word" % word[letter])
				
				new_box_timer.start()
				return
		
		print("The word doesn't exist!")

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

func _add_letter_box() -> void:
	var letter_box := LETTER_BOX.instantiate()
	add_child(letter_box)
	move_child(letter_box, 0)

func _updated_letter_box(letter: String, source: LineEdit) -> void:
	var letter_container := get_child(0)
	var index := letter_container.get_children().find(source)
	if index == -1: return
	
	# resize the guessed word to max 5 letters
	if guessed_word_sequence.size() < current_word.length(): 
		guessed_word_sequence.resize(current_word.length())
	
	guessed_word_sequence[index] = letter
	print("".join(guessed_word_sequence).to_lower())

func check_guessed_word(guessed_word: String, list_of_words: PackedStringArray) -> void:
	if guessed_word in list_of_words:
		print("WORD IS IN LIST!")
		return
	
	print("Word is not in list")

func _on_new_box_timer_timeout() -> void:
	if counter >= 3:
		has_played = true
	
	has_played = false
	for letter_box in get_children():
		if letter_box is LetterContainer:
			letter_box.queue_free()
	_add_letter_box()
