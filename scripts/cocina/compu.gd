extends Estaciones
class_name compu

@onready var sprite = $sprite
@onready var colision = $CollisionShape2D
@onready var pantallaCompu = $PantallaCompu
@onready var botonVolver = $PantallaCompu/Control/Panel/volver

func _ready() -> void:
	super._ready()
	actualizar_dia()
	pantallaCompu.visible = false
	botonVolver.pressed.connect(cerrarCompu)
	
func actualizar_dia() -> void:
	var activa: bool = ControladorIngredientes.esta_desbloqueado("compu")
	sprite.visible = !activa
	colision.set_deferred("disabled", !activa)
	
func _process(_delta: float) -> void:
	var activa: bool = ControladorIngredientes.esta_desbloqueado("compu")
	if sprite.visible == activa:
		sprite.visible = !activa
	if colision.disabled == activa:
		colision.set_deferred("disabled", !activa)
		
func interactuar(jugador: CharacterBody2D) -> void:
	if pantallaCompu.visible:
			return
	print("compu.gd -> interactuar")
	pantallaCompu.visible = true

func cerrarCompu():
	pantallaCompu.visible = false
