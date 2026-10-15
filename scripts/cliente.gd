extends CharacterBody2D

signal entregar_presionado(numOrden)
signal tiempo_agotado(cliente_nodo)

@onready var btnEntregar = $BotonEntregar
@onready var lblTiempo = $TiempoEspera

var numOrden: int = 0
var duracionTotal: float = 60.0
var tiempoTranscurrido: float = 0.0
var ordenTomada: bool = false
var en_posicion: bool = false
var dialogando: bool = false
var nombre_cliente: String = ""
var orden_elegida: Dictionary = {}
var dificultad_cliente: String = "facil"

func _ready() -> void:
	if btnEntregar:
		btnEntregar.visible = false
		btnEntregar.custom_minimum_size = Vector2(140, 30)
		btnEntregar.position = Vector2(-70, -120) 
		if !btnEntregar.pressed.is_connected(_on_boton_entregar_pressed):
			btnEntregar.pressed.connect(_on_boton_entregar_pressed)
	if lblTiempo:
		lblTiempo.visible = true
		lblTiempo.custom_minimum_size = Vector2(100, 25)
		lblTiempo.position = Vector2(-50, -150) 
		lblTiempo.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

func inicializarDatos(datosCliente, datosOrden):
	ClienteActual.nombre = datosCliente["nombre"]
	ClienteActual.pizza = datosOrden["tipo"]
	ClienteActual.dificultad = datosOrden["dificultad"]
	ClienteActual.listaOrden = datosOrden["ingredientes"]
	ClienteActual.reiniciarIndice()

func activar_interfaz_orden(num_orden: int) -> void:
	numOrden = num_orden
	ordenTomada = true
	
	if btnEntregar:
		btnEntregar.text = "Entregar orden #" + str(numOrden)
		btnEntregar.visible = not PedidoManager.secuencial

func _process(delta: float) -> void:
	if en_posicion and !dialogando and tiempoTranscurrido < duracionTotal:
		tiempoTranscurrido += delta
		var restante = maxf(duracionTotal - tiempoTranscurrido, 0.0)
		
		if lblTiempo:
			var mins = int(restante) / 60
			var segs = int(restante) % 60
			lblTiempo.text = "%02d:%02d" % [mins, segs]
			
		if tiempoTranscurrido >= duracionTotal:
			tiempo_agotado.emit(self)
			en_posicion = false
func _on_boton_entregar_pressed() -> void:
	entregar_presionado.emit(numOrden)
