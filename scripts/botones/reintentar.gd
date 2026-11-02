extends Button
var num = ProgresoManager.nivel_actual

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_pressed() -> void:
	var escenaNivel = "res://escenas/niveles/nivel" + str(num) + ".tscn"
	get_tree().change_scene_to_file(escenaNivel)
