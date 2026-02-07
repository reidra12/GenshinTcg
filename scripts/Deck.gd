extends Node
class_name Deck

var cards: Array[CardData] = []

func add_card(card: CardData, max_copies := 3) -> bool:
	var count = 0
	for c in cards:
		if c.resource_path == card.resource_path:
			count += 1
	if count >= max_copies:
		return false
	cards.append(card)
	return true


func remove_card(card: CardData):
	cards.erase(card)

func clear_deck():
	cards.clear()
