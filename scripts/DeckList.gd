extends Control
class_name DeckList

const CHAR_CARD_SCENE = preload("res://scenes/CharacterCard.tscn")

@onready var deck_container: GridContainer = $DeckContainer

func _ready() -> void:
	clear_container()
	
	# Menyambungkan sinyal dari SignalBus ke fungsi yang ada di bawah
	SignalBus.card_added_to_deck.connect(_on_card_added_to_deck)
	SignalBus.card_removed_from_deck.connect(_on_card_removed_from_deck)

func set_deck_data(deck: Array[CardData]) -> void :
	clear_container()
	for card in deck:
		create_card_visual(card)

func clear_container():
	for child in deck_container.get_children():
		child.queue_free()

# Fungsi bantuan untuk membuat UI kartu secara dinamis
func create_card_visual(card_data: CardData) -> void:
	var card_visual = CHAR_CARD_SCENE.instantiate()
	
	# Catatan: Pastikan variabel di CharacterCard bernama 'card'.
	# Jika sebelumnya bernama 'card_data', ubah menjadi card_visual.card_data = card
	card_visual.card_data = card_data
	
	deck_container.add_child(card_visual)

# =======================================================
# FUNGSI BARU YANG DITAMBAHKAN UNTUK MEMPERBAIKI ERROR
# =======================================================

# Fungsi ini akan dipanggil otomatis saat sinyal card_added_to_deck berteriak
func _on_card_added_to_deck(card_data: CardData) -> void:
	# Langsung buatkan visual kartunya di layar
	create_card_visual(card_data)

# Fungsi ini akan dipanggil otomatis saat sinyal card_removed_from_deck berteriak
func _on_card_removed_from_deck(card_data: CardData) -> void:
	# Cari kartu yang sesuai di dalam container, lalu hapus dari layar
	for child in deck_container.get_children():
		# Kita menggunakan .get() agar aman dari error jika node tidak punya variabel tersebut
		if child.get("card") == card_data or child.get("card_data") == card_data:
			child.queue_free()
			break # Berhenti mencari jika sudah ketemu dan dihapus
