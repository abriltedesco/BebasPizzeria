extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 4
	PedidoManager.configurar_nivel(false, 3, 100, 3, 7.0)
	escenaSiguiente = "res://escenas/niveles/nivel5.tscn"
	StockManager.inicializar_stock()
	super._ready()

	
