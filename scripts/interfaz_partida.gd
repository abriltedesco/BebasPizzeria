extends CanvasLayer

signal cambiar_vista

@onready var actualizador = $ActualizadorUI
@onready var boton_flecha= $BotonFlecha

var izquierda= preload("res://assets/izquierda.png")
var derecha= preload("res://assets/derecha.png")
# @onready var aviso_cliente= $AvisoCliente

var vista_cocina= false
var timer_partida
var ultimo_segundo_mostrado= -1

func _ready() -> void:
	actualizador.crear_contenedor_pedidos(self)
	boton_flecha.pressed.connect(_on_boton_flecha_pressed)
	
	PedidoManager.tiempo_agotado.connect(actualizador.mostrar_tiempo_agotado)
	Puntaje.cambio_puntaje.connect(_on_cambio_puntaje)
	PedidoManager.pedido_cambiado.connect(_on_pedido_cambiado)

func _process(_delta: float) -> void:
	if timer_partida== null or timer_partida.is_stopped():
		return

	var segundos= ceili(timer_partida.time_left)
	if segundos!= ultimo_segundo_mostrado:
		ultimo_segundo_mostrado= segundos
		actualizador.actualizar_tiempo(segundos)

func configurar_timer(nuevo_timer) -> void:
	timer_partida= nuevo_timer
	ultimo_segundo_mostrado= ceili(timer_partida.wait_time)
	actualizador.actualizar_tiempo(ultimo_segundo_mostrado)
	
	
func _on_boton_flecha_pressed() -> void:
	cambiar_vista.emit()
	
func set_vista_cocina(es_cocina: bool) -> void:
	vista_cocina= es_cocina
	boton_flecha.texture_normal= izquierda if vista_cocina else derecha
	actualizador.actualizar_aviso(vista_cocina, PedidoManager.cliente_esperando)

func _on_cambio_puntaje(dinero, completados, fallidos):
	actualizador.actualizar_puntaje(dinero, completados, fallidos)
	
func _on_pedido_cambiado():
	actualizador.actualizar_lista_pedidos(PedidoManager.pedidos_activos)
