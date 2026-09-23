extends Control

@onready var labelOrden = $ordenDe
@onready var labelPizza = $pizza
@onready var labelItems = $items

func actualizarOrden():
	labelOrden.text = "Orden de: " + ClienteActual.nombre
	labelPizza.text = "PIZZA : " + ClienteActual.pizza
	
	var textoIngredientes = ""
	
	for ingrediente in ClienteActual.listaOrden:
		textoIngredientes += "- " + ingrediente + "\n"
	labelItems.text = textoIngredientes
		
	labelOrden.visible_characters = 0
	labelPizza.visible_characters = 0
	labelItems.visible_characters = 0
	
	var tween = create_tween()
	
	# misma velocidad x letra para cada uno
	var tiempoN = labelOrden.text.length() * 0.05  
	var tiempoP = labelPizza.text.length() * 0.05
	var tiempoI = labelItems.text.length() * 0.05
	
	tween.tween_property(labelOrden, "visible_characters", labelOrden.text.length(), tiempoN)
	tween.tween_interval(0.2) 
	tween.tween_property(labelPizza, "visible_characters", labelPizza.text.length(), tiempoP)
	tween.tween_interval(0.2)
	tween.tween_property(labelItems, "visible_characters", labelItems.text.length(), tiempoI)
