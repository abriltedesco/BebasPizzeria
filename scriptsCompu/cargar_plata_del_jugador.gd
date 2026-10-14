extends Node
@onready var labelDineroJugador = $"../Control/Panel/dineroJugador"
@export var dineroJugador: float = 1000.0 
#el 1000 es un valor de prueba, dsp hay q conectarlo con el valor del gameplay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
		labelDineroJugador.text = str(dineroJugador)
