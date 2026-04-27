extends Node
class_name BattleManager

const CHAR_CARD_SCENE = preload("res://scenes/CharacterCard.tscn")

@onready var hand_container = get_parent().get_node("hand") as Node
@onready var save_manager = SaveManager.new()

var deck_pile : Array[CardData] = []
var hand_pile : Array[CardData] = [] 
var discard_pile : Array[CardData] = [] 

func _ready() -> void:
	save_manager.load_all_cards()
	
	# Memuat deck
	var load_deck = save_manager.load_deck("res://SaveDeck/test_save.json")
	deck_pile = load_deck.cards
	deck_pile.shuffle()
	
	# Gunakan .size() untuk menampilkan angka jumlah kartu, bukan menampilkan objeknya
	print("Deck loaded with: ", deck_pile.size(), " cards.") 
	
	# Langsung panggil draw_card untuk 5 kartu. 
	# Semua logika pembuatan kartu sudah dipindah ke dalam draw_card
	draw_card(5) 
	print("Initial hand size: ", hand_pile.size())

func draw_card(count : int):
	for i in range(count):
		if deck_pile.is_empty():
			reshuffle_discard()
			if deck_pile.is_empty(): 
				print("Deck benar-benar habis!")
				return
		
		# 1. Pindahkan data dari deck ke tangan
		var card_data = deck_pile.pop_back()
		hand_pile.append(card_data)

		# 2. Buat visual kartunya di layar
		var card_visual = CHAR_CARD_SCENE.instantiate()
		card_visual.card_data = card_data
		card_visual.card_played.connect(_on_card_played)
		hand_container.add_child(card_visual)
	
func discard_card(_card_node: Node, card_data: CardData):
	print("Discarding card: ", card_data.card_name)
	hand_pile.erase(card_data)
	discard_pile.append(card_data)
	
	# Hanya hapus SATU kartu visual ini
	if is_instance_valid(_card_node):
		_card_node.queue_free()
	
func reshuffle_discard():
	print("Reshuffling discard pile into deck.")
	deck_pile = discard_pile.duplicate()
	deck_pile.shuffle()
	discard_pile.clear()

# Fungsi untuk tombol UI
func _on_draw_pressed() -> void:
	draw_card(1)

func _on_discard_pressed() -> void:
	if hand_pile.size() > 0:
		# Kita ambil data kartu paling kiri (pertama) di tangan
		var card_data = hand_pile[0]
		
		# Kita perlu mencari node visual yang menempel di UI untuk kartu ini
		var visual_node_to_remove = null
		for child in hand_container.get_children():
			# Cek apakah node visual ini memegang data kartu yang mau kita buang
			if child.get("card_data") == card_data:
				visual_node_to_remove = child
				break # Ketemu, hentikan pencarian
		
		# Eksekusi pembuangan
		discard_card(visual_node_to_remove, card_data)

func play_card_effects(card_node: Node, card_data: CardData):
	print("Applying effects of card: ", card_data.card_name)
	if card_data.effects != null:
		var effects_instance = card_data.effects.new()
		if effects_instance.has_method("apply_effects"):
			effects_instance.apply_effects(self)
		else:
			push_error("Effects class does not have apply_effects method.")
	
	hand_pile.erase(card_data)
	discard_pile.append(card_data)
	if is_instance_valid(card_node):
		card_node.queue_free()

func _on_card_played(card_data: CardData, card_node: Node):
	play_card_effects(card_node, card_data)
