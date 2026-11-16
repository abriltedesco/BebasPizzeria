class_name ValidadorPizzas

const COCCIONES := {
	"poco cocida": Vector2i(3, 6),
	"medio cocida": Vector2i(7, 11),
	"muy cocida": Vector2i(12, 15)
}

static func coccion_aleatoria() -> String:
	return COCCIONES.keys().pick_random()

static func rango_coccion_texto(coccion: String) -> String:
	if !COCCIONES.has(coccion):
		return ""
	var rango: Vector2i = COCCIONES[coccion]
	return "%d-%d segundos" % [rango.x, rango.y]

static func coccion_correcta(coccion_pedida: String, tiempo: float) -> bool:
	if !COCCIONES.has(coccion_pedida):
		return true
	var rango: Vector2i = COCCIONES[coccion_pedida]
	var segundos := int(tiempo)
	return segundos >= rango.x and segundos <= rango.y

static func validar(pedido: Dictionary, pizza_preparada: Dictionary) -> bool:
	if pizza_preparada.get("tipo", "") != pedido.get("pizza", ""): 
		return false
		
	if !coccion_correcta(pedido.get("coccion", ""), pizza_preparada.get("coccion", 0.0)):
		return false
		
	var ing_req = pedido.get("listaOrden", []).duplicate()
	var ing_prep = pizza_preparada.get("ingredientes", []).duplicate()	
	
	if ing_prep.has("plato"):
		ing_prep.erase("plato")
		
	ing_req.sort()
	ing_prep.sort()
	
	print("requerida: ", ing_req, " | preparada: ", ing_prep)
	return ing_req == ing_prep
