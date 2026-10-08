extends Node
class_name NivelBase 

@onready var pedidos = $Pedidos
@onready var cocina = $Cocina
@onready var interfaz = $Interfaz
@onready var timerPartida = $TimerPartida
@onready var transicion = $finNivel
@onready var avisoCliente = $avisoCliente

var entregaNode = null
var pizzaEntregada = false
var entregaExitosa = false
var escenaSiguiente: String = "" 

func _ready() -> void:
	transicion.visible = false
	avisoCliente.visible = false
	
	interfaz.cambiar_vista.connect(_alternar_vista)
	interfaz.configurar_timer(timerPartida)
	timerPartida.timeout.connect(on_tiempo_agotado)
	
	entregaNode = get_tree().get_first_node_in_group("entrega")
	if entregaNode:
		entregaNode.pedido_resuelto.connect(_on_pedido_resuelto)
	else:
		print("NivelBase: no hay ninguna estación en el grupo 'entrega'.")
		
	timerPartida.start()
	_mostrar_pedidos()

func _on_pedido_resuelto(exito: bool) -> void:
	pizzaEntregada = true
	if exito:
		entregaExitosa = true 
	
func on_tiempo_agotado() -> void:
	timerPartida.stop()
	_mostrar_pedidos()
	
	#para q no quede colgado el globo
	if pedidos.has_node("ExampleBalloon"):
		pedidos.get_node("ExampleBalloon").queue_free()
	if cocina.has_node("ExampleBalloon"):
		cocina.get_node("ExampleBalloon").queue_free()
	if pizzaEntregada and entregaExitosa:
		Puntaje.sumarPropina(100)
		
		transicion.visible = true
		interfaz.visible = false 
		var anim = transicion.get_node("animacion")
		anim.play("dianoche") 
		await anim.animation_finished
		transicion.visible = false
		
		get_tree().change_scene_to_file(escenaSiguiente)
	else:
		print("No se entregó ninguna pizza correcta. Fin del juego.")
		PedidoManager.finalizar_partida()
		get_tree().change_scene_to_file("res://escenas/interfaces/GameOver.tscn")
		
func _alternar_vista() -> void:
	if cocina.visible:
		_mostrar_pedidos()
	else:
		_mostrar_cocina()
		
func _mostrar_pedidos() -> void:
	pedidos.visible = true
	pedidos.process_mode = Node.PROCESS_MODE_INHERIT
	cocina.visible = false
	cocina.process_mode = Node.PROCESS_MODE_DISABLED
	interfaz.set_vista_cocina(false)
	
func _mostrar_cocina() -> void:
	pedidos.visible = false
	pedidos.process_mode = Node.PROCESS_MODE_DISABLED
	cocina.visible = true
	cocina.process_mode = Node.PROCESS_MODE_INHERIT
	interfaz.set_vista_cocina(true)
	cocina.mostrar_instrucciones()
	
func mostrar_aviso_cliente() -> void:
	avisoCliente.visible = true
	var timer_cartel = get_tree().create_timer(3.0)
	timer_cartel.timeout.connect(func(): avisoCliente.visible = false)
	
