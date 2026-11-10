extends Estaciones
class_name cortar

@onready var sprite = $sprite
@onready var colision = $CollisionShape2D

const CORTADOS := {
	"tomate": "tomateCortado",
	"queso": "quesoCortado",
	"cebolla": "cebollaCortada",
	"jamon": "jamonCortado",
	"rucula": "ruculaCortada",
	"morron": "morronCortado",
	"pepperoni": "pepperoniCortado",
}

func _ready() -> void:
	super._ready()
	actualizar_dia()

func _process(_delta: float) -> void:
	var activa: bool = ControladorIngredientes.esta_desbloqueado("cortar")
	if sprite.visible == activa:
		sprite.visible = !activa
		
	if colision.disabled == activa:
		colision.set_deferred("disabled", !activa)

func actualizar_dia() -> void:
	var activa: bool = ControladorIngredientes.esta_desbloqueado("cortar")
	sprite.visible = !activa
	colision.set_deferred("disabled", !activa)

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "" or jugador.mano_item_tipo != "":
		return
	
	if !CORTADOS.has(jugador.mano_item):
		return
	
	var cortado: String = CORTADOS[jugador.mano_item]
	jugador.mano_item = "" 
	jugador.agarrar_item(cortado)
