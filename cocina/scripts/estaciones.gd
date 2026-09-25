extends Area2D
class_name Estaciones

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("registrar_estacion"):
		body.registrar_estacion(self)

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("desregistrar_estacion"):
		body.desregistrar_estacion(self)

func interactuar(jugador: CharacterBody2D) -> void:
	pass
