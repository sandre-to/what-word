class_name Row extends HBoxContainer

enum MaxCells {
	THREE = 3,
	FOUR = 4,
	FIVE = 5,
	SIX = 6
}
const CELL: PackedScene = preload("res://scenes/cell.tscn")

@export var amount_cells: MaxCells = MaxCells.THREE

var guessed_word: Array[String] = []
var wrong_letters: Array[String] = []
var game_manager: GameScene = null
var is_word_correct: bool = false
var tween: Tween

func _ready() -> void:
	for i in range(amount_cells):
		var cell: Cell = CELL.instantiate()
		cell.can_edit = true
		add_child(cell)
	
	guessed_word.resize(amount_cells)
	get_child(0).grab_focus()
	set_process_input(true)
	
	game_manager = get_tree().get_first_node_in_group("game_scene")
	if game_manager == null:
		push_error("Missing game manager.")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.is_pressed():
		var focused_cell: Cell = get_viewport().gui_get_focus_owner()
		if focused_cell == null or not focused_cell.can_edit:
			return
		
		var index: int = get_children().find(focused_cell)
		var key: String = event.as_text()
		
		if key.length() == 1 and key.to_upper() >= "A" and key.to_upper() <= "Z":
			focused_cell.letter = key
			guessed_word[index] = key
			_move_focus(index, 1, false)
		
		if event.is_action("erase") and event.is_pressed():
			focused_cell.letter = ""
			guessed_word[index] = ""
			_move_focus(index, -1, true)
		
		var current_guessed_word := "".join(guessed_word).to_lower()
		
		if event.is_action_pressed("ui_accept"):
			var word_file := game_manager.load_from_file(game_manager.WORD_PATH_FILE)
			
			if current_guessed_word.length() < amount_cells: return
			if not current_guessed_word in word_file: return

			animate()
			_check_word(current_guessed_word)
			_release_focus()
			
			await tween.finished
			_add_new_row()

func _move_focus(index: int, which_way: int,  left: bool) -> void:
	index += which_way
	
	if left and index == -1: return
	if not left and index >= get_children().size(): return
	
	get_child(index).grab_focus()

func _check_word(word: String) -> void:
	var has_tweens: bool = false
	for i in range(amount_cells):
		var letter = word[i]
		var cell: Cell = get_child(i)
		
		if letter not in game_manager.current_word:
			SignalBus.sent_wrong_keys.emit(letter)
		
		if letter in game_manager.current_word:
			has_tweens = true
			SignalBus.sent_right_keys.emit(letter)
			tween.set_trans(Tween.TRANS_BOUNCE)
			tween.tween_callback(Callable(SignalBus.sound_played.emit))
			tween.tween_property(cell, "scale", Vector2(1.25, 1.25), 0.15)
			tween.tween_property(cell, "modulate", Color.GRAY, 0.17)
			tween.tween_property(cell, "rotation_degrees", 360, 0.15)
			tween.tween_property(cell, "modulate", Color.ORANGE, 0.12)
			tween.tween_property(cell, "scale", Vector2.ONE, 0.15)
			
		if letter == game_manager.current_word[i]:
			has_tweens = true
			tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
			tween.tween_property(cell, "modulate", Color.GREEN, 0.2)
		
		
	if not has_tweens:
		tween.tween_interval(0.02)
	
	await tween.finished
	if word == game_manager.current_word:
		is_word_correct = true
		SignalBus.guessed_correct_word.emit()
	
func _release_focus() -> void:
	for child in get_children():
		child.can_edit = false
		child.release_focus()

func _add_new_row() -> void:
	if not is_word_correct:
		game_manager.add_new_row()
		set_process_input(false)

func animate() -> void:
	if tween:
		tween.kill()
	tween = create_tween()
