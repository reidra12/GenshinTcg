extends Control

const CHARACTER_CARD_SCENE = preload("res://scenes/CharacterCard.tscn")
const ACTION_CARD_SCENE = preload("res://scenes/ActionCard.tscn")

@onready var card_library = $ScrollContainer/CardLibrary
@onready var deck_list = $HScrollBar/DeckList
@onready var save_manager = preload("res://scripts/SaveManager.gd").new()
@onready var save_deck_name = $SaveDeckName
@onready var load_deck = $LoadDeck

var available_cards: Array[CardData] = []
var player_deck = DeckManager.new()
var player_deck2 = DeckManager.new()
var max_card = 3

func _ready():
	# 1. DENGARKAN SIGNAL KLIK GLOBAL DARI SIGNALBUS
	SignalBus.global_card_clicked.connect(_on_global_card_clicked)
	
	load_card_library()
	update_ui()
	save_manager.load_all_cards()
	ensure_save_dir()
	
	load_deck.filters = PackedStringArray(["*.json"])
	load_deck.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	load_deck.access = FileDialog.ACCESS_USERDATA
	load_deck.current_dir = "user://SaveDeck"
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
		
		# KITA TIDAK PERLU LAGI MENGHUBUNGKAN GUI_INPUT DI SINI!
		# Kartu sekarang sudah otomatis lapor ke SignalBus saat diklik.

func update_deck_list():
	print("Updating deck list with ", player_deck.cards.size(), " cards.")
	for child in deck_list.get_children():
		child.queue_free()

	for card in player_deck.cards:
		var card_scene = get_card_scene(card)
		var card_instance = card_scene.instantiate()
		card_instance.card_data = card
		deck_list.add_child(card_instance)

# =======================================================
# 2. FUNGSI BARU UNTUK MERESPONS KLIK KARTU
# =======================================================
func _on_global_card_clicked(card_node: Node, card_data: CardData) -> void:
	# Cek A: Apakah kartu yang diklik berada di dalam Library (Bawah)?
	if card_node.get_parent() == card_library:
		print("Mencoba menambah kartu ke deck: ", card_data.card_name)
		if player_deck.add_card(card_data, max_card):
			update_deck_list()
		else:
			print("Gagal: Tidak bisa menambah lebih dari %s copy %s" % [max_card, card_data.card_name])
			
	# Cek B: Apakah kartu yang diklik berada di dalam Deck List (Atas)?
	elif card_node.get_parent() == deck_list:
		print("Menghapus kartu dari deck: ", card_data.card_name)
		# Menghapus satu kartu data tersebut dari array deck
		player_deck.cards.erase(card_data) 
		# Perbarui tampilan deck
		update_deck_list()


func _on_save_pressed():
	var save_name = save_deck_name.text.strip_edges()
	if save_name == "":
		push_warning("Save name cannot be empty!")
		return
	var path = "user://SaveDeck/" + save_name + ".json"
	print("Saving deck to:", path)
	save_manager.save_deck(player_deck, path)
	
func _on_load_pressed():
	load_deck.popup_centered()

func _on_load_file_selected(path: String):
	player_deck = save_manager.load_deck(path)
	update_deck_list()

func ensure_save_dir():
	if not DirAccess.dir_exists_absolute("user://SaveDeck"):
		DirAccess.make_dir_absolute("user://SaveDeck")