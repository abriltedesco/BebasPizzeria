extends Node
@onready var cantIngredienteLabel = $"../Control/Panel/listaIngredientes/datosIngrediente/cantidadIngrediente"
@onready var botonRestar = $"../Control/Panel/listaIngredientes/botonesUnidad/restarUnidad"
@onready var cargarCantIngrediente = $"../cargarCantidadIngrediente"
func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_restar_unidad_pressed() -> void:
	if cargarCantIngrediente.cantDefault > 0:
		cargarCantIngrediente.cantDefault -= 1
