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
	
	# Remove the card visual from hand
	var card_visual_to_remove = null
	for child in hand_container.get_children():
		if child.get("card_data") == card_data:
			card_visual_to_remove = child
			break
	if is_instance_valid(card_visual_to_remove):
		card_visual_to_remove.queue_free()
		hand_container.remove_child(card_visual_to_remove)
	
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
		var card_data = hand_pile[0]
		
		# Cari node visual yang memegang data kartu yang mau dibuang
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
	var card_effects = card_data.effects
	# Pastikan efeknya tidak null
	if card_data.effects != null:
		for effect in card_effects:
			if effect is Script:
				var effect_instance = effect.new()
				if effect_instance.has_method("apply_effects"):
					effect_instance.apply_effects(self, card_node, card_data)
				else:
					push_error("Effects class does not have apply_effects method.")
			else:
				push_error("Effect is not a valid Script.")

	# Setelah efek diterapkan, pindahkan kartu ke discard
	hand_pile.erase(card_data)
	discard_pile.append(card_data)

	if is_instance_valid(card_node):
		card_node.queue_free()

func _on_card_played(card_data: CardData, card_node: Node):
	play_card_effects(card_node, card_data)

func shuffle_card(card_data: CardData):
	print("Shuffling card back into deck: ", card_data.card_name)
	hand_pile.erase(card_data)
	deck_pile.append(card_data)
	deck_pile.shuffle()
	
	var card_visual_to_remove = null
	for child in hand_container.get_children():
		if child.get("card_data") == card_data:
			card_visual_to_remove = child
			break
	if is_instance_valid(card_visual_to_remove):
		card_visual_to_remove.queue_free()
		hand_container.remove_child(card_visual_to_remove)


func mill_card(card_data: CardData):
	print("Milling card from deck: ", card_data.card_name)
	deck_pile.shuffle()
	if deck_pile.has(card_data):
		deck_pile.erase(card_data)
		discard_pile.append(card_data)
	else:
		print("Card not found in deck to mill: ", card_data.card_name)