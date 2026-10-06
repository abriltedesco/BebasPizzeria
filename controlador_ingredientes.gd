extends Node
class_name ControladorIngredientes
var ingredientes_por_nivel: Dictionary = {
	1: ["masa","tomate","queso","plato"],
	2: ["masa","tomate","queso","plato","cebolla"],
	3: ["masa","tomate","queso","plato","cebolla","jamon"],
}
var ingredientes_desbloqueados: Array[String] = []
func _ready() -> void:
	add_to_group("controlador_ingredientes")
	ingredientes_desbloqueados = ingredientes_por_nivel.get(ProgresoManager.nivel_actual, [])
func esta_desbloqueado(ingrediente: String) -> bool:
	return ingrediente in ingredientes_desbloqueados
func desbloquear(ingrediente: String) -> void:
	if ingrediente not in ingredientes_desbloqueados:
		ingredientes_desbloqueados.append(ingrediente)
func bloquear(ingrediente: String) -> void:
	ingredientes_desbloqueados.erase(ingrediente)
