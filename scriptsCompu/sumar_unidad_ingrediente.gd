extends Node

@onready var cantIngredienteLabel = $"../Control/Panel/listaIngredientes/datosIngrediente/cantidadIngrediente"
@onready var botonSumar = $"../Control/Panel/listaIngredientes/botonesUnidad/sumarUnidad"
@onready var cargarCantIngrediente = $"../cargarCantidadIngrediente"
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_sumar_unidad_pressed() -> void:
	cargarCantIngrediente.cantDefault += 1
