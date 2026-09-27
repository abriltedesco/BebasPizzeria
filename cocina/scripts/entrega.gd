extends Estaciones
class_name entrega
signal pizza_entregada(total: int)
var pizzasEntregadas= 0
func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item=="pizzaplato":
		jugador.soltar_item()
		pizzasEntregadas+= 1
		print("entregada, total:", pizzasEntregadas)
		pizza_entregada.emit(pizzasEntregadas)
