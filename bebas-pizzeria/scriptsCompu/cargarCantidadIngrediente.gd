extends Node

@onready var cantIngredienteLabel = $"../Control/Panel/listaIngredientes/ingrediente/datosIngrediente/cantidadIngrediente"
@export var cantDefault = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cantIngredienteLabel.text = str(cantDefault)
