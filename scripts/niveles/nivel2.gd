extends NivelBase

func _ready() -> void:
	ProgresoManager.nivel_actual = 2
	PedidoManager.configurar_nivel(false, 2, 100, 3, 10.0)
	escenaSiguiente = "res://escenas/niveles/nivel3.tscn"
	StockManager.inicializar_stock()
	super._ready()
	
