extends Node

signal movimiento_terminado 
signal salida_terminada

@onready var animacion= $"../AnimatedSprite2D"

var ruta= null

func _ready() -> void:
	animacion.play("izq")

func configurar_posiciones(_aparicion: Vector2, _mostrador: Vector2) -> void:
	pass

func configurar_ruta(p_ruta: Path2D) -> void:
	ruta= p_ruta
	if ruta and ruta.curve:
		animacion.position= ruta.curve.get_point_position(0)

func movimientoEntrar() -> void:
	if ruta== null or ruta.curve== null:
		animacion.flip_h= false
		var tween= create_tween()
		var posicionFinal= Vector2(1100 - 500, 290)
		tween.tween_property(animacion, "position", posicionFinal, 2) 
		await tween.finished
		_al_terminar_entrar()
		return

	animacion.flip_h= false
	animacion.play("izq")
	
	var tween= create_tween()
	var pos_final= ruta.curve.get_point_position(2)
	tween.tween_property(animacion, "position", pos_final, 3)
	await get_tree().create_timer(1.5).timeout
	animacion.play("frente")
	
	await tween.finished
	_al_terminar_entrar()

func _al_terminar_entrar() -> void:
	movimiento_terminado.emit()

func movimientoAvanzar_fallback():
	pass

func irse() -> void:
	animacion.flip_h= true
	animacion.play("izq")
	
	var tween= create_tween()
	var pos_inicio= Vector2(1100, 290)
	if ruta and ruta.curve:
		pos_inicio= ruta.curve.get_point_position(0)
		
	tween.tween_property(animacion, "position", pos_inicio, 3)
	await tween.finished
	salida_terminada.emit()
