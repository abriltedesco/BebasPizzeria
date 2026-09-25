extends Estaciones
class_name Ingredientes

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "":
		var item := obtener_item()
		if item != "":
			jugador.agarrar_item(item)
			
func obtener_item() -> String:
	return ""
