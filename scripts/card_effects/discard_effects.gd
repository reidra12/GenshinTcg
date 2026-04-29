extends RefCounted


func apply_effects(battle_manager: BattleManager, _card_node: Node, card_data: CardData) -> void:
    print("Discarding other cards: ", card_data.discard_ammount)
    
    # Get available cards to discard (excluding the card that was just played)
    var available_cards = battle_manager.hand_pile.duplicate()
    available_cards.erase(card_data)
    
    # Discard random cards
    for i in range(min(card_data.discard_ammount, available_cards.size())):
        available_cards.shuffle()
        var card_to_discard = available_cards.pop_front()
        battle_manager.discard_card(null, card_to_discard)
