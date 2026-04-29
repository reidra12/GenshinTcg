extends RefCounted


func apply_effects(battle_manager: BattleManager, _card_node: Node, card_data: CardData) -> void:
	print("Drawing ", card_data.draw_ammount, " cards")

	for i in range(card_data.draw_ammount):
		battle_manager.draw_card(1)
