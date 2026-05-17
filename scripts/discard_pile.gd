extends Control
class_name DiscardPile

const DISCARD_LIST_SCENE = preload("res://scenes/card_list.tscn")

# 1. TAMBAHKAN INI: Agar kita bisa menyambungkannya di Editor
@export var battle_manager: BattleManager

var discard_list_instance: Control = null

func show_deck_list() -> void:
	# Cek dulu apakah battle_manager sudah dihubungkan
	if battle_manager == null:
		push_warning("BattleManager belum dihubungkan ke DeckPile!")
		return

	discard_list_instance = DISCARD_LIST_SCENE.instantiate()
	
	# MASUKKAN KE LAYAR TERLEBIH DAHULU
	get_tree().root.add_child(discard_list_instance)
	
	# SETELAH ITU BARU KIRIM DATANYA
	if discard_list_instance.has_method("set_deck_data"):
		# 2. AMBIL DARI BATTLE MANAGER YANG AKTIF
		var display_deck = battle_manager.discard_pile.duplicate()
		
		# Urutkan berdasarkan nama (Pastikan CardData punya variabel 'card_name')
		display_deck.sort_custom(func(a, b): return a.card_name < b.card_name)
		
		discard_list_instance.set_deck_data(display_deck)


func _on_click_detector_pressed() -> void:
	if discard_list_instance != null and is_instance_valid(discard_list_instance):
		discard_list_instance.queue_free()
		discard_list_instance = null
	else:
		show_deck_list()
