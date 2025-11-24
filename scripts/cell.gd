class_name Cell extends Label

@onready var letter_sound: AudioStreamPlayer = $LetterSound

var letter: String = "":
	set(value):
		if value.length() > 0 and \
		value.is_valid_ascii_identifier() and \
		not value == "_" and can_edit:
			letter = value[0].to_upper()
		else:
			letter = ""
		text = letter
		letter_sound.play()

var can_edit: bool = true:
	set(value):
		if value == false:
			focus_mode = Control.FOCUS_NONE
