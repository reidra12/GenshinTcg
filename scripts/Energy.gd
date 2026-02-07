extends Control

@onready var full_energy = $FullEnergy
@onready var empty_energy = $EmptyEnergy

func hide_energy():
	var energy_visibility = !full_energy.visible
	full_energy.visible = energy_visibility
