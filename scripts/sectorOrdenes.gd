extends Node2D

@onready var orden = $Control
@onready var rutaCliente = $RutaCliente
const avisoCliente = preload("res://escenas/interfaces/avisoCliente.tscn")

@export var tipo_pedido = "queso"

var atendiendo = false
const ClienteEscena = preload("res://escenas/cliente.tscn") 
var clientes_en_fila = {} 

func _ready() -> void:
	orden.visible = false
	PedidoManager.pedido_resuelto.connect(_on_pedido_resuelto_global)
	
func _process(_delta: float) -> void:
	var condicion_spawner = is_visible_in_tree() or (!PedidoManager.secuencial and PedidoManager.cliente_esperando)
	if condicion_spawner and PedidoManager.cliente_esperando and !atendiendo:
		generar_pedido()


func generar_pedido() -> void:
	atendiendo = true
	
	if avisoCliente:
		var aviso = avisoCliente.instantiate()
		get_tree().current_scene.add_child(aviso)

	var nuevo_cliente = ClienteEscena.instantiate()
	add_child(nuevo_cliente)
	
	var clienteMov = nuevo_cliente.get_node("movimientoCliente")
	clienteMov.configurar_ruta(rutaCliente)
		
	var clienteElegido = BaseDeDatos.listaClientes.pick_random()
	var ordenesPermitidas = []
	
	match ProgresoManager.nivel_actual:
		1:
			for orden_bd in BaseDeDatos.listaOrdenes:
				if orden_bd["tipo"] == "queso":
					ordenesPermitidas.append(orden_bd)
		2:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("facil")
		3:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("media")
		4:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("dificil")
		5:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("media")
			ordenesPermitidas.append(BaseDeDatos.ordenesConDificultad("dificil"))
			
	var ordenElegida = ordenesPermitidas.pick_random()
	
	nuevo_cliente.inicializarDatos(clienteElegido, ordenElegida)
	nuevo_cliente.visible = true
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado
	
	if PedidoManager.partida_finalizada:
		nuevo_cliente.queue_free() 
		atendiendo = false
		return

	clientes_en_fila[clienteElegido["nombre"]] = nuevo_cliente
	
	if !PedidoManager.secuencial:
		var pos_espera = Vector2(600 - (clientes_en_fila.size() * 90), 370)
		var tween = create_tween()
		tween.tween_property(nuevo_cliente, "position", pos_espera, 1.0)
		atendiendo = false 
		
	while !is_visible_in_tree() and !PedidoManager.partida_finalizada:
			await get_tree().process_frame
		
	if PedidoManager.partida_finalizada:
		return
		
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, "start", [self])
	await escena_globo.tree_exited
	
	var datosTomados = PedidoManager.tomar_pedido(clienteElegido["nombre"], ordenElegida)
	var numOrden = datosTomados.get("numero_orden", 1)
	var duracion = datosTomados.get("duracion", 60.0)
	
	nuevo_cliente.activar_interfaz_orden(numOrden, duracion)
	nuevo_cliente.entregar_presionado.connect(_on_cliente_entregar_presionado)

func _on_cliente_entregar_presionado(numOrden: int) -> void:
	var idx = PedidoManager.buscar_indice_por_numero_orden(numOrden)
	if idx != -1:
		var exito = PedidoManager.validar_pizza_preparada(numOrden)
		var motivo = "exito" if exito else "pizza_incorrecta"
		PedidoManager.completar_pedido(idx, exito, motivo)

func _on_pedido_resuelto_global(exito_pedido: bool, motivo_pedido: String, nombre_cliente: String, numero_orden: int) -> void:
	if !clientes_en_fila.has(nombre_cliente):
		return 
		
	var cliente_que_recibe = clientes_en_fila[nombre_cliente]
	var clienteMov = cliente_que_recibe.get_node("movimientoCliente")
	
	if !PedidoManager.secuencial:
		while (atendiendo or !is_visible_in_tree()) and !PedidoManager.partida_finalizada:
			await get_tree().process_frame
		atendiendo = true
		
		var tween = create_tween()
		tween.tween_property(cliente_que_recibe, "position", Vector2(600, 370), 0.5)
		await tween.finished
	else:
		while !is_visible_in_tree() and !PedidoManager.partida_finalizada:
			await get_tree().process_frame
		
	if !PedidoManager.partida_finalizada:
		ClienteActual.respuesta = BaseDeDatos.obtenerRespuestaCliente(exito_pedido, motivo_pedido)
		var titulo_respuesta = "respuesta_exito" if exito_pedido else "respuesta_fallo"
		
		var dialogo = load("res://dialogue/pedido_cliente.dialogue")
		var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
		add_child(escena_globo)
		escena_globo.start(dialogo, titulo_respuesta, [self])
		await escena_globo.tree_exited
		
	clienteMov.irse()
	await clienteMov.salida_terminada
	cliente_que_recibe.queue_free()
	clientes_en_fila.erase(nombre_cliente)
	atendiendo = false
