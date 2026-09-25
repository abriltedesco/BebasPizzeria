extends Estaciones
class_name mesa

var items_en_mesa: Array[String] = []
var sprites_items: Array[Sprite2D] = []

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item != "":
		var item_mano: String = jugador.mano_item
		jugador.soltar_item()
		
		items_en_mesa.append(item_mano)
		
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
		elif item_mano in ["pizzahecha", "food16"]:
			nuevo_sprite.scale = Vector2(0.8, 0.8)
			nuevo_sprite.texture = load("res://cocina/assets/comida/pizzacocinada.png")
			
		if has_node("CollisionShape2D"):
			nuevo_sprite.position = $CollisionShape2D.position
		else:
			nuevo_sprite.position = Vector2.ZERO
			
		add_child(nuevo_sprite)
		sprites_items.append(nuevo_sprite)
		
		if "tomate" in items_en_mesa and "queso" in items_en_mesa and "masa" in items_en_mesa:
			var indices_a_borrar: Array[int] = []
			for idx in range(items_en_mesa.size() - 1, -1, -1):
				var it = items_en_mesa[idx]
				if it == "tomate" or it == "queso" or it == "masa":
					items_en_mesa.remove_at(idx)
					var sp = sprites_items[idx]
					sp.queue_free()
					sprites_items.remove_at(idx)
					
			var item_creado = "pizzaq1oh"
			var path_pizza = "res://cocina/assets/comida/pizzaqoh.png"
			
			if "plato" in items_en_mesa:
				for idx in range(items_en_mesa.size() - 1, -1, -1):
					if items_en_mesa[idx] == "plato":
						items_en_mesa.remove_at(idx)
						var sp = sprites_items[idx]
						sp.queue_free()
						sprites_items.remove_at(idx)
				item_creado = "pizzaplato"
				path_pizza = "res://cocina/assets/comida/pizzaplato.png"
				
			items_en_mesa.append(item_creado)
			
			var sp_pizza = Sprite2D.new()
			sp_pizza.texture_filter = TEXTURE_FILTER_NEAREST
			if item_creado == "pizzaplato":
				sp_pizza.scale = Vector2(0.4, 0.4)
			else:
				sp_pizza.scale = Vector2(0.8, 0.8)
			sp_pizza.texture = load(path_pizza)
			
			if has_node("CollisionShape2D"):
				sp_pizza.position = $CollisionShape2D.position
			else:
				sp_pizza.position = Vector2.ZERO
				
			add_child(sp_pizza)
			sprites_items.append(sp_pizza)
	else:
		if items_en_mesa.size() > 0:
			var item_tomado = items_en_mesa.pop_back()
			var sp_tomado = sprites_items.pop_back()
			sp_tomado.queue_free()
			jugador.agarrar_item(item_tomado)
