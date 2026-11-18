extends Node

const RECETARIO_ESC = preload("res://escenas/interfaces/recetario.tscn")
var recetario_abierto: Node = null

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("abrir_recetario"):
		get_viewport().set_input_as_handled()
		alternar_recetario()

func alternar_recetario() -> void:
	if is_instance_valid(recetario_abierto):
		recetario_abierto._on_volver_pressed()
	elif not get_tree().paused:
		abrir_recetario()

func abrir_recetario() -> void:
	if is_instance_valid(recetario_abierto):
		return
	recetario_abierto = RECETARIO_ESC.instantiate()
	recetario_abierto.process_mode = Node.PROCESS_MODE_ALWAYS
	recetario_abierto.estaCerrado.connect(_on_recetario_cerrado)
	
	get_parent().add_child(recetario_abierto)
	get_tree().paused = true

func _on_recetario_cerrado() -> void:
	recetario_abierto = null
	get_tree().paused = false
