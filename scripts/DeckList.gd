extends Control

# Targetkan GridContainer milikmu
@onready var deck_container = $DeckContainer

var battle_managaer = BattleManager.new()



func _ready():
	# (Opsional) Kamu bisa menghapus placeholder bawaan saat scene dimuat
	# Tapi kita akan menghapusnya di set_deck_data juga agar aman
	pass

# Fungsi ini dipanggil oleh deck_pile saat di-klik
func set_deck_data(card_data: Array[CardData]) -> void:
	# 1. Bersihkan semua isi DeckContainer (termasuk placeholder "IndividualDeck" milikmu)
	for child in deck_container.get_children():
		child.queue_free()
    
		
	# 2. Bangun ulang visual kartu berdasarkan data deck
	for data in card_data:
		# Buat wadah BoxContainer seperti "IndividualDeck" mu
		var card_box = BoxContainer.new()
		card_box.custom_minimum_size = Vector2(88, 150)
		
		# Buat gambar kartu seperti "TextureRect" mu
		var card_img = TextureRect.new()
		card_img.expand_mode = TextureRect.EXPAND_IGNORE_SIZE # Setara dengan expand_mode = 3 di scene
		
		# Isi gambarnya dengan artwork dari data kartu
		if data and data.artwork:
			card_img.texture = data.artwork
			
		# Atur agar gambarnya memenuhi kotak
		card_img.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		card_img.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		# Masukkan gambar ke dalam kotak
		card_box.add_child(card_img)
		
		# Masukkan kotak ke dalam GridContainer UI
		deck_container.add_child(card_box)

# Opsional: Jika kamu ingin bisa menutup menu ini dengan klik layar gelap (TextureRect/ColorRect)
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Tutup UI jika pemain mengklik di luar area kartu
		# Karena ini script basic, kita bisa letakkan tombol close atau biarkan deck_pile 
		# yang mengurus buka-tutup (toggle) nya seperti yang sudah kamu buat.
		pass
