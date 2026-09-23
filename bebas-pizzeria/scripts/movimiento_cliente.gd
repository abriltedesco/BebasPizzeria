extends Node
signal movimiento_terminado 
@onready var animacion = $"../AnimatedSprite2D"

func _ready() -> void:
	animacion.play("izq")
	movimientoEntrar()

func movimientoEntrar():
	var tween = create_tween()
	var posicionFinal = Vector2(animacion.position.x - 500, animacion.position.y)
	tween.tween_property(animacion, "position", posicionFinal, 2) 
	await tween.finished
	movimientoAvanzar()
	
func movimientoAvanzar():
	animacion.play("frente")
	var tween = create_tween()
	var posicionFinal = Vector2(animacion.position.x, animacion.position.y + 80)
	tween.tween_property(animacion, "position", posicionFinal, 2) 
	await tween.finished
	movimiento_terminado.emit()
