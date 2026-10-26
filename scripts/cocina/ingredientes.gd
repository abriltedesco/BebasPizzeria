extends Estaciones
class_name Ingredientes

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
	"tomateCortado": "res://assets/comida/cortados/tomateCortado.png",
	"quesoCortado": "res://assets/comida/cortados/quesoCortado.png",
	"cebollaCortada": "res://assets/comida/cortados/cebollaCortada.png",
	"jamonCortado": "res://assets/comida/cortados/jamonCortado.png",
}

const TAMSPRITE := 32.0
const LADO_CORTADO := 16.0
const CORTADOS := ["tomateCortado", "quesoCortado", "cebollaCortada", "jamonCortado"]
const SHADER_GRIS := preload("res://assets/shaders/filtroGris.tres")
var sprite: CanvasItem = null
var estadoVisual: int = -1   # -1 = sin definir, 0 = inhabilitado, 1 = habilitado

static func escala_cortado(nombre: String) -> float:
	var tex: Texture2D = load(TEXTURAS[nombre])
	return LADO_CORTADO / maxf(tex.get_width(), tex.get_height())

func _ready() -> void:
	super._ready()
	sprite = get_node_or_null("sprite")
	visuales()

func _process(_delta: float) -> void:
	visuales()

func actualizar_dia() -> void:
	visuales()

func esta_desbloqueado() -> bool:
	var nombreIngrediente: String = obtener_item()
	return ControlIngred.esta_desbloqueado(nombreIngrediente)

func visuales() -> void:
	var habilitado: bool = esta_desbloqueado()
	var nuevoEstado: int = 1 if habilitado else 0
	if nuevoEstado == estadoVisual:
		return
	estadoVisual = nuevoEstado

	# el filtro gris solo se ve cuando el ingrediente está inhabilitado
	if sprite:
		sprite.visible = not habilitado

	for hijo in get_children():
		if hijo is Label:
			hijo.modulate = Color(1, 1, 1, 1) if habilitado else Color(1, 1, 1, 0.4)

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "" and esta_desbloqueado():
		var item = obtener_item()
		if item != "":
			jugador.agarrar_item(item)

func obtener_item() -> String:
	return ""
