class_name Cell extends Label

var letter: String = "":
	set(value):
		if value.length() > 0:
			letter = value[0].to_upper()
		else:
			letter = ""
		text = letter
