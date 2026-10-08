extends Node

var listaClientes = [
	{"nombre": "Ana", "asset": "res://assets/"},
	{"nombre": "María", "asset": "res://assets/"},
	{"nombre": "Helena", "asset": "res://assets/"},
	{"nombre": "Daniel", "asset": "res://assets/"},
	{"nombre": "Thiago", "asset": "res://assets/"}
]

var listaOrdenes = [
	{"tipo": "queso","dificultad": "facil", "ingredientes": ["masa", "tomate", "queso"]}, # pizza exclusiva nivel 1
	
	#pizza nivel 2 (se habilita jamon y cebolla) + pizzas queso
	{"tipo": "Fugazzetta", "dificultad": "facil", "ingredientes": ["masa", "queso", "cebolla"]},
	{"tipo": "Jamon", "dificultad": "facil", "ingredientes": ["masa", "tomate", "queso", "jamon"]},
	{"tipo": "Napolitana", "dificultad": "facil", "ingredientes": ["masa", "tomate", "queso", "tomate"]},
	
	#pizza nivel 3 (se habilita rucula, albahaca, morron, aceite y pepperoni)
	{"tipo": "Jamon y Morrón", "dificultad": "media", "ingredientes": ["harina", "agua", "tomate", "queso", "jamon", "morron"]},
	{"tipo": "Rucula y crudo", "dificultad": "media", "ingredientes": ["harina", "agua", "tomate", "queso", "rucula", "jamon"]},
	{"tipo": "Pepperoni", "dificultad": "media", "ingredientes": ["harina", "agua", "tomate", "queso", "tomate", "pepperoni"]},
	{"tipo": "Margarita", "dificultad": "media", "ingredientes": ["harina", "agua", "tomate", "queso", "albahaca", "aceite"]},
	
	#pizza nivel 4 (se habilita huevo, cheddar, papas, panceta, roquefort, parmesano, provolone, aceitunas)
	{"tipo": "Cuatro Quesos", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "queso", "roquefort", "parmesano", "provolone"]},
	{"tipo": "Super Completa", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "queso", "jamon", "morron", "huevo", "aceitunas"]},
	{"tipo": "Bomba Frita", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "queso", "papas", "cheddar", "panceta"]}

	#pizza nivel 5 cualquiera de las del nivel 3 o 4
]


var listaIngredientes = [
	{"nombre": "harina", "valor": 1},
	{"nombre": "agua", "valor": 1},
	{"nombre": "cebolla", "valor": 2},
	{"nombre": "jamon", "valor": 2},
	{"nombre": "rucula", "valor": 2},
	{"nombre": "tomate", "valor": 1},
	{"nombre": "queso", "valor": 1},
	{"nombre": "huevo", "valor": 2},
	{"nombre": "panceta", "valor": 4},
	{"nombre": "albahaca", "valor": 4},
	{"nombre": "aceitunas", "valor": 4},
	{"nombre": "papas", "valor": 5},
	{"nombre": "cheddar", "valor": 3},
	{"nombre": "roquefort", "valor": 5},
	{"nombre": "parmesano", "valor": 5},
	{"nombre": "aceite", "valor": 4},
	{"nombre": "pepperoni", "valor": 3},
]

func ordenesConDificultad(dificultad):
	var ordenesFiltradas = []
	for orden in listaOrdenes:
		if orden["dificultad"] == dificultad:
			ordenesFiltradas.append(orden)
	return ordenesFiltradas
