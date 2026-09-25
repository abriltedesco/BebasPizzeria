extends Estaciones
class_name entrega

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "plato" or jugador.mano_item == "pizzahecha" or jugador.plato_en_mano:
		jugador.soltar_item()
