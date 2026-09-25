extends Estaciones
class_name basura

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item!= "":
		jugador.soltar_item()
