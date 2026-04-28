extends RefCounted

@export var draw_ammount: int = 1

func apply_effects(battle_manager: BattleManager, _card_node: Node, _card_data: CardData) -> void:
    print("draw_card")

    for i in range(draw_ammount):
        battle_manager.draw_card(1)
