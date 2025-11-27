class_name WordContainer extends VBoxContainer

func _ready() -> void:
	SignalBus.added_signal.connect(_on_row_added)
	
func _on_row_added() -> void:
	for row in get_children():
		if get_children().size() > 4:
			get_child(0).queue_free()
