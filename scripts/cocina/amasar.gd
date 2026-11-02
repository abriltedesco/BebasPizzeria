extends Estaciones
class_name amasar

const INGREDIENTES_MEZCLA := ["harina", "agua"]

@onready var sprite = $sprite
@onready var colision = $CollisionShape2D

var guardado: String = ""

func _ready() -> void:
	super._ready()
	actualizar_dia()

func actualizar_dia() -> void:
	var desbloqueada: bool = ControladorIngredientes.esta_desbloqueado("amasar")
	sprite.visible = not desbloqueada
	colision.set_deferred("disabled", not desbloqueada)

func interactuar(jugador: CharacterBody2D) -> void:
	if not ControladorIngredientes.esta_desbloqueado("amasar"):
		return
	var item: String = jugador.mano_item
	if item not in INGREDIENTES_MEZCLA:
		return

	if guardado == "":
		guardado = item
		jugador.soltar_item()
	elif guardado != item:
		guardado = ""
		jugador.soltar_item()
		jugador.agarrar_item("masa")
