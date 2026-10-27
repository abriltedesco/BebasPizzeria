extends Node2D

var instMostradas = false
var escena = null
var overlay: TutorialOverlay = null

func _ready() -> void:
	visibility_changed.connect(_on_visibility_changed)

func mostrar_instrucciones() -> void:
	if ProgresoManager.nivel_actual != 1:   # el tutorial ACTUAL es solo del nivel 1
		return
	if instMostradas:return
	instMostradas = true

	var dialogo = load("res://dialogue/instrucciones.dialogue")
	escena = load("res://addons/dialogue_manager/example_balloon/example_balloon.tscn").instantiate()
	add_child(escena)
	escena.start(dialogo, "start", [self])
	await escena.tree_exited
	resaltar("")

func _on_visibility_changed() -> void:
	if escena:
		escena.visible = visible
	if overlay:
		overlay.visible = visible and overlay.activo
		
func resaltar(nombre: String, texto: String = "", margen: float = 10.0) -> void:
	if nombre == "":
		if overlay:
			overlay.ocultar()
		return
		
	var nodo = get_node_or_null(nombre)
		
	if overlay == null:
		overlay = TutorialOverlay.new()
		add_child(overlay)
	overlay.resaltar(rectPantallaDe(nodo, margen), texto)

func rectPantallaDe(nodo: Node, margen: float) -> Rect2:
	var resultado := Rect2()
	var primero := true
	
	for hijo in nodo.get_children():
		if !(hijo is CollisionShape2D):
			continue
			
		var mitad = Vector2.ZERO
		if hijo.shape is RectangleShape2D:
			mitad = hijo.shape.size / 2.0
		elif hijo.shape is CircleShape2D:
			mitad = Vector2(hijo.shape.radius, hijo.shape.radius)
		else:
			continue
		var r = Rect2(hijo.get_global_transform_with_canvas() * (-mitad), Vector2.ZERO).expand(hijo.get_global_transform_with_canvas() * mitad)
		resultado = r if primero else resultado.merge(r)
		primero = false
	return resultado.grow(margen)
	
func esperarMano(item: String) -> void:
	while $lucia.mano_item != item:
		await get_tree().process_frame

func esperarManoVacia() -> void:
	while $lucia.mano_item != "":
		await get_tree().process_frame

func esperarHornoOcupado() -> void:
	while !$Horno.hayPizzaCocinandose():
		await get_tree().process_frame
