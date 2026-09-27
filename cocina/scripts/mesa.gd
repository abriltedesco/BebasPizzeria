extends Estaciones
class_name mesa

var items_en_mesa: Array[String] = []
var tipos_en_mesa: Array[String] = []   # mismo índice que items_en_mesa. "" si no es una pizza (ingrediente crudo o plato)
var sprites_items: Array[Sprite2D] = []

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item != "":
		var item_mano: String = jugador.mano_item
		var tipo_mano: String = jugador.mano_item_tipo
		jugador.soltar_item()

		agregar_item(item_mano, tipo_mano)
		intentar_armar_pizza()
		intentar_emplatar()
	else:
		if items_en_mesa.size() > 0:
			var item_tomado = items_en_mesa.pop_back()
			var tipo_tomado = tipos_en_mesa.pop_back()
			var sp_tomado = sprites_items.pop_back()
			sp_tomado.queue_free()
			jugador.agarrar_item(item_tomado, tipo_tomado)

func agregar_item(item_mano: String, tipo_mano: String) -> void:
	items_en_mesa.append(item_mano)
	tipos_en_mesa.append(tipo_mano)

	var nuevo_sprite = Sprite2D.new()
	nuevo_sprite.texture_filter = TEXTURE_FILTER_NEAREST

	if item_mano == "plato":
		nuevo_sprite.scale = Vector2(0.4, 0.4)
		nuevo_sprite.texture = load("res://cocina/assets/comida/plato.png")
	elif item_mano == "queso":
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/queso.png")
	elif item_mano == "tomate":
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/tomate.png")
	elif item_mano == "masa":
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/masa.png")
	elif item_mano in ["pizzaq1oh", "pizzaqoh"]:
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/pizzaqoh.png")
	elif item_mano == "pizzahecha":
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/pizzacocinada.png")
	elif item_mano == "pizzaquemada":
		nuevo_sprite.scale = Vector2(0.8, 0.8)
		nuevo_sprite.texture = load("res://cocina/assets/comida/pizzaquemada.png")
	elif item_mano == "pizzaplato":
		nuevo_sprite.scale = Vector2(0.4, 0.4)
		nuevo_sprite.texture = load("res://cocina/assets/comida/pizzaplato.png")

	if has_node("CollisionShape2D"):
		nuevo_sprite.position = $CollisionShape2D.position
	else:
		nuevo_sprite.position = Vector2.ZERO

	add_child(nuevo_sprite)
	sprites_items.append(nuevo_sprite)

func quitar_item_en_indice(idx: int) -> void:
	items_en_mesa.remove_at(idx)
	tipos_en_mesa.remove_at(idx)
	sprites_items[idx].queue_free()
	sprites_items.remove_at(idx)

func intentar_armar_pizza() -> void:
	# los ingredientes crudos son los que no tienen tipo asignado (tipos_en_mesa[i] == "")
	# y no son el plato
	var ingredientes_crudos: Array[String] = []
	for i in range(items_en_mesa.size()):
		if items_en_mesa[i] != "plato" and tipos_en_mesa[i] == "":
			ingredientes_crudos.append(items_en_mesa[i])

	# primero me fijo si lo que hay en la mesa arma la pizza que pidió
	# el cliente actual; si no, reviso el resto de las recetas conocidas
	for receta in BaseDeDatos.listaOrdenes:
		if receta["tipo"] == ClienteActual.pizza and coincide_receta(ingredientes_crudos, receta["ingredientes"]):
			quitar_ingredientes(receta["ingredientes"])
			agregar_item("pizzaq1oh", receta["tipo"])
			return

	for receta in BaseDeDatos.listaOrdenes:
		if coincide_receta(ingredientes_crudos, receta["ingredientes"]):
			quitar_ingredientes(receta["ingredientes"])
			agregar_item("pizzaq1oh", receta["tipo"])
			return

func coincide_receta(disponibles: Array[String], ingredientes_receta: Array) -> bool:
	var restantes = disponibles.duplicate()
	for ingrediente in ingredientes_receta:
		if ingrediente in restantes:
			restantes.erase(ingrediente)
		else:
			return false
	return true

func quitar_ingredientes(ingredientes_receta: Array) -> void:
	for ingrediente in ingredientes_receta:
		var idx = items_en_mesa.rfind(ingrediente)
		if idx != -1:
			quitar_item_en_indice(idx)

func intentar_emplatar() -> void:
	var idx_pizza = items_en_mesa.find("pizzahecha")
	var idx_plato = items_en_mesa.find("plato")

	if idx_pizza == -1 or idx_plato == -1:
		return

	var tipo_pizza = tipos_en_mesa[idx_pizza]

	# borro primero el índice más alto para no invalidar el otro
	if idx_pizza > idx_plato:
		quitar_item_en_indice(idx_pizza)
		quitar_item_en_indice(idx_plato)
	else:
		quitar_item_en_indice(idx_plato)
		quitar_item_en_indice(idx_pizza)

	agregar_item("pizzaplato", tipo_pizza)
