extends BoxContainer
class_name DeckPile

const DECK_LIST_SCENE = preload("res://scenes/deck_list.tscn")

var deck_pile: Array[CardData] = []
var discard_pile: Array[CardData] = []
var deck_list_instance: Control = null

func _ready() -> void:
	gui_input.connect(_on_gui_input)


# --- VISUAL UI LOGIC ---
func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if deck_list_instance != null and is_instance_valid(deck_list_instance):
			deck_list_instance.queue_free()
			deck_list_instance = null
		else:
			show_deck_list()

func show_deck_list() -> void:
	deck_list_instance = DECK_LIST_SCENE.instantiate()
	
	# 1. MASUKKAN KE LAYAR TERLEBIH DAHULU (Agar @onready di DeckList menyala)
	get_tree().root.add_child(deck_list_instance)
	
	# 2. SETELAH ITU BARU KIRIM DATANYA
	if deck_list_instance.has_method("set_deck_data"):
		var display_deck = deck_pile.duplicate()
		display_deck.sort_custom(func(a, b): return a.card_name < b.card_name)
		deck_list_instance.set_deck_data(display_deck)