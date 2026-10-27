extends Node
class_name ControladorIngredientes

const ING_CONST := ["plato"]
const ING_NUEVOS_POR_NIVEL := {
	1: ["masa", "tomate", "queso"],
	2: ["cebolla", "jamon", "cortar"],
	3: ["rucula", "albahaca", "morron", "aceite", "pepperoni", "compu"],
	4: ["huevo", "cheddar", "papas", "panceta", "roquefort", "parmesano", "aceitunas"],
	5: [],
}

# sin depender de ningún nodo ni del orden de carga
static var desbloqueados: Array = []
static var nivel_cargado: int = -1

static func sincronizar() -> void:
	var nivel: int = ProgresoManager.nivel_actual
	if nivel == nivel_cargado:
		return
	nivel_cargado = nivel
	desbloqueados.clear()
	desbloqueados.append_array(ING_CONST)
	for n in range(1, nivel + 1):
		desbloqueados.append_array(ING_NUEVOS_POR_NIVEL.get(n, []))

static func esta_desbloqueado(ingrediente: String) -> bool:
	sincronizar()
	return ingrediente in desbloqueados

static func desbloquear(ingrediente: String) -> void:
	sincronizar()
	if ingrediente not in desbloqueados:
		desbloqueados.append(ingrediente)

static func bloquear(ingrediente: String) -> void:
	sincronizar()
	desbloqueados.erase(ingrediente)
