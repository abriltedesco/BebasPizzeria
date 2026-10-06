extends Node

@onready var label_tiempo = $"../LabelTiempo"
@onready var label_puntaje = $"../LabelPropina"
@onready var aviso_cliente = $"../AvisoCliente"
var contenedor_pedidos: Control 

func crear_contenedor_pedidos(padre: CanvasLayer) -> void:
	contenedor_pedidos = Control.new()
	contenedor_pedidos.position = Vector2(600, 15)
	padre.add_child(contenedor_pedidos)

func actualizar_tiempo(segundos: int) -> void:
	var minutos = segundos / 60
	var resto = segundos % 60
	label_tiempo.text = "%02d:%02d" % [minutos, resto]

func actualizar_puntaje(dinero: int, completados: int, fallidos: int) -> void:
	label_puntaje.text = "Puntaje: $%d" % dinero

func actualizar_aviso(vista_cocina: bool, hay_cliente: bool) -> void:
	aviso_cliente.visible = vista_cocina and hay_cliente

func mostrar_tiempo_agotado() -> void:
	label_tiempo.text = "00:00"
	label_tiempo.add_theme_color_override("font_color", Color("ff4d4d"))
	
func actualizar_lista_pedidos(pedidos_activos: Array) -> void:
	for ticket_viejo in contenedor_pedidos.get_children():
		ticket_viejo.queue_free()
		
	var orden_escena = load("res://escenas/interfaces/orden.tscn")
	var distancia_x = 0
	
	for datos_pedido in pedidos_activos:
		var nuevo_ticket = orden_escena.instantiate()
		nuevo_ticket.scale = Vector2(0.55, 0.55)
		nuevo_ticket.position = Vector2(distancia_x, 0)
		nuevo_ticket.datos_propios = datos_pedido
		contenedor_pedidos.add_child(nuevo_ticket)
		nuevo_ticket.actualizarOrden()
		distancia_x += 180
