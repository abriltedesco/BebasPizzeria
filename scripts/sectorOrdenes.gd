extends Node2D

@onready var cliente= $Cliente
@onready var clienteMov= $Cliente/movimientoCliente
@onready var orden= $Control
@onready var ruta_cliente= $RutaCliente
@onready var finNivel= $finNivel

@export var tipo_pedido= "queso"

var atendiendo= false

func _ready() -> void:
	orden.visible= false
	cliente.visible= false
	finNivel.visible= false
	clienteMov.configurar_ruta(ruta_cliente)
	PedidoManager.configurar_nivel(true, 1, 2)
	PedidoManager.dia_terminado.connect(finDia)

func _process(_delta: float) -> void:
	if is_visible_in_tree() and PedidoManager.cliente_esperando and !atendiendo:
		generar_pedido()

func finDia() -> void:
	atendiendo= true
	finNivel.visible= true
	finNivel.play("dianoche")
	await get_tree().create_timer(11.0).timeout
	finNivel.visible= false
	atendiendo= false
	PedidoManager.continuar_despues_del_dia()

func generar_pedido() -> void:
	atendiendo = true
	var clienteElegido = BaseDeDatos.listaClientes.pick_random()
	var ordenesPermitidas = []
	
	match ProgresoManager.nivel_actual:
		1:
			for orden in BaseDeDatos.listaOrdenes:
				if orden["tipo"] == "queso":
					ordenesPermitidas.append(orden)
		2:
			ordenesPermitidas = BaseDeDatos.ordenesConDificultad("facil")
		_:
			# todavia esta indefinido apartir del nivel 3
			ordenesPermitidas = BaseDeDatos.listaOrdenes
			
	var ordenElegida = ordenesPermitidas.pick_random()
	
	cliente.inicializarDatos(clienteElegido, ordenElegida)
	cliente.visible = true
	clienteMov.movimientoEntrar()
	await clienteMov.movimiento_terminado
	
	if PedidoManager.partida_finalizada:
		cliente.visible = false
		atendiendo= false
		return
		
	var dialogo = load("res://dialogue/pedido_cliente.dialogue")
	var escena_globo = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena_globo)
	escena_globo.start(dialogo, "start", [self])
	await escena_globo.tree_exited
	
	PedidoManager.tomar_pedido(clienteElegido["nombre"], ordenElegida)
	clienteMov.irse()
	await clienteMov.salida_terminada
	cliente.visible = false
	atendiendo = false
