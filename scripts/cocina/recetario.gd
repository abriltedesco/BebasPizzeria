extends Node2D
signal estaCerrado
@onready var sprite:Sprite2D=$spriteActual
@onready var botonInv1:Button=$supercompleta
@onready var botonInv2:Button=$"bomba frita"
@onready var botonVolverRec:Button=$"volverRecetario"
func _ready() -> void:
	botonVolverRec.visible=false
	botonInv1.visible=true
	botonInv2.visible=true
	sprite.texture=load("res://assets/recetario/idle.png")
func _on_queso_pressed() -> void:
	sprite.texture=load("res://assets/recetario/queso.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_fugazzeta_pressed() -> void:
	sprite.texture=load("res://assets/recetario/fugazzeta.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_jamon_pressed() -> void:
	sprite.texture=load("res://assets/recetario/jamon.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_supercompleta_pressed() -> void:
	sprite.texture=load("res://assets/recetario/superCompleta.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_bomba_frita_pressed() -> void:
	sprite.texture=load("res://assets/recetario/bombaFrita.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_margarita_pressed() -> void:
	sprite.texture=load("res://assets/recetario/margarita.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_jamon_y_morrones_pressed() -> void:
	sprite.texture=load("res://assets/recetario/jamonymorrones.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_rucula_y_crudo_pressed() -> void:
	sprite.texture=load("res://assets/recetario/ruculaCrudo.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_pepperoni_pressed() -> void:
	sprite.texture=load("res://assets/recetario/pepperoni.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_albahaca_y_queso_pressed() -> void:
	sprite.texture=load("res://assets/recetario/albahacaQueso.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_cuatro_quesos_pressed() -> void:
	sprite.texture=load("res://assets/recetario/cuatroQuesos.png")
	botonVolverRec.visible=true
	botonInv1.visible=false
	botonInv2.visible=false
func _on_volver_pressed() -> void:
	estaCerrado.emit()
	queue_free()
func _on_volver_recetario_pressed() -> void:
	_ready()
