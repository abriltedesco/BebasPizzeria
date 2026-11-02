extends VBoxContainer

@onready var escenaIngrediente = preload("res://scenesCompu/ingrediente.tscn")
signal totalCambiado(total: int)

func _ready() -> void:
	for datos in BaseDeDatos.listaIngredientes:
		var ingrediente = escenaIngrediente.instantiate()
		add_child(ingrediente)
		ingrediente.configurar(datos)
		ingrediente.cantidadCambiada.connect(_on_cantidad_cambiada)

func calcularTotal() -> int:
	var total = 0
	for ingrediente in self.get_children():
		total += ingrediente.calcularCosto()
	return total

func _on_cantidad_cambiada() -> void:
	totalCambiado.emit(calcularTotal())

func _on_comprar_pressed() -> void:
	var total = calcularTotal()
	
	if Puntaje.dinero < total:
		print("No alcanza el dinero")
		return
		
	Puntaje.dinero -= total
	Puntaje.cambio_puntaje.emit(Puntaje.dinero, Puntaje.pedidos_completados, Puntaje.pedidos_fallidos)
	
	for ingrediente in self.get_children():
		ingrediente.confirmarStock()
