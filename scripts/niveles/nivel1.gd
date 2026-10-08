extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 1
	PedidoManager.configurar_nivel(true, 1, 100) 
	escenaSiguiente = "res://escenas/niveles/nivel2.tscn"
	super._ready()
