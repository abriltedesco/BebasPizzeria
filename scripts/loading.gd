extends Node2D
@onready var pizzaload=$pizzaload
@onready var titulo=$titulo
func _ready() -> void:
	pizzaload.play("loading")
	titulo.play("quesoderretido")
