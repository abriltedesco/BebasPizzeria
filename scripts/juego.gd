extends Node
@onready var pedidos= $Pedidos
@onready var cocina= $Cocina
@onready var interfaz= $Interfaz
@onready var timer_partida= $TimerPartida
var entrega_node: Node = null
var se_entrego_algo := false
var entrega_fue_exitosa := false
func _ready() -> void:
	match ProgresoManager.nivel_actual:
		1:
			PedidoManager.configurar_nivel(true, 1, 2)
			# aca cuando la cocina vaya cambiado deberia tener algo tipo
			# cocina.preparar_cocina(1) refieriendonos al nivel, asi este mismo script puede adaptarse
		2:
			PedidoManager.configurar_nivel(false, 3, 3)
		3:
			PedidoManager.configurar_nivel(false, 4, 10)
	interfaz.cambiar_vista.connect(_alternar_vista)
	interfaz.configurar_timer(timer_partida)
	timer_partida.timeout.connect(on_tiempo_agotado)
	PedidoManager.nivel_completado.connect(on_nivel_completado)
	entrega_node = get_tree().get_first_node_in_group("entrega")
	if entrega_node:
		entrega_node.pedido_resuelto.connect(_on_pedido_resuelto)
	else:
		print("no hay ninguna estacion en entrega")
	timer_partida.start()
	_mostrar_pedidos()
func _on_pedido_resuelto(exito: bool) -> void:
	se_entrego_algo = true
	entrega_fue_exitosa = exito
func on_tiempo_agotado() -> void:
	timer_partida.stop()
	_mostrar_pedidos()
	if not se_entrego_algo:
		print("no se entregó nada")
		PedidoManager.finalizar_partida()
		get_tree().change_scene_to_file("res://escenas/interfaces/GameOver.tscn")
		return
	if entrega_fue_exitosa:
		Puntaje.sumarPropina(100)
		if !(ProgresoManager.nivel_actual == 5):
			ProgresoManager.nivel_actual = 1
		get_tree().change_scene_to_file("res://escenas/interfaces/Niveles.tscn")
	else:
		print("no coinciden los ingredientes")
		PedidoManager.finalizar_partida()
		get_tree().change_scene_to_file("res://escenas/interfaces/GameOver.tscn")
func _alternar_vista() -> void:
	if cocina.visible:
		_mostrar_pedidos()
	else:
		_mostrar_cocina()
func _mostrar_pedidos() -> void:
	pedidos.visible= true
	pedidos.process_mode= Node.PROCESS_MODE_INHERIT
	cocina.visible= false
	cocina.process_mode= Node.PROCESS_MODE_DISABLED
	interfaz.set_vista_cocina(false)
func _mostrar_cocina() -> void:
	pedidos.visible= false
	pedidos.process_mode= Node.PROCESS_MODE_DISABLED
	cocina.visible= true
	cocina.process_mode= Node.PROCESS_MODE_INHERIT
	interfaz.set_vista_cocina(true)
	cocina.mostrar_instrucciones()
func on_nivel_completado() -> void:
	timer_partida.stop()
	if !(ProgresoManager.nivel_actual == 5): #mientras no sea mas q 5 o sea no sea el ult nivel q sume uno para ir avanzando
		ProgresoManager.nivel_actual= 1
	get_tree().reload_current_scene()
