extends Control

signal deck_selected(deck_path: String)

@onready var deck_container = $DeckContainer
@onready var deck_scene = preload("res://scenes/individual_deck.tscn")
@onready var save_manager = preload("res://scripts/SaveManager.gd").new()

func _ready():
	show_all_decks()

func show_all_decks():
	var save_dir := "user://Save"
	for child in deck_container.get_children():
		child.queue_free()

    # Try to open save_dir; if it doesn't exist, create it using a DirAccess instance
	var dir := DirAccess.open(save_dir)
	if dir == null:
		var root := DirAccess.open("user://")
		if root == null:
			push_error("Could not open user://")
			return
		if not root.dir_exists("Save"):
			var err := root.make_dir("Save")
			if err != OK and err != ERR_ALREADY_EXISTS:
				push_error("Failed to create save directory: %s" % save_dir)
				return
		dir = DirAccess.open(save_dir)
		if dir == null:
			push_error("Could not open save directory after creating it: %s" % save_dir)
			return
	
	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
        # skip directories
		if dir.current_is_dir():
			file_name = dir.get_next()
			continue

        # check extension case-insensitively
		if file_name.get_extension().to_lower() == "json":
			var full_path := save_dir + "/" + file_name
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

	deck_ui.connect("gui_input", func input_mouse(event):
		if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			emit_signal("deck_selected", path)
			queue_free() )
