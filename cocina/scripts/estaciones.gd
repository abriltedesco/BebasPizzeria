extends Area2D
class_name Estaciones

func _ready() -> void:
	add_to_group("estaciones")

func verMesas() -> Array[CollisionShape2D]:
	var mesasActivas: Array[CollisionShape2D] = []
	for mesa in get_children():
		if mesa is CollisionShape2D and not mesa.disabled:
			mesasActivas.append(mesa)
	return mesasActivas

func distanciaAMesa(mesa: CollisionShape2D, punto: Vector2) -> float:
	var rect = mesa.shape as RectangleShape2D
	if rect == null:
		return mesa.global_position.distance_to(punto)
	var local: Vector2 = mesa.global_transform.affine_inverse() * punto
	var mitad: Vector2 = rect.size / 2.0
	var cerca := Vector2(clampf(local.x, -mitad.x, mitad.x), clampf(local.y, -mitad.y, mitad.y))
	return (mesa.global_transform * cerca).distance_to(punto)

func mesaMasCercana(punto: Vector2) -> CollisionShape2D:
	var masCercana: CollisionShape2D = null
	var menorDistancia = INF
	for mesa in verMesas():
		var d = distanciaAMesa(mesa, punto)
		if d < menorDistancia:
			menorDistancia = d
			masCercana = mesa
	return masCercana

func distancia_a(punto: Vector2) -> float:
	var mesa=mesaMasCercana(punto)
	return INF if mesa == null else distanciaAMesa(mesa, punto)

func interactuar(_jugador: CharacterBody2D) -> void:
	pass
