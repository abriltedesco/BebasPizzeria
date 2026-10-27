extends Node2D
signal estaCerrado
@onready var sprite:Sprite2D=$spriteActual
func _ready() -> void:
	sprite.texture=load("res://assets/recetario/idle.png")
func _on_queso_pressed() -> void:
	sprite.texture=load("res://assets/recetario/queso.png")
func _on_volver_pressed() -> void:
	estaCerrado.emit()
	queue_free()
