extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 3
	PedidoManager.configurar_nivel(false, 3, 100, 4, 8.0)
	escenaSiguiente = "res://escenas/niveles/nivel4.tscn"
	StockManager.inicializar_stock()
	super._ready()

	
