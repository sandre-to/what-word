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
var guessed_word: Array[String] = []
var game_manager: GameScene = null

func _ready() -> void:
	for i in range(amount_cells):
		var cell := CELL.instantiate()
		add_child(cell)
	
	guessed_word.resize(amount_cells)
	get_child(0).grab_focus()
	set_process_input(true)
	
	game_manager = get_parent()
	if game_manager == null:
		push_error("Missing game manager.")
	print(game_manager.current_word)

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var focused_cell: Cell = get_viewport().gui_get_focus_owner()
		if focused_cell == null:
			return
		
		var index: int = get_children().find(focused_cell)
		var key: String = event.as_text()
		
		if key.length() == 1 and key.to_upper() >= "A" and key.to_upper() <= "Z":
			focused_cell.letter = key
			guessed_word[index] = key
			_move_focus(index, 1, false)
		
		if event.is_action_pressed("erase"):
			focused_cell.letter = ""
			guessed_word[index] = ""
			_move_focus(index, -1, true)
		
		var current_guessed_word := "".join(guessed_word).to_lower()
		
		if event.is_action_pressed("ui_accept"):
			var word_file := game_manager.load_from_file(game_manager.WORD_PATH_FILE)
			
			if current_guessed_word.length() < amount_cells:
				print("Word not filled")
				return
			
			if current_guessed_word in word_file:
				print("Word exist!")
				return
			
			print("Word not in list!")
func _move_focus(index: int, which_way: int,  left: bool) -> void:
	index += which_way
	
	if left and index == -1: return
	if not left and index >= get_children().size(): return
	
	get_child(index).grab_focus()
