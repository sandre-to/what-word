class_name Row extends HBoxContainer

enum MaxCells {
	THREE = 3,
	FOUR = 4,
	FIVE = 5,
	SIX = 6
}

const CELL: PackedScene = preload("res://scenes/cell.tscn")

@export var amount_cells: MaxCells = MaxCells.THREE
var current_index: int = 0

func _ready() -> void:
	for i in range(amount_cells):
		var cell := CELL.instantiate()
		add_child(cell)
	
	get_child(0).grab_focus()
	set_process_input(true)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var cell: Cell = get_viewport().gui_get_focus_owner()
		if cell == null:
			return
		
		var key: String = event.as_text()
		if key.length() == 1 and key.to_upper() >= "A" and key.to_upper() <= "Z":
			cell.letter = key
		
		if event.is_action_pressed("erase"):
			cell.letter = ""
