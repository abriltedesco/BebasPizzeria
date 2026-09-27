extends CharacterBody2D

@export var datos_cliente={}
@export var datos_orden={}

func inicializarDatos(datosCliente, datosOrden):
	ClienteActual.nombre=datosCliente["nombre"]
	ClienteActual.pizza=datosOrden["tipo"]
	ClienteActual.dificultad=datosOrden["dificultad"]
	ClienteActual.listaOrden=datosOrden["ingredientes"]
	ClienteActual.reiniciarIndice()
	ClienteActual.listaOrden=datosOrden["ingredientes"]
