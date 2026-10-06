extends Node2D
@onready var pizzaload=$pizzaload

func _ready() -> void:
	pizzaload.play("loading")
