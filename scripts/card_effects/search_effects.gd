extends RefCounted


func apply_effects(battle_manager: BattleManager, _card_node: Node, card_data: CardData) -> void:
	print("searching ", card_data.card_to_search)
	
	var available_cards = battle_manager.deck_pile.duplicate()
	available_cards = available_cards.filter(func(c): return c != card_data)

	if available_cards.size() > 0:
		var found_card = null
		for card in available_cards:
			if card.card_name == card_data.card_to_search:
				found_card = card
				print("Found card: ", found_card.card_name)
				break
		
		if found_card:
			battle_manager.search_card(found_card)
	else:
		print("No cards available to search")
