extends Node

@onready var nombreClienteLabel = $"../debug/nombreCliente"
@onready var tipoOrdenLabel = $"../debug/tipoOrden"
@onready var dificultadOrdenLabel = $"../debug/dificultadOrden"
@onready var ingredientesOrdenLabel = $"../debug/ingredientesOrdenLabel"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta: float) -> void:
# 	nombreClienteLabel.text = $"../Cliente".datos_cliente["nombre"]
# 	tipoOrdenLabel.text= $"../Cliente".datos_orden["tipo"]
# 	dificultadOrdenLabel.text = $"../Cliente".datos_orden["dificultad"]
# 	ingredientesOrdenLabel.text = ", ".join($"../Cliente".datos_orden["ingredientes"])
# 		
