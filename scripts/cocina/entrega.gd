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
	if jugador.mano_item!= "pizzaplato" or PedidoManager.pedidos_activos.is_empty():
		return

	var tipo_entregado: String= jugador.mano_item_tipo
	jugador.soltar_item()
	
	if tipo_entregado.begins_with("quemada:") or tipo_entregado.begins_with("sincocinar:"):
		pizzasFallidas+= 1
		Puntaje.sumarPedidoFallido()
		print("Orden incorrecta: la pizza no estaba lista correctamente.")
		pedido_resuelto.emit(false)
		PedidoManager.completar_pedido(0, false)
		return
		
	# buscamos a quién le pertenece esta pizza exacta dentro de los pedidos activos
	var indice_cliente=-1
	for i in range(PedidoManager.pedidos_activos.size()):
		if tipo_entregado ==PedidoManager.pedidos_activos[i]["pizza"]:
			indice_cliente = i
			break

	if indice_cliente != -1:
		# pertenece a alguien de la lista
		pizzasEntregadas+= 1
		Puntaje.sumarPedidoCompletado(ClienteActual.dificultad)
		print("Orden entregada correctamente.")
		pizza_entregada.emit(pizzasEntregadas)
		pedido_resuelto.emit(true)
		PedidoManager.completar_pedido(indice_cliente, true)
	else:
		# perfecta pero no había sido pedida
		pizzasFallidas+= 1
		Puntaje.sumarPedidoFallido()
		print("los ingredientes no coinciden con el pedido.")
		pedido_resuelto.emit(false)
		PedidoManager.completar_pedido(0, false)
