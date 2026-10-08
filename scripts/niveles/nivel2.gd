extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 2
	PedidoManager.configurar_nivel(false, 2, 100) 
	escenaSiguiente = "res://escenas/nivel_2.tscn"
	super._ready()
	
