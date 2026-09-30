extends Control

@onready var labelOrden= $ordenDe
@onready var labelPizza= $pizza
@onready var labelItems= $items

signal textoListo
var datos_propios: Dictionary = {}

func actualizarOrden():
	labelOrden.text = "Orden de: " + datos_propios["nombre"]
	labelPizza.text = "PIZZA : " + datos_propios["pizza"]
	
	var textoIngredientes = ""
	
	for ingrediente in datos_propios["listaOrden"]:
		textoIngredientes += "- " + ingrediente + "\n"
	labelItems.text = textoIngredientes
		
	labelOrden.visible_characters = 0
	labelPizza.visible_characters = 0
	labelItems.visible_characters = 0

	
	var tween= create_tween()
	var tiempoN= labelOrden.text.length() * 0.05  
	var tiempoP= labelPizza.text.length() * 0.05
	var tiempoI= labelItems.text.length() * 0.05
	
	tween.tween_property(labelOrden, "visible_characters", labelOrden.text.length(), tiempoN)
	tween.tween_interval(0.2) 
	tween.tween_property(labelPizza, "visible_characters", labelPizza.text.length(), tiempoP)
	tween.tween_interval(0.2)
	tween.tween_property(labelItems, "visible_characters", labelItems.text.length(), tiempoI)
	
	await tween.finished
	textoListo.emit()
