extends Node

var nombre: String
var pizza: String
var dificultad: String
var listaOrden : Array

var indice = 0
func obtenerIngrediente() -> String:
	if indice < listaOrden.size():
		var ingrediente = listaOrden[indice]
		indice += 1
		return ingrediente
	return "" 
func reiniciarIndice() -> void:
	indice= 0
