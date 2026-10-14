extends Control

@onready var labelOrden= $ordenDe
@onready var labelPizza= $pizza
@onready var labelItems= $items
@onready var barra = $BarraTiempo
@onready var labelTiempo = $Tiempo
@onready var boton = $Desplegar
@onready var fondo = $TextureRect

signal textoListo
var datos_propios = {}

func _ready():
	if datos_propios.is_empty():
		return
	boton.pressed.connect(cambiar_desplegado)
	mostrar_u_ocultar()

func _process(_delta):
	if datos_propios.is_empty():
		return
	var restante = maxf(datos_propios["duracion"] - datos_propios["tiempo_transcurrido"], 0.0)
	barra.frame = int(datos_propios["tiempo_transcurrido"] / datos_propios["duracion"] * 10)
	
	var numOrden = datos_propios.get("numero_orden", 1)
	var mins = int(restante) / 60
	var segs = int(restante) % 60

	labelTiempo.text = "(#%d - %02d:%02d)" % [numOrden, mins, segs]
	
func cambiar_desplegado():
	datos_propios["desplegado"] = not datos_propios["desplegado"]
	mostrar_u_ocultar()

func mostrar_u_ocultar():
	var abierto = datos_propios["desplegado"]
	labelOrden.visible = abierto
	labelPizza.visible = abierto
	labelItems.visible = abierto
	if abierto:
		fondo.size.y = 438
	else:
		fondo.size.y = 64

func actualizarOrden():
	if !is_node_ready():
		await ready

	labelOrden.text = "Orden de: " + datos_propios["nombre"]
	labelPizza.text = "PIZZA : " + datos_propios["pizza"]
	
	var textoIngredientes = ""
	
	for ingrediente in datos_propios["listaOrden"]:
		textoIngredientes += "- " + ingrediente + "\n"
	labelItems.text = textoIngredientes
		
	labelOrden.visible_characters = 0
	labelPizza.visible_characters = 0
	labelItems.visible_characters = 0

	
	var tween = create_tween()
	tween.tween_property(labelOrden, "visible_characters", labelOrden.text.length(), labelOrden.text.length() * 0.05)
	tween.tween_interval(0.2)
	tween.tween_property(labelPizza, "visible_characters", labelPizza.text.length(), labelPizza.text.length() * 0.05)
	tween.tween_interval(0.2)
	tween.tween_property(labelItems, "visible_characters", labelItems.text.length(), labelItems.text.length() * 0.05)
	
	await tween.finished
	textoListo.emit()
