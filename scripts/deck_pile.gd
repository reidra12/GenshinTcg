extends Control
class_name DeckPile

const DECK_LIST_SCENE = preload("res://scenes/deck_list.tscn")

# 1. TAMBAHKAN INI: Agar kita bisa menyambungkannya di Editor
@export var battle_manager: BattleManager

var deck_list_instance: Control = null

func show_deck_list() -> void:
    # Cek dulu apakah battle_manager sudah dihubungkan
    if battle_manager == null:
        push_warning("BattleManager belum dihubungkan ke DeckPile!")
        return

    deck_list_instance = DECK_LIST_SCENE.instantiate()
    
    # MASUKKAN KE LAYAR TERLEBIH DAHULU
    get_tree().root.add_child(deck_list_instance)
    
    # SETELAH ITU BARU KIRIM DATANYA
    if deck_list_instance.has_method("set_deck_data"):
        # 2. AMBIL DARI BATTLE MANAGER YANG AKTIF
        var display_deck = battle_manager.deck_pile.duplicate()
        
        # Urutkan berdasarkan nama (Pastikan CardData punya variabel 'card_name')
        display_deck.sort_custom(func(a, b): return a.card_name < b.card_name)
        
        deck_list_instance.set_deck_data(display_deck)


func _on_click_detector_pressed() -> void:
    if deck_list_instance != null and is_instance_valid(deck_list_instance):
        deck_list_instance.queue_free()
        deck_list_instance = null
    else:
        show_deck_list()