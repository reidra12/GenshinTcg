extends Node

@export var card_data: CardData


func _ready():
	if card_data:
		$Control/CardImg.texture = card_data.artwork
		$Control/CardFrame.texture = card_data.card_frame
		$Control/Health/HealthText.text = str(card_data.health)
		$Control/Health/HBoxContainer/TextureRect.texture = card_data.health_logo
	

func _on_click_detector_pressed() -> void:
	print("Card played: ", card_data.card_name if card_data else "No data")
	SignalBus.global_card_clicked.emit(self, card_data)
