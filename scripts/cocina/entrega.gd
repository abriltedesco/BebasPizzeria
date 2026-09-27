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
	if jugador.mano_item!= "pizzaplato" or not PedidoManager.pedido_activo:
		return

	var tipo_entregado: String= jugador.mano_item_tipo
	jugador.soltar_item()
	
	if tipo_entregado.begins_with("quemada:") or tipo_entregado.begins_with("sincocinar:"):
		pizzasFallidas += 1
		Puntaje.sumarPedidoFallido()
		pedido_resuelto.emit(false)
		PedidoManager.completar_pedido()
	elif tipo_entregado== ClienteActual.pizza:
		pizzasEntregadas+= 1
		Puntaje.sumarPedidoCompletado(ClienteActual.dificultad)
		pizza_entregada.emit(pizzasEntregadas)
		pedido_resuelto.emit(true)
		PedidoManager.completar_pedido()
	else:
		pizzasFallidas+= 1
		Puntaje.sumarPedidoFallido()
		pedido_resuelto.emit(false)
		PedidoManager.completar_pedido()
