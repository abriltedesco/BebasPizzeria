extends Node

func inicializar_stock() -> void:
	for ing in BaseDeDatos.listaIngredientes:
		if ProgresoManager.nivel_actual < 3:
			ing["stock"] = 999 
		else:
			match ing["nombre"]:
				"queso", "tomate", "cebolla", "jamon":
					ing["stock"] = 3
				_:
					ing["stock"] = 0 
					
func requiere_stock(nombre_ing: String) -> bool:
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
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			if ing.get("stock", 0) > 0:
				ing["stock"] -= 1
				return true
			return false
	return false
	
func agregar_stock(nombre_ing: String, cantidad: int) -> void:
	for ing in BaseDeDatos.listaIngredientes:
		if ing["nombre"] == nombre_ing:
			ing["stock"] = ing.get("stock", 0) + cantidad
			return
