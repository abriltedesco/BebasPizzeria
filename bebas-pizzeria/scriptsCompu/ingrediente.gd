extends VBoxContainer

signal cantidadCambiada

var datos: Dictionary
var stock: int = 0

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
	stock = datos["stock"]
	nombreLabel.text = datos["nombre"]
	precioLabel.text = "$" + str(datos["valor"])
	actualizarDatos()

func sumarStock() -> void:
	stock += 1
	actualizarDatos()

func restarStock() -> void:
	if stock > datos["stock"]:
		stock -= 1
		actualizarDatos()

func unidadesAcomprar() -> int:
	return stock - datos["stock"]

func calcularCosto() -> int:
	return unidadesAcomprar() * datos["valor"]

func confirmarStock() -> void:
	datos["stock"] =stock
	actualizarDatos()

func actualizarDatos() -> void:
	cantidadLabel.text = str(stock)
	cantidadCambiada.emit()
