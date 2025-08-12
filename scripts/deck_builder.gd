extends Control

const CHARACTER_CARD_SCENE = preload("res://scenes/CharacterCard.tscn")
const ACTION_CARD_SCENE = preload("res://scenes/ActionCard.tscn")
const DECK_LIST_SCENE = preload("res://scenes/deck_list.tscn")

@onready var card_library = $ScrollContainer/CardLibrary
@onready var deck_list = $HScrollBar/DeckList
@onready var save_manager = preload("res://scripts/SaveManager.gd").new()
@onready var save_deck_name = $SaveDeckName
@onready var load_deck = $LoadDeck


var available_cards: Array[CardData] = []
var player_deck = Deck.new()
var player_deck2 = Deck.new()
var max_card = 3

func _ready():
	load_card_library()
	update_ui()
	save_manager.load_all_cards()
	ensure_save_dir()
	load_deck.filters = PackedStringArray(["*.json"])
	load_deck.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	load_deck.access = FileDialog.ACCESS_USERDATA
	load_deck.current_dir = "user://Save"
	load_deck.connect("file_selected", _on_load_file_selected)


func load_card_library():
	var dir = DirAccess.open("res://Data/")
	for file in dir.get_files():
		if file.ends_with(".tres"):
			var card = load("res://Data/" + file)
			if card:
				available_cards.append(card)

func get_card_scene(card: CardData) -> PackedScene:
	if card.card_type == "CharacterCard":
		return CHARACTER_CARD_SCENE
	elif card.card_type == "ActionCard":
		return ACTION_CARD_SCENE
	else:
		push_error("Unknown card type: " + str(card.card_type))
		return CHARACTER_CARD_SCENE # fallback


func update_ui():
	for child in card_library.get_children():
		child.queue_free()

	for card in available_cards:
		var card_scene = get_card_scene(card)
		var card_instance = card_scene.instantiate()
		card_instance.card_data = card
		card_library.add_child(card_instance)

		card_instance.get_node("Control").connect("gui_input", func(event):
			if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
				if player_deck.add_card(card, max_card):
					update_deck_list()
				else:
					print("Cannot add more than %s copies of %s" % [max_card, card.card_name]
					))


func update_deck_list():
	print("Updating deck list with", player_deck.cards.size(), "cards.")
	for child in deck_list.get_children():
		child.queue_free()

	for card in player_deck.cards:
		var card_scene = get_card_scene(card)
		var card_instance = card_scene.instantiate()
		card_instance.card_data = card
		deck_list.add_child(card_instance)

func _on_save_pressed():
	var save_name = save_deck_name.text.strip_edges()
	if save_name == "":
		push_warning("Save name cannot be empty!")
		return
	var path = "user://Save/" + save_name + ".json"
	var path_2 = "res://Save/" + save_name + ".json"
	print("Saving deck to:", path)
	save_manager.save_deck(player_deck, path)
	save_manager.save_deck(player_deck, path_2)
	

func _on_load_pressed():
	var deck_list_scene = DECK_LIST_SCENE.instantiate()
	deck_list_scene.connect("deck_selected", Callable(self, "_on_deck_selected"))
	add_child(deck_list_scene)

func _on_deck_selected(path: String):
	player_deck = save_manager.load_deck(path)
	update_deck_list()

func _on_load_file_selected(path: String):
	player_deck = save_manager.load_deck(path)
	update_deck_list()

func ensure_save_dir():
	if not DirAccess.dir_exists_absolute("user://Save"):
		DirAccess.make_dir_absolute("user://Save")


