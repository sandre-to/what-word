class_name GameScene extends Control

const WORD_PATH_FILE: String = "res://assets/list_of_words/5-letter-words.txt"
const ROW: PackedScene = preload("res://scenes/row.tscn")

var rng := RandomNumberGenerator.new()
var current_word: String = ""

func _ready() -> void:
	random_word_from_list()
	add_child(ROW.instantiate())

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_accept"):
		#var letter_container := get_child(0)
	#
		#var guessed_word := "".join(guessed_word_sequence).to_lower()
		#var list_of_words := load_from_file(WORD_PATH_FILE)
		#
		## GAMEPLAY LOOP
		#for word in list_of_words:
			#if word == guessed_word:
				#for letter_box in letter_container.get_children():
					#letter_box.editable = false
			#
				#for letter in word.length():
					#if word[letter] in current_word:
						#if word[letter] == current_word[letter]:
							#letter_container.get_child(letter).modulate = Color.GREEN
						#else:
							#letter_container.get_child(letter).modulate = Color.ORANGE
						#print("The letter [%s] is in the word" % word[letter])
					#else:
						#print("Letter [%s] not in word" % word[letter])
				#return
		#
		#print("The word doesn't exist!")

func load_from_file(path) -> PackedStringArray:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	var words_list: PackedStringArray = content.split("\n")
	return words_list

func random_word_from_list() -> void:
	var words := load_from_file(WORD_PATH_FILE)
	var index = rng.randi_range(0, words.size())
	current_word = words.get(index)
