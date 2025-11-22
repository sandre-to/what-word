class_name GameScene extends Control

const WORD_PATH_FILE: String = "res://assets/list_of_words/5-letter-words.txt"
const ROW: PackedScene = preload("res://scenes/row.tscn")

@onready var container: VBoxContainer = $WordContainer

var rng := RandomNumberGenerator.new()
var current_word: String = ""

func _ready() -> void:
	random_word_from_list()
	add_new_row()

func load_from_file(path) -> PackedStringArray:
	var file: FileAccess = FileAccess.open(path, FileAccess.READ)
	var content: String = file.get_as_text()
	var words_list: PackedStringArray = content.split("\n")
	return words_list

func random_word_from_list() -> void:
	var words := load_from_file(WORD_PATH_FILE)
	var index = rng.randi_range(0, words.size())
	current_word = words.get(index)

func add_new_row() -> void:
	container.add_child(ROW.instantiate())
	SignalBus.added_signal.emit()
