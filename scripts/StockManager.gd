extends Node
signal stock_actualizado
signal stock_insuficiente(nombre_ing: String)

func inicializar_stock() -> void:
	for ing in BaseDeDatos.listaIngredientes:
		if ProgresoManager.nivel_actual < 4:
			ing["stock"] = 999 
		else:
			match ing["nombre"]:
				"harina":
					ing["stock"] = 6
				"queso", "tomate", "cebolla", "jamon":
					ing["stock"] = 4
				_:
					ing["stock"] = 2 
	stock_actualizado.emit()
			
func requiere_stock(nombre_ing: String) -> bool:
	if ProgresoManager.nivel_actual < 4:
		return false
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			return true
	return false
	
func obtener_stock(nombre_ing: String) -> int:
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			return ing.get("stock", 0)
	return 0
	
func consumir_stock(nombre_ing: String) -> bool:
	if ProgresoManager.nivel_actual < 4:
		return true
		
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			if ing.get("stock", 0) > 0:
				ing["stock"] -= 1
				stock_actualizado.emit()
				return true
			else:
				stock_insuficiente.emit(nombre_ing)
				return false
	return false
	
func agregar_stock(nombre_ing: String, cantidad: int) -> void:
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			ing["stock"] = ing.get("stock", 0) + cantidad
			stock_actualizado.emit()
			return
