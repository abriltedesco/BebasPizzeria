extends Node2D

@export var datos_cliente = {}
@export var datos_orden = {}

func inicializarDatos(datosCliente, datosOrden):
	ClienteActual.nombre = datosCliente["nombre"]
	ClienteActual.pizza = datosOrden["tipo"]
	ClienteActual.listaOrden = datosOrden["ingredientes"]
