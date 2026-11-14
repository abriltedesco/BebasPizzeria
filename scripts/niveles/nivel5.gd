extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 5
	PedidoManager.configurar_nivel(false, 4, 100, 3, 5.0)
	escenaSiguiente = "res://escenas/interfaces/Inicio.tscn" #esto desp hay q cambiarlo con la escena final
	super._ready()

	
