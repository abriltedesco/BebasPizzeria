extends Node

@onready var cantidadUnidadesIngrediente = $"../cargarCantidadIngrediente"
@onready var cargarPlataJugador = $"../cargarPlataDelJugador"
@onready var cargarPrecioIngrediente = $"../cargarPrecioIngrediente"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_comprar_pressed() -> void:
	var precioCompra = cargarPrecioIngrediente.precioIngrediente * cantidadUnidadesIngrediente.cantDefault
	if precioCompra <= cargarPlataJugador.dineroJugador:
		cargarPlataJugador.dineroJugador -= precioCompra
		print("se compro bien")
	else:
		print("dinero insuficiente")
