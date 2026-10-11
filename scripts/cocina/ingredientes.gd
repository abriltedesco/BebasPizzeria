extends Estaciones
class_name Ingredientes
var controlador: Node = null
const TEXTURAS := {
	"queso": "res://assets/comida/Ingredientes/queso.png",
	"tomate": "res://assets/comida/Ingredientes/tomate.png",
	"masa": "res://assets/comida/Ingredientes/masa.png",
	"cebolla": "res://assets/comida/Ingredientes/Cebolla.png",
	"jamon": "res://assets/comida/Ingredientes/Jamon.png",
	"rucula": "res://assets/comida/Ingredientes/Rucula.png",
	"huevo": "res://assets/comida/Ingredientes/Huevo.png",
	"albahaca": "res://assets/comida/Ingredientes/Albahaca.png",
	"aceitunas": "res://assets/comida/Ingredientes/Aceituna.png",
	"papas": "res://assets/comida/Ingredientes/Papa.png",
	"cheddar": "res://assets/comida/Ingredientes/Cheddar.png",
	"roquefort": "res://assets/comida/Ingredientes/Roquefort.png",
	"parmesano": "res://assets/comida/Ingredientes/Parmesano.png",
	"aceite": "res://assets/comida/Ingredientes/Aceite.png",
	"pepperoni": "res://assets/comida/Ingredientes/Pepperoni.png",
}
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
