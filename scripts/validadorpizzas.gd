class_name ValidadorPizzas

static func validar(pedido: Dictionary, pizza_preparada: Dictionary) -> bool:
	if pizza_preparada.get("tipo", "") != pedido.get("pizza", ""): 
		return false
		
	var ing_req = pedido.get("listaOrden", []).duplicate()
	var ing_prep = pizza_preparada.get("ingredientes", []).duplicate()	
	
	if ing_prep.has("plato"):
		ing_prep.erase("plato")
		
	ing_req.sort()
	ing_prep.sort()
	
	print("requerida: ", ing_req, " | preparada: ", ing_prep)
	return ing_req == ing_prep
