extends Node

var listaClientes = [
	{"nombre": "Ana", "asset": "res://assets/"},
	{"nombre": "María", "asset": "res://assets/"},
	{"nombre": "Helena", "asset": "res://assets/"},
	{"nombre": "Daniel", "asset": "res://assets/"},
	{"nombre": "Thiago", "asset": "res://assets/"}
]

var listaOrdenes = [
	{
	"tipo": "queso",
	"dificultad": "facil", 
	"ingredientes": ["masa", "tomate", "queso"]
	},
	
	{"tipo": "Fugazzetta", "dificultad": "facil", "ingredientes": ["masa", "queso", "cebolla"]},
	{"tipo": "Jamon", "dificultad": "facil", "ingredientes": ["masa", "tomate", "queso", "jamon"]},
	{"tipo": "Napolitana", "dificultad": "facil", "ingredientes": ["masa", "tomate", "queso", "tomate"]},
		
	{"tipo": "Calabresa", "dificultad": "media", "ingredientes": ["masa", "tomate", "queso", "longaniza", "morron"]},
	{"tipo": "Rucula y crudo", "dificultad": "media", "ingredientes": ["masa", "tomate", "queso", "rucula", "jamonCrudo"]},
	{"tipo": "Pepperoni", "dificultad": "media", "ingredientes": ["masa", "tomate", "queso", "tomate", "pepperoni"]},
	{"tipo": "Margarita", "dificultad": "facil", "ingredientes": ["masa", "tomate", "queso", "albahaca", "aceite"]},
	
	{"tipo": "Cuatro Quesos", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "mozzarella", "roquefort", "parmesano", "provolone"]},
	{"tipo": "Super Completa", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "queso", "jamon", "morron", "huevo", "aceitunas"]},
	{"tipo": "Bomba Frita", "dificultad": "dificil", "ingredientes": ["harina", "agua", "tomate", "queso", "papasFritas", "cheddar", "panceta", "verdeo"]}
]

func ordenesConDificultad(dificultad):
	var ordenesFiltradas=[]
	for orden in listaOrdenes:
		if orden["dificultad"]== dificultad:
			ordenesFiltradas.append(orden)
	return ordenesFiltradas

func obtenerOrdenPorTipo(tipo: String)-> Dictionary:
	for orden in listaOrdenes:
		if orden["tipo"].to_lower()== tipo.to_lower():
			return orden
	return {}
