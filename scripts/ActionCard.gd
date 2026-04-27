extends Node

@export var card_data: CardData

signal card_played(card_data: CardData, card_node: Node)

func _ready():
	if card_data :
			$Control/CardImg.texture = card_data.artwork
			$Control/Cost/HBoxContainer/TextureRect.texture = card_data.cost_logo
			$Control/CardFrame.texture = card_data.card_frame
			$Control/Cost/CostText.text = str(card_data.card_cost)

func _on_ui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		card_played.emit(card_data, self)

	
