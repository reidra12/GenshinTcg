extends RefCounted

func apply_effects(battle_manager: BattleManager, _card_node: Node, card_data: CardData) -> void:
    print("Shuffling card back into deck.")
    
    var available_cards = battle_manager.hand_pile.duplicate()
    available_cards.erase(card_data)
    
    for card in range(min(card_data.shuffle_ammount, available_cards.size())):
        available_cards.shuffle()
        var card_to_shuffle = available_cards.pop_front()
        battle_manager.shuffle_card(card_to_shuffle)
        