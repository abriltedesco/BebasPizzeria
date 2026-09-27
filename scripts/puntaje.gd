extends Node
signal cambio_puntaje(dinero:int, completados: int, fallidos: int)

var dinero= 0
var pedidos_completados= 0
var pedidos_fallidos= 0
const premioDificultad={
	"facil": 10,
	"media": 20,
	"dificil": 35}
func sumarPedidoCompletado(dificultad: String = "facil") -> void:
	pedidos_completados+= 1
	dinero+= premioDificultad.get(dificultad, 10)
	cambio_puntaje.emit(dinero,pedidos_completados,pedidos_fallidos)

func sumarPedidoFallido() -> void:
	pedidos_fallidos+=1
	dinero-= 10
	cambio_puntaje.emit(dinero,pedidos_completados,pedidos_fallidos)
