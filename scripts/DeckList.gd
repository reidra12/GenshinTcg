extends Control

signal deck_selected(deck_path: String)

@onready var deck_container = $DeckContainer
@onready var deck_scene = preload("res://scenes/individual_deck.tscn")
@onready var save_manager = preload("res://scripts/SaveManager.gd").new()

func _ready():
	show_all_decks()

func show_all_decks():
	var dir = DirAccess.open("user://Save")
	if dir == null:
		push_error("Could not open save directory.")
		return

	dir.list_dir_begin()
	var file_name = dir.get_next()
	while file_name != "":
		if file_name.ends_with(".json"):
			var full_path = "user://Save/" + file_name
			create_deck_entry(file_name, full_path)
		file_name = dir.get_next()
	dir.list_dir_end()

func create_deck_entry(file_name: String, path: String):
	var deck_ui = deck_scene.instantiate()
	var deck_name = file_name.replace(".json", "")

	var deck_name_label = deck_ui.get_node("DeckContainer/DeckName")

	if deck_name_label:
		deck_name_label.text = deck_name
	else:
		push_warning("DeckName node not found in IndividualDeck scene!")

	deck_container.add_child(deck_ui)

	deck_ui.connect("gui_input", func(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("deck_selected", path)
			queue_free() # remove DeckList scene after selecting
	)
