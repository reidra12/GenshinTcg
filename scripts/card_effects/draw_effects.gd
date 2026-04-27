extends RefCounted

var draw_ammount: int = 1

func apply_effects(battle_manager: BattleManager) -> void:
    print("draw_card")

    for i in range(draw_ammount):
        battle_manager.draw_card(1)
