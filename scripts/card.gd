extends Node

@export var card_data: CardData

func _ready():
	if card_data:
		$Control/CardImg.texture = card_data.artwork
		$Control/Health/HealthText.text = str(card_data.health)
		$Control/Health/HBoxContainer/TextureRect.texture = card_data.health_logo
		
		
