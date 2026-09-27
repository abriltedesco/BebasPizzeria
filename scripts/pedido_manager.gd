extends Node

signal pedido_cambiado
signal cliente_esperando_cambiado
signal tiempo_agotado

var partida_iniciada= false
var partida_finalizada= false
var pedido_activo= false
var cliente_esperando= true

func iniciar_partida() -> void:
	if partida_iniciada:
		return
	partida_iniciada= true

func tomar_pedido(nombre_cliente: String, orden: Dictionary) -> bool:
	if partida_finalizada or pedido_activo or not cliente_esperando:
		return false

	ClienteActual.nombre= nombre_cliente
	ClienteActual.pizza= orden["tipo"]
	ClienteActual.dificultad= orden["dificultad"]
	ClienteActual.listaOrden= orden["ingredientes"].duplicate()
	ClienteActual.reiniciarIndice()
	
	pedido_activo= true
	cliente_esperando= false
	pedido_cambiado.emit()
	cliente_esperando_cambiado.emit()
	return true

func completar_pedido() -> void:
	if not pedido_activo or partida_finalizada:
		return
	pedido_activo= false
	pedido_cambiado.emit()
	esperar_nuevo_cliente()

func esperar_nuevo_cliente() -> void:
	await get_tree().create_timer(3.0).timeout
	if partida_finalizada or pedido_activo:
		return
	cliente_esperando= true
	cliente_esperando_cambiado.emit()

func finalizar_partida() -> void:
	if partida_finalizada:
		return
	partida_finalizada= true
	pedido_activo= false
	cliente_esperando= false
	pedido_cambiado.emit()
	cliente_esperando_cambiado.emit()
	tiempo_agotado.emit()
