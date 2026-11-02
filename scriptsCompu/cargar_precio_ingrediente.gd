extends Node

@onready var labelPrecioIngrediente =  $"../Control/Panel/listaIngredientes/ingrediente/datosIngrediente/precioIngrediente"
@export var precioIngrediente: float = 500.0
func _ready() -> void:
	pass

func _process(delta: float) -> void:
	labelPrecioIngrediente.text = str(precioIngrediente)
