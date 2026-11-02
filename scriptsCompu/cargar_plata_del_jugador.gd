extends Node
@onready var labelDineroJugador = $"../Control/Panel/dineroJugador"
@export var dineroJugador: float = 1000.0 

func _ready() -> void:
	pass

func _process(delta: float) -> void:
		labelDineroJugador.text = str(dineroJugador)
