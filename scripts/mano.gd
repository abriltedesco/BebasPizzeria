extends Node2D

@onready var sprite: Sprite2D= $Sprite2D
var item= ""

func _ready() -> void:
	visible= false
	if sprite== null and has_node("Sprite2D"):
		sprite= $Sprite2D

func set_item(nombre: String, tipo: String = "") -> void:
	item= nombre
	visible= nombre!= ""
	if nombre== "":
		return
	if sprite== null and has_node("Sprite2D"):
		sprite= $Sprite2D
	if sprite:
		sprite.visible= true
		sprite.scale= Vector2(1, 1)
		match nombre:
			"queso", "tomate", "masa", "cebolla", "jamon", "rucula", "huevo", "albahaca", "aceitunas", "papas", "cheddar", "roquefort", "parmesano", "aceite", "pepperoni", "tomateCortado", "quesoCortado", "cebollaCortada", "jamonCortado":
				sprite.texture = load(Ingredientes.TEXTURAS[nombre])
				if nombre in Ingredientes.CORTADOS:
					sprite.scale = Vector2.ONE * Ingredientes.escala_cortado(nombre)
			"plato":
				sprite.texture= load("res://assets/comida/plato.png")
				sprite.scale= Vector2(0.1, 0.1)
			"pizzaplato":
				sprite.texture= load("res://assets/comida/pizzaplato.png")
			"pizzacruda":
				sprite.texture= load("res://assets/comida/pizzacruda.png")
			"pizzahecha":
				sprite.texture= load(BaseDeDatos.spritePizzaHecha(tipo))
			"pizzaquemada":
				sprite.texture= load("res://assets/comida/pizzaquemada.png")
			_:
				sprite.visible= false
				visible= false

func clear() -> void:
	set_item("")
