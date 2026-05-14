extends Control # Sesuaikan dengan tipe Node-mu (misal: HBoxContainer)
class_name HandUI

const CHAR_CARD_SCENE = preload("res://scenes/CharacterCard.tscn")

func _ready() -> void:
    # Langsung sambungkan ke SignalBus secara global!
    SignalBus.card_drawn.connect(_on_card_drawn)
    SignalBus.card_removed_from_hand.connect(_on_card_removed)
    SignalBus.card_added_to_hand.connect(_on_card_drawn)


# ==========================================
# FUNGSI RESPONS VISUAL
# ==========================================
func _on_card_drawn(card_data: CardData) -> void:
    var card_visual = CHAR_CARD_SCENE.instantiate()
    card_visual.card_data = card_data
    add_child(card_visual)

func _on_card_removed(card_data: CardData) -> void:
    for child in get_children():
        if child.get("card_data") == card_data:
            child.queue_free()
            break