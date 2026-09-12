extends Node

var listaClientes = [
	{"nombre": "Ana", "asset": "res://assets/"},
	{"nombre": "María", "asset": "res://assets/"},
	{"nombre": "Helena", "asset": "res://assets/"},
	{"nombre": "Daniel", "asset": "res://assets/"},
	{"nombre": "Thiago", "asset": "res://assets/"}
]

var listaOrdenes = [
	{"tipo": "Muzzarella", "dificultad": "facil", "ingredientes": ["masa", "salsa", "muzzarella"]},
	{"tipo": "Fugazzetta", "dificultad": "facil", "ingredientes": ["masa", "muzzarella", "cebolla"]},
	{"tipo": "Jamon", "dificultad": "facil", "ingredientes": ["masa", "salsa", "muzzarella", "jamon"]},
	{"tipo": "Napolitana", "dificultad": "facil", "ingredientes": ["masa", "salsa", "muzzarella", "tomate"]},
		
	{"tipo": "Calabresa", "dificultad": "media", "ingredientes": ["masa", "salsa", "muzzarella", "longaniza", "morron"]},
	{"tipo": "Rucula y crudo", "dificultad": "media", "ingredientes": ["masa", "salsa", "muzzarella", "rucula", "jamonCrudo"]},
	{"tipo": "Pepperoni", "dificultad": "media", "ingredientes": ["masa", "salsa", "muzzarella", "tomate", "pepperoni"]},
	{"tipo": "Margarita", "dificultad": "facil", "ingredientes": ["masa", "salsa", "muzzarella", "albahaca", "aceite"]},
	
	{"tipo": "Cuatro Quesos", "dificultad": "dificil", "ingredientes": ["harina", "agua", "salsa", "mozzarella", "roquefort", "parmesano", "provolone"]},
	{"tipo": "Super Completa", "dificultad": "dificil", "ingredientes": ["harina", "agua", "salsa", "muzzarella", "jamon", "morron", "huevo", "aceitunas"]},
	{"tipo": "Bomba Frita", "dificultad": "dificil", "ingredientes": ["harina", "agua", "salsa", "muzzarella", "papasFritas", "cheddar", "panceta", "verdeo"]}
]

func ordenesConDificultad(dificultad):
	var ordenesFiltradas = []
	for orden in listaOrdenes:
		if orden["dificultad"] == dificultad:
			ordenesFiltradas.append(orden)
	return ordenesFiltradas
