extends Node
@export var card_data: CardData

func _ready():
	if card_data:
		$Control/DeckImg.texture = card_data.artwork
		$Control/DeckName.texture = card_data.deck_name
