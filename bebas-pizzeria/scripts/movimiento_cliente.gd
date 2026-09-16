extends Node
@onready var sprite = $"../Icon"
signal movimiento_terminado 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	movimiento()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func movimiento():
	var tween = create_tween()
	var posicionFinal = Vector2(sprite.position.x - 500, sprite.position.y)
	tween.tween_property(sprite, "position", posicionFinal, 2) 
	await tween.finished
	
	movimiento_terminado.emit()
