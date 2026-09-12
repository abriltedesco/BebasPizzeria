extends Node2D

func inicializarDatos(datosCliente, datosOrden):
	print("soy ", datosCliente["nombre"], " y quiero una pizza de ", datosOrden["tipo"], " que tenga: ", datosOrden["ingredientes"])
