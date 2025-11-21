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
		
	get_child(current_index).grab_focus()
