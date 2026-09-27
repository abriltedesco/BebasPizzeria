extends Node

var nombre
var pizza
var dificultad
var listaOrden

var indice= 0
func obtenerIngrediente()-> String:
	if indice<listaOrden.size():
		var ingrediente= listaOrden[indice]
		indice+= 1
		return ingrediente
	return "" 
func reiniciarIndice()->void:
	indice= 0
