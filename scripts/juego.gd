extends Node

@onready var pedidos= $Pedidos
@onready var cocina= $Cocina
@onready var interfaz= $Interfaz
@onready var timer_partida= $TimerPartida

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
	timer_partida.start()
	_mostrar_pedidos()

func on_tiempo_agotado() -> void:
	PedidoManager.finalizar_partida()
	get_tree().change_scene_to_file("res://escenas/GameOver.tscn")

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
		ProgresoManager.nivel_actual += 1 
	get_tree().reload_current_scene()
