extends Node

@onready var baseDeDatos = "res://scriptsCompu/baseDeDatosIngredientes.gd"
@onready var cantIngredienteLabel = $"../Control/Panel/listaIngredientes/ingrediente/datosIngrediente/cantidadIngrediente"
@export var cantDefault = 0

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	cantIngredienteLabel.text = str(cantDefault)
