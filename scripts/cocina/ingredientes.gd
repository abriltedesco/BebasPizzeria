extends Estaciones
class_name Ingredientes
var controlador: Node = null
func _ready() -> void:
	super._ready()
	controlador = get_tree().get_first_node_in_group("controlador_ingredientes")
	visuales()
func _process(_delta: float) -> void:
	visuales()
func esta_desbloqueado() -> bool:
	if controlador==null:
		return true 
	return controlador.esta_desbloqueado(obtener_item())
func visuales() -> void:
	if esta_desbloqueado():
		modulate=Color(1, 1, 1, 1)
	else:
		modulate=Color(0.5, 0.5, 0.5, 1)
func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item==""and esta_desbloqueado():
		var item= obtener_item()
		if item!="":
			jugador.agarrar_item(item)
func obtener_item() -> String:
	return ""
