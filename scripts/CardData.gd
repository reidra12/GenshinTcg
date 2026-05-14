extends Resource
class_name CardData

@export var card_name: String
@export var description: String
@export var card_type: String
@export var health: int
@export var card_cost: int
@export var cost_logo: Texture2D
@export var health_logo: Texture2D
@export var card_frame: Texture2D
@export var artwork: Texture2D

@export_group("Effects")
@export var effects: Array[Script] = []
@export var discard_ammount: int = 0
@export var shuffle_ammount: int = 0
@export var draw_ammount: int = 0
@export var damage_ammount: int = 0
@export var heal_ammount: int = 0
@export var search_ammount: int = 0
@export var mill_ammount: int = 0
@export var card_to_mill: String = ""
@export var card_to_search: String = ""
