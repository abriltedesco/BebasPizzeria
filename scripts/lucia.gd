extends CharacterBody2D

@onready var lucia= $AnimatedSprite2D
@onready var mano= $Mano
@onready var cuerpo= $CollisionShape2D
@export var distancia= 70
var mano_item_ingredientes: Array = []
var mano_item_coccion: float = 0.0

const SPEED= 300

var mano_item= ""
var mano_item_tipo=""
var plato_en_mano = false
var e_presionada_antes = false

func _ready() -> void:
	add_to_group("jugador")
	if mano and mano.has_method("clear"):
		mano.clear()

func _physics_process(_delta: float) -> void:
	var e_ahora := Input.is_key_pressed(KEY_E)
	if is_visible_in_tree():
		if Input.is_action_just_pressed("interactuar") or (e_ahora and !e_presionada_antes):
			interactuar()
	e_presionada_antes = e_ahora
	
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
		mano.set_item(item, tipo)

func soltar_item() -> void:
	mano_item=""
	mano_item_tipo=""
	plato_en_mano=false
	if mano and mano.has_method("clear"):
		mano.clear()
	mano_item_ingredientes = []
	mano_item_coccion = 0.0
