extends Node2D

@onready var orden = $Control
@onready var rutaCliente = $RutaCliente
@onready var gestorFila = $ManejarFila  
@onready var gestorDialogos = $ManejarDialogo

const ClienteEscena = preload("res://escenas/cliente.tscn") 
var atendiendo = false
var timer_spawner = 2.0 

func _ready() -> void:
	orden.visible = false
	PedidoManager.pedido_resuelto.connect(_on_pedido_resuelto_global)
	
func _process(delta: float) -> void:
	if PedidoManager.partida_finalizada: return
	
	manejar_spawner(delta)
	gestorFila.limpiarInvalidos()
	manejar_paciencia_fila(delta)
				
	if is_visible_in_tree() and not atendiendo:
		for cliente in gestorFila.clientes_en_fila:
			if is_instance_valid(cliente) and not cliente.ordenTomada and cliente.en_posicion:
				_atender_cliente(cliente)
				break

func manejar_spawner(delta: float) -> void:
	if gestorFila.hayEspacio():
		timer_spawner -= delta
		if timer_spawner <= 0:
			timer_spawner = PedidoManager.tiempo_entre_clientes
			_spawn_cliente()

func manejar_paciencia_fila(delta: float) -> void:
	for i in range(gestorFila.clientes_en_fila.size() - 1, -1, -1):
		var cliente = gestorFila.clientes_en_fila[i]
		if is_instance_valid(cliente) and cliente.en_posicion and not cliente.ordenTomada and not cliente.dialogando:
			var espera = cliente.get_meta("tiempo_espera", 0.0) + delta
			cliente.set_meta("tiempo_espera", espera)
			if espera >= cliente.duracionTotal:
				_cliente_se_va_enojado(cliente, i)
								
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
	confDatos_nuevoCliente(nuevo_cliente, clienteElegido, ordenElegida)	
	gestorFila.agregar_cliente(nuevo_cliente)
	nuevo_cliente.visible = true
	
	PedidoManager.registrar_llegada()
	
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado
	
	if is_instance_valid(nuevo_cliente):
		nuevo_cliente.en_posicion = true
		if get_tree().current_scene.has_method("mostrar_aviso_cliente"):
			get_tree().current_scene.mostrar_aviso_cliente()
	
	if is_instance_valid(nuevo_cliente):
		gestorFila.posicionar_nuevo_cliente(nuevo_cliente)
	
	
func confDatos_nuevoCliente(cliente: Node, datos_cliente: Dictionary, orden: Dictionary) -> void:
	var tiempos_paciencia = [75.0, 95.0, 120.0] 
	cliente.duracionTotal = tiempos_paciencia.pick_random()
	cliente.tiempoTranscurrido = 0.0
	cliente.en_posicion = false
	cliente.dialogando = false
	cliente.ordenTomada = false
	cliente.nombre_cliente = datos_cliente["nombre"]
	cliente.orden_elegida = orden
	cliente.dificultad_cliente = orden.get("dificultad", "facil")
	cliente.set_meta("tiempo_espera", 0.0)
	
func _atender_cliente(cliente_nodo: Node) -> void:
	atendiendo = true
	cliente_nodo.dialogando = true 
	
	gestorDialogos.configurar_cliente_actual(cliente_nodo)
	await gestorDialogos.mostrar_dialogo(self, self, "start")
	
	if is_instance_valid(cliente_nodo):
		cliente_nodo.dialogando = false
		var datosTomados = PedidoManager.tomar_pedido(cliente_nodo.nombre_cliente, cliente_nodo.orden_elegida, cliente_nodo.duracionTotal, cliente_nodo.tiempoTranscurrido)
		var numOrden = datosTomados.get("numero_orden", 1)
		
		cliente_nodo.activar_interfaz_orden(numOrden)
		cliente_nodo.entregar_presionado.connect(_on_cliente_entregar_presionado)
		cliente_nodo.ordenTomada = true
	
	atendiendo = false
	
func _cliente_se_va_enojado(cliente_nodo: Node, idx_fila: int) -> void:
	cliente_nodo.set_meta("pedido_tomado", true) 
	Puntaje.sumarPedidoFallido()
	PedidoManager.cliente_ignorado_se_fue()
	
	var clienteMov = cliente_nodo.get_node("movimientoCliente")
	clienteMov.irse()
	
	gestorFila.remover_cliente_por_indice(idx_fila)
	
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
	var cliente_que_recibe = gestorFila.obtener_cliente_por_nombre(nombre_cliente)
			
	if not cliente_que_recibe: return
		
	atendiendo = true 
	if exito_pedido:
		Puntaje.sumarPedidoCompletado(cliente_que_recibe.dificultad_cliente)
		
	if not PedidoManager.secuencial:
		var tween = create_tween()
		tween.tween_property(cliente_que_recibe, "position", Vector2(600, 370), 0.5)
		await tween.finished
	
	ClienteActual.respuesta = BaseDeDatos.obtenerRespuestaCliente(exito_pedido, motivo_pedido)
	var titulo = "respuesta_exito" if exito_pedido else "respuesta_fallo"
	
	await gestorDialogos.mostrar_dialogo(self, self, titulo)
	
	var clienteMov = cliente_que_recibe.get_node("movimientoCliente")
	clienteMov.irse()
	await clienteMov.salida_terminada
	
	gestorFila.remover_cliente(cliente_que_recibe)
	if is_instance_valid(cliente_que_recibe):
		cliente_que_recibe.queue_free()
		
	atendiendo = false

func _on_cliente_tiempo_agotado(cliente_nodo) -> void:
	var idx = gestorFila.clientes_en_fila.find(cliente_nodo)
	if idx != -1:
		if cliente_nodo.ordenTomada:
			var idx_pedido = PedidoManager.buscar_indice_por_numero_orden(cliente_nodo.numOrden)
			if idx_pedido != -1:
				PedidoManager.completar_pedido(idx_pedido, false, "tiempo")
		else:
			_cliente_se_va_enojado(cliente_nodo, idx)
