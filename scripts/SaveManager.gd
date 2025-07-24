extends Node
class_name SaveManager

var all_cards: Dictionary = {}

func load_all_cards():
	var dir = DirAccess.open("res://Data/")
	if dir:
		for file_name in dir.get_files():
			if file_name.ends_with(".tres"):
				var card = load("res://Data/" + file_name)
				if card:
					all_cards[card.card_name] = card
				else:
					push_warning("Failed to load card: " + file_name)

func save_deck(deck: Deck, file_path: String):
	var dir_path = file_path.get_base_dir()
	if not DirAccess.dir_exists_absolute(dir_path):
		DirAccess.make_dir_recursive_absolute(dir_path)

	var card_names = deck.cards.map(func(c): return c.card_name)
	var json = JSON.stringify(card_names)
	print("Saving deck data:", json)

	var file = FileAccess.open(file_path, FileAccess.WRITE)
	file.store_string(json)
	file.close()

	print("Deck saved to:", file_path)


func load_deck(file_path: String) -> Deck:
	var file := FileAccess.open(file_path, FileAccess.READ)
	if FileAccess.get_open_error() != OK:
		push_error("Failed to open deck file.")
		return Deck.new()

	var content = file.get_as_text()
	var result = JSON.parse_string(content)
	var deck = Deck.new()

	if result is Array:
		for card_name in result:
			if all_cards.has(card_name):
				deck.add_card(all_cards[card_name])
			else:
				push_warning("Card not found: " + card_name)
	return deck
