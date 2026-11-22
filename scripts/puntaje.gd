extends Node
signal cambio_puntaje(dinero:int, completados: int, fallidos: int)

var dinero= 0
var pedidos_completados= 0
var pedidos_fallidos= 0
var dineroInicioNivel = 0
var completadosInicioNivel = 0
var fallidosInicioNivel = 0

const premioDificultad={
	"facil": 10,
	"media": 20,
	"dificil": 30
}
	
var reproductorCompra: AudioStreamPlayer

func _ready() -> void:
	reproductorCompra = AudioStreamPlayer.new()
	reproductorCompra.stream = load("res://assets/sonidos/Money _ Cash Sound Effect 🔊  Free Download  Meme, Gaming, Edit Use - Epic Sound Effects.mp3")
	add_child(reproductorCompra)

func reproducirSonidoCompra() -> void:
	reproductorCompra.play()

func sumarPedidoCompletado(dificultad: String = "facil") -> void:
	pedidos_completados+= 1
	dinero+= premioDificultad.get(dificultad, 10)
	cambio_puntaje.emit(dinero,pedidos_completados,pedidos_fallidos)
	
func sumarPedidoFallido() -> void:
	pedidos_fallidos+=1
	cambio_puntaje.emit(dinero,pedidos_completados,pedidos_fallidos)
	
func sumarPropina(monto:int=100) -> void:
	dinero+=monto
	cambio_puntaje.emit(dinero,pedidos_completados,pedidos_fallidos)
	
func guardarInicioNivel() -> void:
	dineroInicioNivel = dinero
	completadosInicioNivel = pedidos_completados
	fallidosInicioNivel = pedidos_fallidos
	
func restaurarInicioNivel() -> void:
	dinero = dineroInicioNivel
	pedidos_completados = completadosInicioNivel
	pedidos_fallidos = fallidosInicioNivel
	cambio_puntaje.emit(dinero, pedidos_completados, pedidos_fallidos)
