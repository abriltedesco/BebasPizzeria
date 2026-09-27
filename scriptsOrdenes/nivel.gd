extends Node2D
@onready var cliente = $Cliente
@onready var clienteMov = $Cliente/movimientoCliente
@onready var orden = $Control
var entregaNodo:Node= null

func _ready():
	orden.visible = false
	entregaNodo= get_tree().get_first_node_in_group("entrega")
	if entregaNodo== null:
		print("no hay entrega para el cliente aun")
	generarPedido()

func generarPedido():
	var clientesDisp = BaseDeDatos.listaClientes
	var ordenes = BaseDeDatos.ordenesConDificultad("facil")
	
	var clienteElegido = clientesDisp.pick_random()
	var ordenElegida = ordenes.pick_random()
	
	cliente.inicializarDatos(clienteElegido, ordenElegida)
	await clienteMov.movimiento_terminado
	
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escenaGlobo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escenaGlobo)
	escenaGlobo.start(dialogo, "start", [self])
	await escenaGlobo.tree_exited
	
	orden.visible = true
	orden.actualizarOrden()
	await orden.textoListo
	var entregaExitosa:bool=false
	if entregaNodo:
		entregaExitosa=await entregaNodo.pedido_resuelto
	clienteMov.irse()
	await clienteMov.salida_terminada
	generarPedido()
