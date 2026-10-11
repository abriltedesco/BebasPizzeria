extends Node2D

@onready var cliente= $Cliente
@onready var clienteMov= $Cliente/movimientoCliente
@onready var orden= $Control
@onready var ruta_cliente= $RutaCliente

@export var tipo_pedido= "queso"

var atendiendo= false

func _ready() -> void:
	orden.visible= false
	cliente.visible= false
	clienteMov.configurar_ruta(ruta_cliente)
	
func _process(_delta: float) -> void:
	if is_visible_in_tree() and PedidoManager.cliente_esperando and !atendiendo:
		generar_pedido()

func generar_pedido() -> void:
	atendiendo = true
	
	if get_parent().has_method("mostrar_aviso_cliente"):
		get_parent().mostrar_aviso_cliente()
		
	var clienteElegido = BaseDeDatos.listaClientes.pick_random()
	var ordenesPermitidas = []
	
	match ProgresoManager.nivel_actual:
		1:
			for orden in BaseDeDatos.listaOrdenes:
				if orden["tipo"] == "queso":
					ordenesPermitidas.append(orden)
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
	
	cliente.inicializarDatos(clienteElegido, ordenElegida)
	cliente.visible = true
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado
	
	if PedidoManager.partida_finalizada:
		cliente.visible = false
		atendiendo= false
		return
		
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, "start", [self])
	await escena_globo.tree_exited
	
	PedidoManager.tomar_pedido(clienteElegido["nombre"], ordenElegida)
	var resultado_pedido=await PedidoManager.pedido_resuelto
	var exito_pedido:bool=resultado_pedido[0]
	var motivo_pedido: String=resultado_pedido[1]
	while !is_visible_in_tree() and !PedidoManager.partida_finalizada:
		await get_tree().process_frame
	if !PedidoManager.partida_finalizada:
		ClienteActual.respuesta=BaseDeDatos.obtenerRespuestaCliente(exito_pedido, motivo_pedido)
		var titulo_respuesta="respuesta_exito" if exito_pedido else "respuesta_fallo"
		var escena_globo_respuesta=load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
		add_child(escena_globo_respuesta)
		escena_globo_respuesta.start(dialogo, titulo_respuesta, [self])
		await escena_globo_respuesta.tree_exited
	
	clienteMov.irse()
	await clienteMov.salida_terminada
	cliente.visible = false
	atendiendo = false
