extends Node

@export var card_data: CardData

func _ready():
	if card_data :
			$Control/CardImg.texture = card_data.artwork
			$Control/Cost/CostText.text = str(card_data.health)
			$Control/Cost/HBoxContainer/TextureRect.texture = card_data.cost_logo
			
		
