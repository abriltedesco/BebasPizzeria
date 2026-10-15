extends Node

var clientes_en_fila: Array = []
@export var pos_inicial_x: float = 200.0
@export var sep_x: float = 120.0
@export var pos_y: float = 370.0

func hayEspacio() -> bool:
	return clientes_en_fila.size() < PedidoManager.max_simultaneos

func agregar_cliente(cliente: Node2D) -> void:
	clientes_en_fila.append(cliente)
	
func remover_cliente(cliente: Node2D) -> void:
	var idx = clientes_en_fila.find(cliente)
	if idx != -1:
		clientes_en_fila.remove_at(idx)
		reordenarFila()
		
func remover_cliente_por_indice(idx: int) -> void:
	if idx >= 0 and idx < clientes_en_fila.size():
		clientes_en_fila.remove_at(idx)
		reordenarFila()

func obtener_cliente_por_nombre(nombre: String) -> Node2D:
	for cliente in clientes_en_fila:
		if is_instance_valid(cliente) and cliente.nombre_cliente == nombre:
			return cliente
	return null

func posicionar_nuevo_cliente(cliente: Node2D) -> void:
	if PedidoManager.secuencial:
		return
	var index_en_fila = clientes_en_fila.find(cliente)
	var pos_x_final = pos_inicial_x + (index_en_fila * sep_x)
	var tween = create_tween()
	tween.tween_property(cliente, "position", Vector2(pos_x_final, pos_y), 0.8)

func reordenarFila() -> void:
	if PedidoManager.secuencial: 
		return
	for i in range(clientes_en_fila.size()):
		var cliente = clientes_en_fila[i]
		if is_instance_valid(cliente):
			var pos_x = pos_inicial_x + (i * sep_x)
			var tween = create_tween()
			tween.tween_property(cliente, "position", Vector2(pos_x, pos_y), 0.5)

func limpiarInvalidos() -> void:
	for i in range(clientes_en_fila.size() - 1, -1, -1):
		if not is_instance_valid(clientes_en_fila[i]):
			clientes_en_fila.remove_at(i)
