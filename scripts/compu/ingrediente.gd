extends HBoxContainer

signal cantidadCambiada

var datos: Dictionary
var stock: int = 0
var base: int = 0

@onready var nombreLabel = %nombreIngrediente
@onready var precioLabel = %precioIngrediente
@onready var cantidadLabel = %cantidadIngrediente
@onready var botonRestar= %restarUnidad
@onready var botonSumar= %sumarUnidad

func _ready() -> void:
	botonRestar.pressed.connect(restarStock)
	botonSumar.pressed.connect(sumarStock)

func configurar(datosDiccionario: Dictionary) -> void:
	datos = datosDiccionario
	nombreLabel.text = datos["nombre"]
	precioLabel.text = "$" + str(datos["valor"])
	base = StockManager.obtener_stock(datos["nombre"])
	stock = base
	actualizarDatos()

func sumarStock() -> void:
	stock += 1
	actualizarDatos()

func restarStock() -> void:
	if stock > base:
		stock -= 1
		actualizarDatos()

func unidadesAcomprar() -> int:
	return stock - base

func calcularCosto() -> int:
	return unidadesAcomprar() * int(datos["valor"])

func confirmarStock() -> void:
	var cantidad_comprada = unidadesAcomprar()
	if cantidad_comprada > 0:
		StockManager.agregar_stock(datos["nombre"], cantidad_comprada)
	base = StockManager.obtener_stock(datos["nombre"])
	stock = base
	actualizarDatos()
	
func actualizarDatos() -> void:
	cantidadLabel.text = str(stock)
	cantidadCambiada.emit()
