extends Estaciones
class_name cortar


@onready var sprite = $sprite
@onready var colision = $CollisionShape2D


const CORTADOS := {
	"tomate": "tomateCortado",
	"queso": "quesoCortado",
	"cebolla": "cebollaCortada",
	"jamon": "jamonCortado",
}

func _ready() -> void:
	if ControladorIngredientes.esta_desbloqueado("compu"):
		sprite.material = null 
		colision.set_deferred("disabled", false)
	else:
		colision.set_deferred("disabled", true)
		
func actualizar_dia() -> void:
	var activa: bool = ProgresoManager.nivel_actual >= 2
	visible = activa
	for hijo in get_children():
		if hijo is CollisionShape2D:
			(hijo as CollisionShape2D).disabled = not activa

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item == "" or jugador.mano_item_tipo != "":
		return
	if not CORTADOS.has(jugador.mano_item):
		return

	var cortado: String = CORTADOS[jugador.mano_item]
	jugador.soltar_item()
	jugador.agarrar_item(cortado)
