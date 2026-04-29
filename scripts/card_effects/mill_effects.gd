extends RefCounted

func apply_effects(battle_manager: BattleManager, _card_node: Node, card_data: CardData) -> void:
    print("milling card from deck: ", card_data.card_name)
    
    var available_cards = battle_manager.deck_pile.duplicate()
    # Filter out the card that just cast this effect (not erase, which uses value matching)
    available_cards = available_cards.filter(func(c): return c != card_data)

    if available_cards.size() > 0:
        available_cards.shuffle()
        for cards in range(min(card_data.mill_ammount, available_cards.size())):
            var card_to_mill = available_cards.pop_front()
            battle_manager.mill_card(card_to_mill)
    else:
        print("No cards available to mill")