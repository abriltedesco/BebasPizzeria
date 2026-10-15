extends Estaciones
class_name entrega

signal pizza_entregada(total: int)
signal pedido_resuelto(exito: bool)

var pizzasEntregadas = 0
var pizzasFallidas = 0

func _ready() -> void:
	super._ready()
	add_to_group("entrega")

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item != "pizzaplato" or PedidoManager.pedidos_activos.is_empty():
		return
		
	var tipo_entregado: String = jugador.mano_item_tipo
	var ingredientes_pizzaplato: Array = []
	if "mano_item_ingredientes" in jugador:
		ingredientes_pizzaplato = jugador.mano_item_ingredientes.duplicate()
	
	jugador.soltar_item()
	
	if PedidoManager.secuencial:
		if tipo_entregado.begins_with("quemada:") or tipo_entregado.begins_with("sincocinar:"):
			pizzasFallidas += 1
			Puntaje.sumarPedidoFallido()
			print("orden incorrecta: la pizza no estaba lista correctamente.")
			pedido_resuelto.emit(false)
			PedidoManager.completar_pedido(0, false, "quemada")
			return
			
		var indice_cliente = -1
		for i in range(PedidoManager.pedidos_activos.size()):
			if tipo_entregado == PedidoManager.pedidos_activos[i]["pizza"]:
				indice_cliente = i
				break

		if indice_cliente != -1:
			var dif = PedidoManager.pedidos_activos[indice_cliente].get("dificultad", "facil")
			Puntaje.sumarPedidoCompletado(dif)
			print("orden entregada correctamente")
			pizza_entregada.emit(pizzasEntregadas)
			pedido_resuelto.emit(true)
			PedidoManager.completar_pedido(indice_cliente, true, "exito")
		else:
			pizzasFallidas += 1
			Puntaje.sumarPedidoFallido()
			print("ingredientes no coinciden con el pedido.")
			pedido_resuelto.emit(false)
			PedidoManager.completar_pedido(0, false, "ingredientes_incorrectos")
	else:
		var datos_pizza = {
			"tipo": tipo_entregado,
			"ingredientes": ingredientes_pizzaplato
		}
		
		PedidoManager.guardar_pizza_preparada(datos_pizza)
		print("lista en estacion")
