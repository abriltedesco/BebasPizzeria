extends CanvasLayer

signal cambiar_vista

@onready var label_tiempo= $LabelTiempo
@onready var label_puntaje= $LabelPuntaje
@onready var boton_flecha= $BotonFlecha
@onready var aviso_cliente= $AvisoCliente

var izquierda= preload("res://assets/izquierda.png")
var derecha= preload("res://assets/derecha.png")

var orden_panel
var vista_cocina= false
var timer_partida
var ultimo_segundo_mostrado= -1

func _ready() -> void:
	layer= 20
	_crear_panel_pedido()
	boton_flecha.pressed.connect(_on_boton_flecha_pressed)
	PedidoManager.pedido_cambiado.connect(_actualizar_pedido)
	PedidoManager.cliente_esperando_cambiado.connect(_actualizar_aviso)
	PedidoManager.tiempo_agotado.connect(_mostrar_tiempo_agotado)
	Puntaje.cambio_puntaje.connect(_actualizar_puntaje)
	
	_actualizar_pedido()
	_actualizar_aviso()
	_actualizar_puntaje(Puntaje.dinero, Puntaje.pedidos_completados, Puntaje.pedidos_fallidos)

func _process(_delta: float) -> void:
	if timer_partida== null or timer_partida.is_stopped():
		return
	var segundos= ceili(timer_partida.time_left)
	if segundos!= ultimo_segundo_mostrado:
		ultimo_segundo_mostrado= segundos
		_actualizar_tiempo(segundos)

func configurar_timer(nuevo_timer) -> void:
	timer_partida= nuevo_timer
	ultimo_segundo_mostrado= ceili(timer_partida.wait_time)
	_actualizar_tiempo(ultimo_segundo_mostrado)

func _crear_panel_pedido() -> void:
	var orden_escena= load("res://escenas/orden.tscn")
	orden_panel= orden_escena.instantiate()
	orden_panel.visible= false
	orden_panel.scale= Vector2(0.55, 0.55)
	orden_panel.set_anchors_preset(Control.PRESET_TOP_RIGHT)
	orden_panel.offset_left= -160.0
	orden_panel.offset_top= 12.0
	add_child(orden_panel)

func _on_boton_flecha_pressed() -> void:
	cambiar_vista.emit()

func set_vista_cocina(es_cocina: bool) -> void:
	vista_cocina= es_cocina
	boton_flecha.texture_normal= izquierda if vista_cocina else derecha
	_actualizar_aviso()

func _actualizar_pedido() -> void:
	if orden_panel:
		orden_panel.visible= PedidoManager.pedido_activo
		if PedidoManager.pedido_activo:
			orden_panel.actualizarOrden()

func _actualizar_aviso() -> void:
	aviso_cliente.visible= vista_cocina and PedidoManager.cliente_esperando

func _actualizar_tiempo(segundos: int) -> void:
	var minutos= segundos/60
	var resto= segundos%60
	label_tiempo.text= "%02d:%02d"%[minutos, resto]

func _actualizar_puntaje(dinero, completados, fallidos) -> void:
	if label_puntaje:
		label_puntaje.text= "Puntaje: $%d"%dinero

func _mostrar_tiempo_agotado() -> void:
	label_tiempo.text= "00:00"
	label_tiempo.add_theme_color_override("font_color", Color("ff4d4d"))
