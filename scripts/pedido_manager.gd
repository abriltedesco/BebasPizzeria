extends Node

signal pedido_cambiado
signal cliente_esperando_cambiado
signal tiempo_agotado
signal nivel_completado

var partida_iniciada = false
var partida_finalizada = false
var cliente_esperando = true

var secuencial = true
var max_clientes_nivel = 2
var clientes_generados = 0
var pedidos_activos = []
var max_simultaneos = 1

@export var duracion_pedido: float = 60.0

func _process(delta: float) -> void:
	if !partida_iniciada or partida_finalizada:
		return
	for pedido in pedidos_activos:
		pedido["tiempo_transcurrido"] = minf(pedido["tiempo_transcurrido"] + delta, pedido["duracion"])

func configurar_nivel(esSecuencial: bool, cantLimite: int, totalClientes: int) -> void:
	secuencial = esSecuencial
	max_simultaneos = cantLimite
	max_clientes_nivel = totalClientes
	clientes_generados = 0
	pedidos_activos.clear()
	partida_iniciada = true
	partida_finalizada = false
	cliente_esperando = true

func tomar_pedido(nombre_cliente: String, orden: Dictionary) -> bool:
	if partida_finalizada or !cliente_esperando or pedidos_activos.size() >= max_simultaneos:
		return false

	var nuevo_pedido = {
		"nombre": nombre_cliente,
		"pizza": orden["tipo"],
		"listaOrden": orden["ingredientes"].duplicate(),
		"tiempo_transcurrido": 0.0,
		"duracion": maxf(duracion_pedido, 0.1),
		"desplegado": false
	}
	
	pedidos_activos.append(nuevo_pedido)
	clientes_generados += 1
	cliente_esperando = false
	
	pedido_cambiado.emit()
	cliente_esperando_cambiado.emit()
	
	if !secuencial and clientes_generados < max_clientes_nivel: # si el nivel permite pedidos simultáneos y faltan clientes, 
		esperar_nuevo_cliente()  # el timer del prox cliente arranca inmediatamente mientras haces esta pizza
		
	return true

func completar_pedido(indice_pedido: int = 0) -> void:
	if pedidos_activos.is_empty() or partida_finalizada:
		return
		
	pedidos_activos.remove_at(indice_pedido)
	pedido_cambiado.emit()
	
	if secuencial and clientes_generados < max_clientes_nivel:
		esperar_nuevo_cliente()
	elif clientes_generados >= max_clientes_nivel and pedidos_activos.is_empty():
		nivel_completado.emit()

func esperar_nuevo_cliente() -> void:
	await get_tree().create_timer(3.0).timeout
	if partida_finalizada:
		return
	cliente_esperando = true
	cliente_esperando_cambiado.emit()
	
func finalizar_partida() -> void:
	if partida_finalizada:
		return
	partida_finalizada = true
	pedidos_activos.clear()
	cliente_esperando = false
	pedido_cambiado.emit()
	cliente_esperando_cambiado.emit()
	tiempo_agotado.emit()
