class_name Cell extends Label

var letter: String = "":
	set(value):
		if value.length() > 0 and \
		value.is_valid_ascii_identifier() and \
		not value == "_" and can_edit:
			letter = value[0].to_upper()
		else:
			letter = ""
		text = letter

var can_edit: bool = true:
	set(value):
		if value == false:
			focus_mode = Control.FOCUS_NONE
