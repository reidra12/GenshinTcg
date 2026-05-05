extends Node

@export var card_data: CardData

signal card_played(card_data: CardData, card_node: Node)	

func _ready():
	if card_data:
		$Control/CardImg.texture = card_data.artwork
		$Control/CardFrame.texture = card_data.card_frame
		$Control/Health/HealthText.text = str(card_data.health)
		$Control/Health/HBoxContainer/TextureRect.texture = card_data.health_logo

func _on_ui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("Card played: ", card_data.card_name if card_data else "No data")
		card_played.emit(card_data, self)

func _on_mouse_entered():
	print("Mouse entered card: ", card_data.card_name if card_data else "No data")

func _on_mouse_exited():
	print("Mouse exited card: ", card_data.card_name if card_data else "No data")
