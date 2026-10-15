extends Node

signal pedido_cambiado
signal cliente_esperando_cambiado
signal pedido_resuelto(exito: bool, motivo: String, nombre_cliente: String, numero_orden: int)
signal tiempo_agotado
signal nivel_completado

var partida_iniciada = false
var partida_finalizada = false
var cliente_esperando = true
var pedidos_correctos = 0

var secuencial = true
var max_clientes_nivel = 100
var min_entregas_nivel = 5
var clientes_generados = 0
var contador_ordenes = 0
var pedidos_activos = []
var max_simultaneos = 1
var tiempo_entre_clientes: float = 10.0

var pizza_preparada: Dictionary = {}

func _process(delta: float) -> void:
	if !partida_iniciada or partida_finalizada:
		return
	for i in range(pedidos_activos.size() - 1, -1, -1):
		var pedido = pedidos_activos[i]
		pedido["tiempo_transcurrido"] = minf(pedido["tiempo_transcurrido"] + delta, pedido["duracion"])
		if pedido["tiempo_transcurrido"] >= pedido["duracion"]:
			Puntaje.sumarPedidoFallido()
			completar_pedido(i, false, "tiempo")

func configurar_nivel(esSecuencial: bool, cantLimite: int, totalClientes: int, minEntregas: int = 5, tiempoEspera: float = 10.0) -> void:
	secuencial = esSecuencial
	max_simultaneos = cantLimite
	max_clientes_nivel = totalClientes
	min_entregas_nivel = minEntregas
	tiempo_entre_clientes = tiempoEspera
	clientes_generados = 0
	contador_ordenes = 0
	pedidos_activos.clear()
	pizza_preparada.clear()
	partida_iniciada = true
	partida_finalizada = false
	cliente_esperando = true
	pedidos_correctos = 0

func registrar_llegada() -> void:
	clientes_generados += 1

# el cliente se va enojado de la fila antes de hablar
func cliente_ignorado_se_fue() -> void:
	if clientes_generados >= max_clientes_nivel and pedidos_activos.is_empty():
		nivel_completado.emit()

func tomar_pedido(nombre_cliente: String, orden: Dictionary, duracion_total: float = 60.0, ya_transcurrido: float = 0.0) -> Dictionary:
	if partida_finalizada:
		return {}

	contador_ordenes += 1
	var nuevo_pedido = {
		"numero_orden": contador_ordenes,
		"nombre": nombre_cliente,
		"pizza": orden["tipo"],
		"listaOrden": orden["ingredientes"].duplicate(),
		"dificultad": orden.get("dificultad", "facil"),
		"tiempo_transcurrido": ya_transcurrido,
		"duracion": duracion_total,
		"desplegado": false
	}
	
	pedidos_activos.append(nuevo_pedido)
	pedido_cambiado.emit()
	return nuevo_pedido

func guardar_pizza_preparada(datos_pizza: Dictionary) -> void:
	pizza_preparada = datos_pizza.duplicate(true)

func validar_pizza_preparada(num_orden: int) -> bool:
	var idx = buscar_indice_por_numero_orden(num_orden)
	if idx == -1: return false
	var pedido = pedidos_activos[idx]
	return ValidadorPizzas.validar(pedido, pizza_preparada)

func buscar_indice_por_numero_orden(num_orden: int) -> int:
	for i in range(pedidos_activos.size()):
		if pedidos_activos[i]["numero_orden"] == num_orden:
			return i
	return -1

func completar_pedido(indice_pedido: int = 0, exito: bool = true, motivo: String = "") -> void:
	if pedidos_activos.is_empty() or partida_finalizada or indice_pedido < 0 or indice_pedido >= pedidos_activos.size():
		return
	
	var pedido = pedidos_activos[indice_pedido]
	var clienteAtendido = pedido["nombre"]
	var numOrden = pedido["numero_orden"]

	pedidos_activos.remove_at(indice_pedido)
	pedido_cambiado.emit()
	pedido_resuelto.emit(exito, motivo, clienteAtendido, numOrden) 
	
	if exito:
		pedidos_correctos += 1

	if clientes_generados >= max_clientes_nivel and pedidos_activos.is_empty():
		nivel_completado.emit()

func finalizar_partida() -> void:
	if partida_finalizada: return
	partida_finalizada = true
	pedidos_activos.clear()
	cliente_esperando = false
	pedido_cambiado.emit()
	cliente_esperando_cambiado.emit()
	tiempo_agotado.emit()
