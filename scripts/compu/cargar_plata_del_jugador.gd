extends Node

@onready var labelDineroJugador = $"../Control/Panel/dineroJugador"

func _ready() -> void:	
	Puntaje.cambio_puntaje.connect(_on_cambio_puntaje)
	labelDineroJugador.text = "$" + str(Puntaje.dinero)

func _on_cambio_puntaje(dinero_actual: int, _completados: int, _fallidos: int) -> void:
	if labelDineroJugador:
		labelDineroJugador.text = "$" + str(dinero_actual)
