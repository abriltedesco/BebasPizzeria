extends Control

@onready var label_orden = $orden
@onready var barra = $BarraTiempo
@onready var fondo = $TextureRect

var datos_propios = {}

func _ready():
	if datos_propios.is_empty():
		return

func _process(_delta):
	if datos_propios.is_empty():
		return

	var numOrden = datos_propios.get("numero_orden", 1)
	var nombrePizza = datos_propios.get("pizza", "")
	
	label_orden.text = "#" + str(numOrden) + " - " + nombrePizza
	var tiempo_actual = datos_propios.get("tiempo_transcurrido", 0.0)
	var duracion_total = datos_propios.get("duracion", 60.0)
	
	if duracion_total > 0:
		var porcentaje = tiempo_actual / duracion_total
		
		if barra is AnimatedSprite2D:
			var total_frames = barra.sprite_frames.get_frame_count(barra.animation)
			var frame_actual = int(porcentaje * total_frames)
			barra.frame = clamp(frame_actual, 0, total_frames - 1)
			
