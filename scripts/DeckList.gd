extends Control
class_name DeckList


@onready var deck_container: GridContainer = $DeckContainer



func _ready() -> void:
	clear_container()

func set_deck_data(deck: Array[CardData]) -> void :
	clear_container()
	for card in deck:
		create_card_visual(card)

func clear_container():
	for child in deck_container.get_children():
		child.queue_free()

# Fungsi bantuan untuk membuat UI kartu secara dinamis
func create_card_visual(card: CardData) -> void:
	# 1. Membuat node BoxContainer
	var box = BoxContainer.new()
	box.custom_minimum_size = Vector2(88, 150) # Sesuai dengan settinganmu

	# 2. Membuat node TextureRect untuk gambarnya
	var texture_rect = TextureRect.new()
	texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE

	# --- BAGIAN YANG DIPERBAIKI ---
	# Karena berada di dalam Container, kita gunakan Size Flags
	# agar gambar otomatis melar/memenuhi ukuran BoxContainer-nya.
	texture_rect.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	texture_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	# ------------------------------

	# Menentukan gambar kartu
	if "card_texture" in card and card.get("card_texture") != null:
		texture_rect.texture = card.card_texture
	elif "texture" in card and card.get("texture") != null:
		texture_rect.texture = card.texture

	# 3. Merangkai struktur nodenya
	box.add_child(texture_rect)         # Masukkan TextureRect ke dalam BoxContainer
	deck_container.add_child(box)       # Masukkan BoxContainer ke dalam GridContainer
