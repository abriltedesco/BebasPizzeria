extends Estaciones
class_name horno

class Hornalla:
	var forma: CollisionShape2D
	var spriteP: TextureRect
	var barra: AnimatedSprite2D
	var senial: Sprite2D
	var activa := false
	var tiempo := 0.0
	var pizza := ""
	var tipo := ""
	var ingredientes: Array = []

const CANTHORNALLAS := 3
const coccion := 4.0
const quemada := 8.0
@export var offsetBarra = Vector2(0, -32)
@export var offsetSenial = Vector2(0, -56)
var barraScene = preload("res://escenas/barra.tscn")
var hornallas: Array[Hornalla] = []

func _ready() -> void:
	super._ready()
	
	var barraBase: AnimatedSprite2D
	if has_node("Barra"):
		barraBase = $Barra
	else:
		barraBase = barraScene.instantiate()
		add_child(barraBase)
		
	var senialBase: Sprite2D
	if has_node("Señal"):
		senialBase = $Señal
	else:
		senialBase = Sprite2D.new()
		senialBase.name = "Señal"
		senialBase.texture = preload("res://assets/señal.png")
		add_child(senialBase)
	senialBase.scale = Vector2(0.4, 0.4)
	
	for i in range(CANTHORNALLAS):
		var hornalla := Hornalla.new()
		hornalla.forma = get_node("Hornalla%d" % (i + 1))
		hornalla.spriteP = get_node_or_null("HornallaP%d" % (i + 1))
		if i == 0:
			hornalla.barra = barraBase
			hornalla.senial = senialBase
		else:
			hornalla.barra = barraBase.duplicate() 
			add_child(hornalla.barra)
			hornalla.senial = senialBase.duplicate()
			add_child(hornalla.senial)
		hornalla.barra.position = hornalla.forma.position + offsetBarra
		hornalla.senial.position = hornalla.forma.position + offsetSenial
		hornalla.barra.visible = false
		hornalla.senial.visible = false
		if hornalla.spriteP:
			hornalla.spriteP.visible = false
		hornallas.append(hornalla)

func _process(delta: float) -> void:
	for hornalla in hornallas:
		if hornalla.activa:
			hornalla.tiempo += delta
			hornalla.barra.visible = true
			var progreso = minf(hornalla.tiempo / coccion, 1.0)
			hornalla.barra.frame = int(progreso * 10)
			
			if hornalla.tiempo >= quemada:
				hornalla.senial.visible = true
				hornalla.senial.modulate.a = 0.3 + abs(sin(Time.get_ticks_msec() * 0.008)) * 0.7
			else:
				hornalla.senial.visible = false

# distancia al borde de la forma (0 si el jugador está adentro)
func distanciaAForma(forma: CollisionShape2D, origen: Vector2) -> float:
	var rect = forma.shape as RectangleShape2D
	if rect == null:
		return forma.global_position.distance_to(origen)
	var local = forma.to_local(origen)
	var mitad = rect.size / 2.0
	var dx := maxf(absf(local.x) - mitad.x, 0.0)
	var dy := maxf(absf(local.y) - mitad.y, 0.0)
	return Vector2(dx, dy).length()

# el jugador usa esta función para decidir con qué estación interactúa
func distancia_a(origen: Vector2) -> float:
	var menor = INF
	for hornalla in hornallas:
		menor = minf(menor, distanciaAForma(hornalla.forma, origen))
	return menor

func hornallaMasCercana(origen: Vector2) -> Hornalla:
	var mejor: Hornalla = null
	var menor = INF
	for hornalla in hornallas:
		var distancia = distanciaAForma(hornalla.forma, origen)
		if distancia < menor:
			menor = distancia
			mejor = hornalla
	return mejor

func vaciarHornalla(h: Hornalla) -> void:
	h.activa = false
	h.pizza = ""
	h.tipo = ""
	h.tiempo = 0.0
	h.ingredientes.clear()
	h.barra.visible = false
	h.senial.visible = false
	if h.spriteP:
		h.spriteP.visible = false

func interactuar(jugador: CharacterBody2D) -> void:
	var origen: Vector2 = jugador.cuerpo.global_position if "cuerpo" in jugador else jugador.global_position
	var hornalla = hornallaMasCercana(origen)
	if hornalla == null:
		return
		
	if jugador.mano_item == "pizzacruda":
		if !hornalla.activa and hornalla.pizza == "":
			hornalla.pizza = jugador.mano_item
			hornalla.tipo = jugador.mano_item_tipo
			if "mano_item_ingredientes" in jugador:
				hornalla.ingredientes = jugador.mano_item_ingredientes.duplicate()
				
			hornalla.activa = true
			hornalla.tiempo = 0.0
			hornalla.barra.visible = true
			hornalla.barra.frame = 0
			hornalla.senial.visible = false
			if hornalla.spriteP:
				hornalla.spriteP.visible = true
			jugador.soltar_item()
			
	elif jugador.mano_item == "":
		if hornalla.pizza != "":
			var resultado := "pizzahecha"
			if hornalla.tiempo >= quemada:
				resultado = "pizzaquemada"

			var tipoResultado = hornalla.tipo
			var ingredientesResultado = hornalla.ingredientes.duplicate()
			vaciarHornalla(hornalla)
			jugador.agarrar_item(resultado, tipoResultado)

			if "mano_item_ingredientes" in jugador:
				jugador.mano_item_ingredientes = ingredientesResultado
