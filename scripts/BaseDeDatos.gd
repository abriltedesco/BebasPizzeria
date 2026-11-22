extends Node

var listaClientes = [
	{"nombre": "Ana", "asset": "res://assets/personajes/cliente2.png"},
	{"nombre": "María", "asset": "res://assets/personajes/cliente3.png"},
	{"nombre": "Helena", "asset": "res://assets/personajes/cliente4.png"}
	#{"nombre": "Daniel", "asset": "res://assets/"},
	#{"nombre": "Thiago", "asset": "res://assets/"}
]

var listaOrdenes = [
	{"tipo": "queso","dificultad": "facil", "ingredientes": ["masa", "tomate", "queso"], "desde": 1, "hasta": 1},
	{"tipo": "queso","dificultad": "facil", "ingredientes": ["masa", "tomateCortado", "quesoCortado"], "desde": 2},
	
	{"tipo": "Fugazzeta","dificultad": "facil", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "cebollaCortada"], "desde": 2},
	{"tipo": "Jamon","dificultad": "facil", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "jamonCortado"], "desde": 2},
	
	{"tipo": "Jamon y Morrón", "dificultad": "media", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "jamonCortado", "morronCortado"], "desde": 3},
	{"tipo": "Rucula y crudo", "dificultad": "media", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "jamonCrudoCortado", "ruculaCortada"], "desde": 3},
	{"tipo": "Pepperoni", "dificultad": "media", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "pepperoniCortado"], "desde": 3},
	{"tipo": "Margarita", "dificultad": "media", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "aceite"], "desde": 3},
	
	{"tipo": "Cuatro Quesos", "dificultad": "dificil", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "roquefortCortado", "parmesanoCortado", "provoloneCortado"], "desde": 4},
	{"tipo": "Super Completa", "dificultad": "dificil", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "jamonCortado", "morronCortado", "huevoCortado", "aceitunaCortada"], "desde": 4},
	{"tipo": "Bomba Frita", "dificultad": "dificil", "ingredientes": ["masa", "tomateCortado", "quesoCortado", "papas", "cheddarCortado", "pancetaCortada"], "desde": 4}
	
]

var listaIngredientes = [
	{"nombre": "masa", "valor": 0, "stock":0},
	{"nombre": "harina", "valor": 1, "stock":0},
	{"nombre": "agua", "valor": 1, "stock":0},
	{"nombre": "cebolla", "valor": 2, "stock":0},
	{"nombre": "jamon", "valor": 2, "stock":0},
	{"nombre": "jamonCrudo", "valor": 2, "stock":0},
	{"nombre": "rucula", "valor": 2, "stock":0},
	{"nombre": "tomate", "valor": 1, "stock":0},
	{"nombre": "queso", "valor": 1, "stock":0},
	{"nombre": "huevo", "valor": 2, "stock":0},
	{"nombre": "panceta", "valor": 4, "stock":0},
	{"nombre": "albahaca", "valor": 4, "stock":0},
	{"nombre": "aceitunas", "valor": 4, "stock":0},
	{"nombre": "papas", "valor": 5, "stock":0},
	{"nombre": "cheddar", "valor": 3, "stock":0},
	{"nombre": "roquefort", "valor": 5, "stock":0},
	{"nombre": "parmesano", "valor": 5, "stock":0},
	{"nombre": "aceite", "valor": 4, "stock":0},
	{"nombre": "pepperoni", "valor": 3, "stock":0},
]
var respuestasPedidoExitoso=["¡Muchas gracias!", "Que rico! muchisimas gracias!!"]
var respuestasPedidoTardo=["¡Me hiciste esperar demasiado!", "Podrías haberlo hecho un poco más rápido..."]
var respuestasPedidoFallido=["Esto no es lo que esperaba...", "No pedí eso..", "Mmm... no es exactamente lo que te pedí"]
var respuestasPedidoCoccion=["Esta pizza no está en el punto de cocción que te pedí...", "Mmm... la cocción no es la que pedí."]

func recetasDelDia() -> Array:
	var dia: int = ProgresoManager.nivel_actual
	var recetas := []
	for orden in listaOrdenes:
		if dia >= orden.get("desde", 1) and dia <= orden.get("hasta", 999):
			recetas.append(orden)
	return recetas

func ordenesConDificultad(dificultad):
	var ordenesFiltradas=[]
	for orden in recetasDelDia():
		if orden["dificultad"]== dificultad:
			ordenesFiltradas.append(orden)
	return ordenesFiltradas

func obtenerOrdenPorTipo(tipo: String)-> Dictionary:
	for orden in recetasDelDia():
		if orden["tipo"].to_lower()== tipo.to_lower():
			return orden
	return {}

func spritePizzaHecha(tipo: String) -> String:
	match tipo:
		"Fugazzeta":
			return "res://assets/comida/pizzas/pizzaCebolla.png"
		"Jamon":
			return "res://assets/comida/pizzas/pizzaJamon.png"
		"Pepperoni":
			return "res://assets/comida/pizzas/pizzaPepperoni.png"
		"Jamon y Morrón":
			return "res://assets/comida/pizzas/pizzaJamMorron.png"
		"Super Completa":
			return "res://assets/comida/pizzas/pizzaHuevo.png"
		"Cuatro Quesos":
			return "res://assets/comida/pizzas/pizzaCheddar.png"
		"Rucula y crudo":
			return "res://assets/comida/pizzas/pizzaRucula.png"
		"Margarita":
			return "res://assets/comida/pizzas/PizzaTomate.png"
	return "res://assets/comida/pizzacocinada.png"

func obtenerRespuestaCliente(exito: bool, motivo: String = "") -> String:
	if !exito:
		if motivo == "tiempo":
			return respuestasPedidoTardo.pick_random()
		elif motivo == "coccion_incorrecta":
			return respuestasPedidoCoccion.pick_random()
		else:
			return respuestasPedidoFallido.pick_random()
	return respuestasPedidoExitoso.pick_random()
