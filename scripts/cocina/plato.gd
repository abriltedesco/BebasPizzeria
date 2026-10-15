extends Ingredientes
class_name plato

func obtener_item() -> String:
	return "plato"

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "pizzahecha":
		
		var ingredientes_guardados = []
		if "mano_item_ingredientes" in jugador:
			print("[PLATO] ingredientes al armar: ", jugador.mano_item_ingredientes if "mano_item_ingredientes" in jugador else "NO EXISTE")
			ingredientes_guardados = jugador.mano_item_ingredientes.duplicate()
		
		jugador.agarrar_item("pizzaplato", jugador.mano_item_tipo)
		
		if "mano_item_ingredientes" in jugador:
			jugador.mano_item_ingredientes = ingredientes_guardados
	else:
		super.interactuar(jugador)
