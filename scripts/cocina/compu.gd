extends Estaciones
class_name compu

@onready var sprite = $sprite
@onready var colision = $CollisionShape2D
@onready var pantallaCompu = $pantallaCompu
@onready var botonVolver = $pantallaCompu/Control/Panel/volver
@onready var botonTiempo = get_node_or_null("pantallaCompu/Control/Panel/BotonTiempo")

var costoTiempo: int = 50
var segundosExtra: float = 30.0

func _ready() -> void:
	super._ready()
	actualizar_dia()
	pantallaCompu.visible = false
	botonVolver.pressed.connect(cerrarCompu)
	
	if botonTiempo:
		botonTiempo.pressed.connect(_on_comprar_tiempo_pressed)

func actualizar_dia() -> void:
	var activa= ControlIngred.esta_desbloqueado("compu")
	sprite.visible = !activa
	colision.set_deferred("disabled", !activa)
	
	if botonTiempo:
		var habilitado= ProgresoManager.nivel_actual >= 5
		botonTiempo.disabled = !habilitado
		botonTiempo.visible = true

func _process(_delta: float) -> void:
	var activa= ControlIngred.esta_desbloqueado("compu")
	if sprite.visible == activa:
		sprite.visible = !activa
	if colision.disabled == activa:
		colision.set_deferred("disabled", !activa)

func interactuar(jugador: CharacterBody2D) -> void:
	if pantallaCompu.visible:
		return
	print("compu.gd -> interactuar")
	pantallaCompu.visible = true

func cerrarCompu():
	pantallaCompu.visible = false

func _on_comprar_tiempo_pressed() -> void:
	if ProgresoManager.nivel_actual < 5:
		return
		
	if Puntaje.dinero < costoTiempo:
		print("No alcanza para comprar tiempo extra")
		return
	
	Puntaje.dinero -= costoTiempo
	Puntaje.cambio_puntaje.emit(Puntaje.dinero, Puntaje.pedidos_completados, Puntaje.pedidos_fallidos)
	Puntaje.reproducirSonidoCompra()
	
	var nivel = get_tree().current_scene
	if nivel and nivel.has_node("TimerPartida"):
		var timer = nivel.get_node("TimerPartida")
		timer.start(timer.time_left + segundosExtra)
		print("¡Compraste 30 segundos extra!")
