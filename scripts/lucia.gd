extends CharacterBody2D

@onready var lucia= $AnimatedSprite2D
@onready var mano= $Mano
@onready var cuerpo= $CollisionShape2D
@export var distancia= 70

const SPEED= 300

var mano_item= ""
var mano_item_tipo=""
var plato_en_mano = false

func _ready() -> void:
	add_to_group("jugador")
	if mano and mano.has_method("clear"):
		mano.clear()

func _physics_process(_delta: float) -> void:
	var direction= Input.get_axis("izquierda", "derecha")
	var direction2= Input.get_axis("arriba", "abajo")

	if direction!= 0:
		velocity.x= direction*SPEED
		lucia.play("caminar derecha")
		lucia.flip_h= direction<0
	else:
		velocity.x= move_toward(velocity.x, 0, SPEED)

	if direction2!= 0:
		velocity.y= direction2*SPEED
		if direction2<0:
			lucia.play("caminar atras")
		else:
			lucia.play("caminar frente")
	else:
		velocity.y= move_toward(velocity.y, 0, SPEED)

	if direction== 0 and direction2== 0:
		lucia.play("default")

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interactuar") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		interactuar()


func interactuar() -> void:
	var origen: Vector2= cuerpo.global_position
	var estacionCercana: Estaciones=null
	var menorDistancia=distancia
	for nodo in get_tree().get_nodes_in_group("estaciones"):
		var d= nodo.distancia_a(origen)
		if d<= menorDistancia:
			menorDistancia= d
			estacionCercana= nodo
	if estacionCercana:
		estacionCercana.interactuar(self)
func agarrar_item(item: String, tipo: String ="") -> void:
	mano_item= item
	mano_item_tipo=tipo
	if item=="plato" or item=="pizzaplato":
		plato_en_mano=true
	else:
		plato_en_mano=false
	if mano and mano.has_method("set_item"):
		mano.set_item(item)

func soltar_item() -> void:
	mano_item=""
	mano_item_tipo=""
	plato_en_mano=false
	if mano and mano.has_method("clear"):
		mano.clear()
