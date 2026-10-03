extends Node
@onready var cantIngredienteLabel = $"../Control/Panel/listaIngredientes/datosIngrediente/cantidadIngrediente"
@onready var botonRestar = $"../Control/Panel/listaIngredientes/botonesUnidad/restarUnidad"
@onready var cargarCantIngrediente = $"../cargarCantidadIngrediente"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_restar_unidad_pressed() -> void:
	if cargarCantIngrediente.cantDefault > 0:
		cargarCantIngrediente.cantDefault -= 1
