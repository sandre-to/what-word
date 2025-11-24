class_name GameScene extends Control

const WORD_PATH_FILE: String = "res://assets/list_of_words/5-letter-words.txt"
const ROW: PackedScene = preload("res://scenes/row.tscn")

@onready var container: VBoxContainer = $WordContainer

#effects
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var score_sound: AudioStreamPlayer = $ScoreSound
@onready var applause_sound: AudioStreamPlayer = $ApplauseSound
@onready var restart_button: Button = $RestartButton

@onready var game_timer: Timer = $Timer
@onready var timer_label: Label = $TimerLabel

var rng := RandomNumberGenerator.new()
var current_word: String = ""
var time_in_minutes: int = 3
var time_in_secs: int = 0

func _ready() -> void:
	SignalBus.sound_played.connect(_on_correct_letter)
	SignalBus.guessed_correct_word.connect(_on_correct_word)
	anim.play("fade_out")
	time_in_secs = time_in_minutes * 60
	timer_label.text = '%02d:%02d' % [time_in_minutes, 0]
	
	random_word_from_list()
	add_new_row()
	print(current_word)
	
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

func _on_correct_letter() -> void:
	score_sound.play()

func _on_correct_word() -> void:
	applause_sound.play()
	restart_button.show()

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	time_in_secs -= 1 
	var minutes := int(time_in_secs / 60)
	var seconds := time_in_secs - minutes * 60
	timer_label.text = '%02d:%02d' % [minutes, seconds]
