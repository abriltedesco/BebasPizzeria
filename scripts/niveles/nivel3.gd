extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 3
	PedidoManager.configurar_nivel(false, 3, 100, 10, 8.0)
	escenaSiguiente = "res://escenas/niveles/nivel3.tscn"
	super._ready()
	
