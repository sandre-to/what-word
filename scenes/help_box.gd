class_name HelpBox extends VBoxContainer

@onready var wrong_label: Label = %WrongLetters
@onready var right_label: Label = %RightLetters

var wrong_letters: Array[String]
var right_letters: Array[String]

func _ready() -> void:
	SignalBus.sent_right_keys.connect(_on_right_keys_sent)
	SignalBus.sent_wrong_keys.connect(_on_wrong_keys_sent)
	
func _on_right_keys_sent(key: String) -> void:
	if right_letters.has(key):
		return
		
	right_letters.append(key)
	right_label.text = "".join(right_letters).to_upper()

func _on_wrong_keys_sent(key: String) -> void:
	if wrong_letters.has(key):
		return

	wrong_letters.append(key)
	wrong_label.text = "".join(wrong_letters).to_upper()
