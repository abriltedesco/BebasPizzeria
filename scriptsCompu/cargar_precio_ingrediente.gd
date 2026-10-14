extends Node

@onready var labelPrecioIngrediente =  $"../Control/Panel/listaIngredientes/ingrediente/datosIngrediente/precioIngrediente"
@export var precioIngrediente: float = 500.0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	labelPrecioIngrediente.text = str(precioIngrediente)
