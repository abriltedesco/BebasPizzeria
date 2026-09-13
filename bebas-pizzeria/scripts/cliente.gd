extends Node2D

@export var datos_cliente = {}
@export var datos_orden = {}

func inicializarDatos(datosCliente, datosOrden):
	datos_cliente = datosCliente
	datos_orden = datosOrden
	print("soy ", datosCliente["nombre"], " y quiero una pizza de ", 
	datosOrden["tipo"], " que tenga: ", datosOrden["ingredientes"])
	
