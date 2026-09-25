extends Node2D

@onready var sprite: Sprite2D = $Sprite2D
var item := ""

func _ready() -> void:
	visible = false
	if sprite == null and has_node("Sprite2D"):
		sprite = $Sprite2D

func set_item(nombre: String) -> void:
	item = nombre
	visible = nombre != ""
	if nombre == "":
		return
	if sprite == null and has_node("Sprite2D"):
		sprite = $Sprite2D
	if sprite:
		sprite.visible = true
		sprite.scale = Vector2(0.8, 0.8)
		match nombre:
			"queso":
				sprite.texture = load("res://cocina/assets/comida/queso.png")
			"tomate":
				sprite.texture = load("res://cocina/assets/comida/tomate.png")
			"masa":
				sprite.texture = load("res://cocina/assets/comida/masa.png")
			"plato":
				sprite.texture = load("res://cocina/assets/comida/plato.png")
				sprite.scale = Vector2(0.4, 0.4)
			"pizzaq1oh", "pizzaqoh":
				sprite.texture = load("res://cocina/assets/comida/pizzaqoh.png")
			"pizzahecha", "food16":
				sprite.texture = load("res://cocina/assets/comida/pizzacocinada.png")
			_:
				sprite.visible = false
				visible = false

func clear() -> void:
	set_item("")
