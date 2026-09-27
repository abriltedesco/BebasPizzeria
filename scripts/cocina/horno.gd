extends Estaciones
class_name horno

var barra_scene= preload("res://escenas/barra.tscn")
var barra_node: AnimatedSprite2D
var senial: Sprite2D
var horno_activo= false
var tiempo_horno= 0.0
var pizza_en_horno=""
var tipo_en_horno=""

const coccion= 4.0
const quemada= 8.0

func _ready() -> void:
	super._ready()
	if has_node("Barra"):
		barra_node= $Barra
	else:
		barra_node= barra_scene.instantiate()
		add_child(barra_node)
		
	if has_node("Señal"):
		senial= $Señal
	else:
		senial= Sprite2D.new()
		senial.name= "Señal"
		senial.texture= preload("res://assets/señal.png")
		add_child(senial)
		
	senial.scale= Vector2(0.4, 0.4)
	
	if has_node("CollisionShape2D"):
		var pos_col: Vector2= $CollisionShape2D.position
		barra_node.position= pos_col+Vector2(0, -32)
		senial.position= pos_col+Vector2(0, -56)
	else:
		barra_node.position= Vector2(0, -32)
		senial.position= Vector2(0, -56)
		
	barra_node.visible= false
	senial.visible= false

func _process(delta: float) -> void:
	if horno_activo:
		tiempo_horno+= delta
		barra_node.visible= true
		var progress= min(tiempo_horno/coccion, 1.0)
		barra_node.frame= int(progress * 10)
		
		if tiempo_horno>= quemada:
			senial.visible=true
			senial.modulate.a= 0.3+abs(sin(Time.get_ticks_msec() * 0.008)) * 0.7
		else:
			senial.visible=false

func interactuar(jugador: CharacterBody2D) -> void:
	if jugador.mano_item== "pizzacruda":
		if not horno_activo and pizza_en_horno== "":
			pizza_en_horno= jugador.mano_item
			tipo_en_horno= jugador.mano_item_tipo
			horno_activo= true
			tiempo_horno= 0.0
			barra_node.visible= true
			barra_node.frame= 0
			senial.visible= false
			jugador.soltar_item()
			
	elif jugador.mano_item== "":
		if pizza_en_horno!= "":
			var resultado= "pizzahecha"
			if tiempo_horno>= quemada:
				resultado= "pizzaquemada"
				
			var tipo_resultado= tipo_en_horno
			horno_activo= false
			pizza_en_horno= ""
			tipo_en_horno= ""
			barra_node.visible= false
			senial.visible= false
			tiempo_horno= 0.0
			jugador.agarrar_item(resultado, tipo_resultado)
