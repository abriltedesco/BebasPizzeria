extends Estaciones
class_name mesa

var items_en_mesa: Array[String]= []
var tipos_en_mesa: Array[String]= []
var sprites_items: Array[Sprite2D]= []
var zonas_en_mesa: Array[CollisionShape2D]= []

func interactuar(jugador: CharacterBody2D) -> void:
	var zona= mesaMasCercana(jugador.global_position)
	if zona== null:
		return

	if jugador.mano_item!= "":
		var item_mano= jugador.mano_item
		var tipo_mano= jugador.mano_item_tipo
		jugador.soltar_item()

		agregar_item(item_mano, tipo_mano, zona)
		intentar_armar_pizza(zona)
		intentar_emplatar(zona)
	else:
		var lugar= zonas_en_mesa.rfind(zona)
		if lugar!= -1:
			var item_tomado= items_en_mesa[lugar]
			var tipo_tomado= tipos_en_mesa[lugar]
			quitar_item_en_indice(lugar)
			jugador.agarrar_item(item_tomado, tipo_tomado)

func agregar_item(item_mano: String, tipo_mano: String, zona: CollisionShape2D) -> void:
	items_en_mesa.append(item_mano)
	tipos_en_mesa.append(tipo_mano)
	zonas_en_mesa.append(zona)

	var nuevo_sprite= Sprite2D.new()
	nuevo_sprite.texture_filter= TEXTURE_FILTER_NEAREST
	nuevo_sprite.scale= Vector2(1.2, 1.2)
	if item_mano== "plato":
		nuevo_sprite.texture= load("res://assets/comida/plato.png")
		nuevo_sprite.scale= Vector2(0.15, 0.15)
	elif item_mano== "queso":
		nuevo_sprite.texture= load("res://assets/comida/queso.png")
	elif item_mano== "tomate":
		nuevo_sprite.texture= load("res://assets/comida/tomate.png")
	elif item_mano== "masa":
		nuevo_sprite.texture= load("res://assets/comida/masa.png")
	elif item_mano== "pizzacruda":
		nuevo_sprite.texture= load("res://assets/comida/pizzacruda.png")
	elif item_mano== "pizzahecha":
		nuevo_sprite.texture= load("res://assets/comida/pizzacocinada.png")
	elif item_mano== "pizzaquemada":
		nuevo_sprite.texture= load("res://assets/comida/pizzaquemada.png")
	elif item_mano== "pizzaplato":
		nuevo_sprite.texture= load("res://assets/comida/pizzaplato.png")

	nuevo_sprite.position= zona.position
	add_child(nuevo_sprite)
	sprites_items.append(nuevo_sprite)

func quitar_item_en_indice(lugar: int) -> void:
	items_en_mesa.remove_at(lugar)
	tipos_en_mesa.remove_at(lugar)
	zonas_en_mesa.remove_at(lugar)
	sprites_items[lugar].queue_free()
	sprites_items.remove_at(lugar)

func intentar_armar_pizza(zona: CollisionShape2D) -> void:
	var ingredientes_crudos: Array[String]= []
	for i in range(items_en_mesa.size()):
		if items_en_mesa[i]!= "plato" and tipos_en_mesa[i]== "":
			ingredientes_crudos.append(items_en_mesa[i])

	for receta in BaseDeDatos.listaOrdenes:
		if receta["tipo"]== ClienteActual.pizza and coincide_receta(ingredientes_crudos, receta["ingredientes"]):
			quitar_ingredientes(receta["ingredientes"])
			agregar_item("pizzacruda", receta["tipo"], zona)
			return

	for receta in BaseDeDatos.listaOrdenes:
		if coincide_receta(ingredientes_crudos, receta["ingredientes"]):
			quitar_ingredientes(receta["ingredientes"])
			agregar_item("pizzacruda", receta["tipo"], zona)
			return

func coincide_receta(disponibles: Array[String], ingredientes_receta: Array) -> bool:
	var restantes= disponibles.duplicate()
	for ingrediente in ingredientes_receta:
		if ingrediente in restantes:
			restantes.erase(ingrediente)
		else:
			return false
	return true

func quitar_ingredientes(ingredientes_receta: Array) -> void:
	for ingrediente in ingredientes_receta:
		var idx= items_en_mesa.rfind(ingrediente)
		if idx!= -1:
			quitar_item_en_indice(idx)

func intentar_emplatar(zona: CollisionShape2D) -> void:
	var lugar_pizza= buscar_item_en_zona("pizzahecha", zona)
	var quemada= false
	var cruda= false
	
	if lugar_pizza== -1:
		lugar_pizza= buscar_item_en_zona("pizzaquemada", zona)
		if lugar_pizza!= -1:
			quemada= true
			
	if lugar_pizza== -1:
		lugar_pizza= buscar_item_en_zona("pizzacruda", zona)
		if lugar_pizza!= -1:
			cruda= true

	var lugar_plato= buscar_item_en_zona("plato", zona)

	if lugar_pizza== -1 or lugar_plato== -1:
		return

	var tipo_pizza= tipos_en_mesa[lugar_pizza]

	if lugar_pizza> lugar_plato:
		quitar_item_en_indice(lugar_pizza)
		quitar_item_en_indice(lugar_pizza)
	else:
		quitar_item_en_indice(lugar_pizza)
		quitar_item_en_indice(lugar_pizza)

	var tipo_pizzaplato = tipo_pizza
	if quemada:
		tipo_pizzaplato = "quemada:" + tipo_pizza
	elif cruda:
		tipo_pizzaplato = "sincocinar:" + tipo_pizza

	agregar_item("pizzaplato", tipo_pizzaplato, zona)

func buscar_item_en_zona(item: String, zona: CollisionShape2D) -> int:
	for lugar in range(items_en_mesa.size() - 1, -1, -1):
		if items_en_mesa[lugar]== item and zonas_en_mesa[lugar] == zona:
			return lugar
	return -1
