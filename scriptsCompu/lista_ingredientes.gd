extends VBoxContainer

@onready var cargarPlataDelJugador = $"../../../cargarPlataDelJugador"
@onready var escenaIngrediente = preload("res://scenesCompu/ingrediente.tscn")
signal totalCambiado(total: int)

func _ready() -> void:
	for datos in BaseDeDatos.listaIngredientes:
		var ingrediente = escenaIngrediente.instantiate()
		add_child(ingrediente)
		ingrediente.configurar(datos)
		ingrediente.cantidadCambiada.connect(_on_cantidad_cambiada)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func calcularTotal() -> int:
	var total = 0
	for ingrediente in self.get_children():
		total += ingrediente.calcularCosto()
	return total

func _on_cantidad_cambiada() -> void:
	totalCambiado.emit(calcularTotal())

func _on_comprar_pressed() -> void:
	var total = calcularTotal()
	if cargarPlataDelJugador.dineroJugador < total:
		print("no alcanza el dienro")
		return
	cargarPlataDelJugador.dineroJugador -= total
	for ingrediente in self.get_children():
		ingrediente.confirmarStock()
	print("lista ingredeintes _on_comprar_pressed -> comprado")
