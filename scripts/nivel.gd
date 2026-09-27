extends Node2D

@onready var cliente= $Cliente
@onready var clienteMov= $Cliente/movimientoCliente
@onready var orden= $Control
@onready var ruta_cliente= $RutaCliente

@export var tipo_pedido= "queso"

var atendiendo_cliente= false

func _ready() -> void:
	orden.visible= false
	cliente.visible= false
	clienteMov.configurar_ruta(ruta_cliente)
	PedidoManager.iniciar_partida()

func _process(_delta: float) -> void:
	if is_visible_in_tree() and PedidoManager.cliente_esperando and not atendiendo_cliente:
		generar_pedido()

func generar_pedido() -> void:
	atendiendo_cliente= true
	var cliente_elegido= BaseDeDatos.listaClientes.pick_random()
	var orden_queso= BaseDeDatos.obtenerOrdenPorTipo(tipo_pedido)
	
	cliente.inicializarDatos(cliente_elegido, orden_queso)
	cliente.visible= true
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado

	if PedidoManager.partida_finalizada:
		cliente.visible= false
		atendiendo_cliente= false
		return

	var dialogo= load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo= load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, "start", [self])
	await escena_globo.tree_exited

	PedidoManager.tomar_pedido(cliente_elegido["nombre"], orden_queso)
	clienteMov.irse()
	await clienteMov.salida_terminada
	cliente.visible= false
	atendiendo_cliente= false
