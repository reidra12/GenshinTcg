extends Node

# Sinyal-sinyal yang sudah kamu punya sebelumnya (biarkan saja)
signal global_card_clicked(card_node: Node, card_data: CardData)
signal card_drawn(card_data: CardData)
signal card_removed_from_hand(card_data: CardData)
signal deck_updated(deck_size: int)

# ==========================================
# TAMBAHKAN DUA BARIS INI UNTUK DECK LIST
# ==========================================
signal card_added_to_deck(card_data: CardData)
signal card_removed_from_deck(card_data: CardData)
signal card_added_to_discard(card_data: CardData)
signal card_removed_from_discard(card_data: CardData)