extends Node2D
@onready var cliente = $Cliente

func _ready():
	generarPedido()

func generarPedido():
	var clientesDisp = BaseDeDatos.listaClientes
	var ordenes = BaseDeDatos.ordenesConDificultad("facil")
	
	var clienteElegido = clientesDisp.pick_random()
	var ordenElegida = ordenes.pick_random()
	
	cliente.inicializarDatos(clienteElegido, ordenElegida)
	
	print("llego ", clienteElegido["nombre"], " y pidió ", ordenElegida["tipo"])
