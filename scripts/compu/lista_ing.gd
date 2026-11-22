extends VBoxContainer

var escenaIngrediente = load("res://escenas/compu/ingrediente.tscn")
signal totalCambiado(total: int)

func _ready() -> void:
	var pantalla := _buscar_pantalla()
	if pantalla:
		pantalla.visibility_changed.connect(_on_compu_visibility_changed)
	StockManager.stock_actualizado.connect(_on_stock_actualizado)
	cargar_ingredientes()

func _buscar_pantalla() -> CanvasLayer:
	var nodo: Node = get_parent()
	while nodo:
		if nodo is CanvasLayer:
			return nodo
		nodo = nodo.get_parent()
	return null

func _on_compu_visibility_changed() -> void:
	var pantalla := _buscar_pantalla()
	if pantalla and pantalla.visible:
		cargar_ingredientes()

func _on_stock_actualizado() -> void:
	var pantalla := _buscar_pantalla()
	if pantalla and not pantalla.visible:
		cargar_ingredientes()

func cargar_ingredientes() -> void:
	for hijo in get_children():
		remove_child(hijo)
		hijo.queue_free()
		
	for datos in BaseDeDatos.listaIngredientes:
		var nombre_ing = datos["nombre"].to_lower()
		if nombre_ing == "masa" or nombre_ing == "agua":
			continue
			
		var ingrediente = escenaIngrediente.instantiate()
		add_child(ingrediente)
		ingrediente.configurar(datos)
		ingrediente.cantidadCambiada.connect(_on_cantidad_cambiada)

func calcularTotal() -> int:
	var total = 0
	for ingrediente in get_children():
		if not ingrediente.is_queued_for_deletion():
			total += ingrediente.calcularCosto()
	return total

func _on_cantidad_cambiada() -> void:
	totalCambiado.emit(calcularTotal())

func _on_comprar_pressed() -> void:
	var total = calcularTotal()
	if total <= 0:
		return
	if Puntaje.dinero < total:
		print("No alcanza el dinero")
		return
		
	Puntaje.dinero -= total
	Puntaje.cambio_puntaje.emit(Puntaje.dinero, Puntaje.pedidos_completados, Puntaje.pedidos_fallidos)
	Puntaje.reproducirSonidoCompra()
	
	for ingrediente in get_children():
		if not ingrediente.is_queued_for_deletion():
			ingrediente.confirmarStock()
	totalCambiado.emit(calcularTotal())
