extends Estaciones
class_name compu

@onready var colision = $CollisionShape2D
@onready var pantallaCompu = $PantallaCompu
@onready var botonVolver = $PantallaCompu/Control/Panel/volver

func _ready() -> void:
	super._ready()
	if ControladorIngredientes.esta_desbloqueado("compu"):
		colision.set_deferred("disabled", false)
	else:
		colision.set_deferred("disabled", true)
	pantallaCompu.visible = false
	botonVolver.pressed.connect(cerrarCompu)
	
func interactuar(jugador: CharacterBody2D) -> void:
	if pantallaCompu.visible:
			return
	print("compu.gd -> interactuar")
	pantallaCompu.visible = true

func cerrarCompu():
	pantallaCompu.visible = false
