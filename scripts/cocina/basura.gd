extends Estaciones
class_name basura

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item!= "":
		$TachoAbierto.visible = true
		jugador.soltar_item()
		await get_tree().create_timer(0.5).timeout
		$TachoAbierto.visible = false
