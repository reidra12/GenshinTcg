extends Node
class_name BattleManager

@onready var save_manager = SaveManager.new()

@export var load_deck_path : String


var deck_pile : Array[CardData] = []
var hand_pile : Array[CardData] = [] 
var discard_pile : Array[CardData] = []

func _ready() -> void:
	# Dengarkan radio global SignalBus
	SignalBus.global_card_clicked.connect(_on_global_card_clicked)
	
	save_manager.load_all_cards()
	
	var load_deck = save_manager.load_deck(load_deck_path)
	deck_pile = load_deck.cards
	deck_pile.shuffle()
	
	print("Deck loaded with: ", deck_pile.size(), " cards.") 
	# MENGGUNAKAN SIGNALBUS
	SignalBus.deck_updated.emit(deck_pile.size()) 
	
	draw_card(5) 
	print("Initial hand size: ", hand_pile.size())
	
func reshuffle_discard():
	print("Reshuffling discard pile into deck.")
	deck_pile = discard_pile.duplicate()
	deck_pile.shuffle()
	discard_pile.clear()
	# MENGGUNAKAN SIGNALBUS
	SignalBus.deck_updated.emit(deck_pile.size())

func _on_draw_pressed() -> void:
	draw_card(1)

func _on_discard_pressed() -> void:
	if hand_pile.size() > 0:
		discard_card(hand_pile[0])

func play_card_effects(card_node: Node, card_data: CardData):
	print("Applying effects of card: ", card_data.card_name)
	var card_effects = card_data.effects
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

	hand_pile.erase(card_data)
	discard_pile.append(card_data)

	# MENGGUNAKAN SIGNALBUS
	SignalBus.card_removed_from_hand.emit(card_data)

func _on_global_card_clicked(card_node: Node, card_data: CardData) -> void:
	if hand_pile.has(card_data):
		print("BattleManager Merespons: Kartu dimainkan dari Tangan!")
		play_card_effects(card_node, card_data)
	else:
		print("BattleManager Abaikan: Kartu diklik di luar area tangan.")

func shuffle_card(card_data: CardData):
	print("Shuffling card back into deck: ", card_data.card_name)
	hand_pile.erase(card_data)
	deck_pile.append(card_data)
	deck_pile.shuffle()
	# MENGGUNAKAN SIGNALBUS
	SignalBus.deck_updated.emit(deck_pile.size())
	SignalBus.card_removed_from_hand.emit(card_data)

func mill_card(card_data: CardData):
	print("Milling card from deck: ", card_data.card_name)
	deck_pile.shuffle()
	if deck_pile.has(card_data):
		deck_pile.erase(card_data)
		discard_pile.append(card_data)
		# MENGGUNAKAN SIGNALBUS
		SignalBus.deck_updated.emit(deck_pile.size())
	else:
		print("Card not found in deck to mill: ", card_data.card_name)

func draw_card(count : int):
	for i in range(count):
		if deck_pile.is_empty():
			reshuffle_discard()
			if deck_pile.is_empty(): 
				print("Deck benar-benar habis!")
				return
		
		var card_data = deck_pile.pop_back()
		hand_pile.append(card_data)
		
		SignalBus.card_drawn.emit(card_data)
		SignalBus.card_removed_from_deck.emit(card_data)
		SignalBus.deck_updated.emit(deck_pile.size())
	
func discard_card(card_data: CardData):
	print("Discarding card: ", card_data.card_name)
	hand_pile.erase(card_data)
	discard_pile.append(card_data)
	
	# MENGGUNAKAN SIGNALBUS
	SignalBus.card_removed_from_hand.emit(card_data)
	SignalBus.card_added_to_discard.emit(card_data)

func search_card(card_data: CardData):
	print("Searching for card: ", card_data.card_name)
	if deck_pile.has(card_data):
		deck_pile.erase(card_data)
		hand_pile.append(card_data)
		# MENGGUNAKAN SIGNALBUS
		SignalBus.card_added_to_hand.emit(card_data)
		SignalBus.card_removed_from_deck.emit(card_data)
	else:
		print("Card not found in deck to search: ", card_data.card_name)
	deck_pile.shuffle()
