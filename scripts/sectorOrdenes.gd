extends Node2D

@onready var orden = $Control
@onready var rutaCliente = $RutaCliente

const ClienteEscena = preload("res://escenas/cliente.tscn") 

var clientes_en_fila = [] 
var atendiendo = false
var timer_spawner = 2.0 

func _ready() -> void:
	orden.visible = false
	PedidoManager.pedido_resuelto.connect(_on_pedido_resuelto_global)
	
func _process(delta: float) -> void:
	if PedidoManager.partida_finalizada: return
	
	if clientes_en_fila.size() < PedidoManager.max_simultaneos:
		timer_spawner -= delta
		if timer_spawner <= 0:
			timer_spawner = PedidoManager.tiempo_entre_clientes
			_spawn_cliente()
			
	for i in range(clientes_en_fila.size() - 1, -1, -1):
		if !is_instance_valid(clientes_en_fila[i]):
			clientes_en_fila.remove_at(i)
			
	for i in range(clientes_en_fila.size() - 1, -1, -1):
		var cliente = clientes_en_fila[i]
	
		if !is_instance_valid(cliente):
			clientes_en_fila.remove_at(i)
			continue
				
	if is_visible_in_tree() and not atendiendo:
		for cliente in clientes_en_fila:
			if is_instance_valid(cliente) and !cliente.ordenTomada and cliente.en_posicion:
				_atender_cliente(cliente)
				break
				
func _spawn_cliente() -> void:
	var nuevo_cliente = ClienteEscena.instantiate()
	add_child(nuevo_cliente)
	nuevo_cliente.tiempo_agotado.connect(_on_cliente_tiempo_agotado)
	
	var clienteMov = nuevo_cliente.get_node("movimientoCliente")
	clienteMov.configurar_ruta(rutaCliente)
	
	var clienteElegido = BaseDeDatos.listaClientes.pick_random()
	var ordenesPermitidas = []
	
	match ProgresoManager.nivel_actual:
		1:
			for orden_bd in BaseDeDatos.listaOrdenes:
				if orden_bd["tipo"] == "queso":
					ordenesPermitidas.append(orden_bd)
		2:
			# ordenesPermitidas = BaseDeDatos.ordenesConDificultad("facil")
			# pongo de vuelta queso solo para probar q funcione el nivel 2 hasta q agreguemos otros ingredientes
			for orden_bd in BaseDeDatos.listaOrdenes:
				if orden_bd["tipo"] == "queso":
					ordenesPermitidas.append(orden_bd)
		3:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("media")
		4:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("dificil")
		5:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("media")
			ordenesPermitidas.append(BaseDeDatos.ordenesConDificultad("dificil"))
			
	var ordenElegida = ordenesPermitidas.pick_random()
	var tiempos_paciencia = [75.0, 95.0, 120.0] 
	nuevo_cliente.duracionTotal = tiempos_paciencia.pick_random()
	
	nuevo_cliente.tiempoTranscurrido = 0.0
	nuevo_cliente.en_posicion = false
	nuevo_cliente.dialogando = false
	nuevo_cliente.ordenTomada = false
	nuevo_cliente.nombre_cliente = clienteElegido["nombre"]
	nuevo_cliente.orden_elegida = ordenElegida
	nuevo_cliente.dificultad_cliente = ordenElegida.get("dificultad", "facil")
	
	clientes_en_fila.append(nuevo_cliente)
	nuevo_cliente.visible = true
	
	PedidoManager.registrar_llegada()
	
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado
	
	if is_instance_valid(nuevo_cliente):
		nuevo_cliente.en_posicion = true
		if get_tree().current_scene.has_method("mostrar_aviso_cliente"):
			get_tree().current_scene.mostrar_aviso_cliente()
	
	if !PedidoManager.secuencial and is_instance_valid(nuevo_cliente):
		var index_en_fila = clientes_en_fila.find(nuevo_cliente)
		var pos_x_final = 200 + (index_en_fila * 120)
		var tween = create_tween()
		tween.tween_property(nuevo_cliente, "position", Vector2(pos_x_final, 370), 0.8)

func _atender_cliente(cliente_nodo) -> void:
	atendiendo = true
	cliente_nodo.dialogando = true 
	
	ClienteActual.nombre = cliente_nodo.nombre_cliente
	ClienteActual.pizza = cliente_nodo.orden_elegida["tipo"]
	ClienteActual.dificultad = cliente_nodo.dificultad_cliente
	ClienteActual.listaOrden = cliente_nodo.orden_elegida["ingredientes"]
	ClienteActual.reiniciarIndice()
	
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, "start", [self])
	await escena_globo.tree_exited
	
	if is_instance_valid(cliente_nodo):
		cliente_nodo.dialogando = false
		var datosTomados = PedidoManager.tomar_pedido(cliente_nodo.nombre_cliente, cliente_nodo.orden_elegida, cliente_nodo.duracionTotal, cliente_nodo.tiempoTranscurrido)
		var numOrden = datosTomados.get("numero_orden", 1)
		
		cliente_nodo.activar_interfaz_orden(numOrden)
		cliente_nodo.entregar_presionado.connect(_on_cliente_entregar_presionado)
		cliente_nodo.ordenTomada = true
	
	atendiendo = false

func _cliente_se_va_enojado(cliente_nodo, idx_fila: int) -> void:
	cliente_nodo.set_meta("pedido_tomado", true) 
	Puntaje.sumarPedidoFallido()
	PedidoManager.cliente_ignorado_se_fue()
	
	var clienteMov = cliente_nodo.get_node("movimientoCliente")
	clienteMov.irse()
	
	clientes_en_fila.remove_at(idx_fila)
	_reordenar_fila()
	
	await clienteMov.salida_terminada
	if is_instance_valid(cliente_nodo):
		cliente_nodo.queue_free()

func _on_cliente_entregar_presionado(numOrden: int) -> void:
	if PedidoManager.pizza_preparada.is_empty():
		print("no dejaste ninguna pizza en la estación de entrega")
		return
		
	var idx = PedidoManager.buscar_indice_por_numero_orden(numOrden)
	
	if idx != -1:
		var exito = PedidoManager.validar_pizza_preparada(numOrden)
		var motivo = "exito" if exito else "pizza_incorrecta"
	
		if exito:
			var pedido = PedidoManager.pedidos_activos[idx]
			var tiempo_restante = pedido["duracion"] - pedido["tiempo_transcurrido"]
			if tiempo_restante <= 15.0:
				exito = false
				motivo = "tiempo"
					
		PedidoManager.completar_pedido(idx, exito, motivo)
		PedidoManager.pizza_preparada.clear()

func _on_pedido_resuelto_global(exito_pedido: bool, motivo_pedido: String, nombre_cliente: String, numero_orden: int) -> void:
	var cliente_que_recibe = null
	var idx_fila = -1
	
	for i in range(clientes_en_fila.size()):
		if clientes_en_fila[i].nombre_cliente == nombre_cliente:
			cliente_que_recibe = clientes_en_fila[i]
			idx_fila = i
			break
			
	if !cliente_que_recibe: return
		
	atendiendo = true 
	if exito_pedido:
		var dificultad_cliente = cliente_que_recibe.dificultad_cliente
		Puntaje.sumarPedidoCompletado(dificultad_cliente)
		
	if !PedidoManager.secuencial:
		var tween = create_tween()
		tween.tween_property(cliente_que_recibe, "position", Vector2(600, 370), 0.5)
		await tween.finished
	
	ClienteActual.respuesta = BaseDeDatos.obtenerRespuestaCliente(exito_pedido, motivo_pedido)
	var titulo_respuesta = "respuesta_exito" if exito_pedido else "respuesta_fallo"
	
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, titulo_respuesta, [self])
	await escena_globo.tree_exited
	
	var clienteMov = cliente_que_recibe.get_node("movimientoCliente")
	clienteMov.irse()
	await clienteMov.salida_terminada
	
	cliente_que_recibe.queue_free()
	clientes_en_fila.remove_at(idx_fila)
	_reordenar_fila() 
	atendiendo = false

func _reordenar_fila() -> void:
	if PedidoManager.secuencial: return
	for i in range(clientes_en_fila.size()):
		var cliente = clientes_en_fila[i]
		var pos_x = 200 + (i * 120)
		var tween = create_tween()
		tween.tween_property(cliente, "position", Vector2(pos_x, 370), 0.5)
		
func _on_cliente_tiempo_agotado(cliente_nodo) -> void:
	var idx = clientes_en_fila.find(cliente_nodo)
	if idx != -1:
		if cliente_nodo.ordenTomada:
			var idx_pedido = PedidoManager.buscar_indice_por_numero_orden(cliente_nodo.numOrden)
			if idx_pedido != -1:
				PedidoManager.completar_pedido(idx_pedido, false, "tiempo")
		else:
			# Si te tardaste en atenderlo, se va ofendido de la fila sin globo de diálogo
			_cliente_se_va_enojado(cliente_nodo, idx)
