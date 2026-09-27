extends Estaciones
class_name entrega
signal pizza_entregada(total: int)
signal pedido_resuelto(exito: bool)

var pizzasEntregadas= 0
var pizzasFallidas= 0

func _ready() -> void:
	super._ready()
	add_to_group("entrega")

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item!= "pizzaplato":
		return

	var tipo_entregado:String=jugador.mano_item_tipo
	jugador.soltar_item()
	if tipo_entregado==ClienteActual.pizza:
		pizzasEntregadas+= 1
		Puntaje.sumarPedidoCompletado(ClienteActual.dificultad)
		print("entregada correctamente(",tipo_entregado,"), total:",pizzasEntregadas)
		pizza_entregada.emit(pizzasEntregadas)
		pedido_resuelto.emit(true)
	else:
		pizzasFallidas += 1
		Puntaje.sumarPedidoFallido()
		print("pedido fallido. se entregó ",tipo_entregado, " pero se pedía ", ClienteActual.pizza)
		pedido_resuelto.emit(false)
