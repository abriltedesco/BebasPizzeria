extends Node2D


var instMostradas= false
var escena = null

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func mostrar_instrucciones() -> void:
	if instMostradas:
		return
	instMostradas= true
	
	var dialogo = load("res://dialogue/instrucciones.dialogue")
	escena = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena)
	escena.start(dialogo, "start", [self])
	await escena.tree_exited

func _on_visibility_changed() -> void:
	if escena:
		escena.visible= visible

func _process(delta: float) -> void:
	pass
