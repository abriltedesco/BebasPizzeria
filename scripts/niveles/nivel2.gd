extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 2
	PedidoManager.configurar_nivel(false, 2, 100, 10) 
	escenaSiguiente = "res://escenas/niveles/nivel3.tscn"
	super._ready()
	
