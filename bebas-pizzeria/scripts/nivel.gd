extends Node2D
@onready var cliente = $Cliente

func _ready():
	generarPedido()

func generarPedido():
	var clientesDisp = BaseDeDatos.listaClientes
	var ordenes = BaseDeDatos.ordenesConDificultad("facil")
	
	var clienteElegido = clientesDisp.pick_random()
	var ordenElegida = ordenes.pick_random()
	
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escenaGlobo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escenaGlobo)
	escenaGlobo.start(dialogo, "start", [self])
	#await escenaGlobo.dialogue_ended
	
	cliente.inicializarDatos(clienteElegido, ordenElegida)
	
	print("llego ", clienteElegido["nombre"], " y pidió ", ordenElegida["tipo"])
