extends CharacterBody2D

@onready var lucia: AnimatedSprite2D = $AnimatedSprite2D
@onready var mano: Node2D = $Mano

const SPEED = 300.0

var mano_item := ""
var plato_en_mano := false
var estaciones_cercanas: Array[Area2D] = []

func _ready() -> void:
	add_to_group("jugador")
	if mano and mano.has_method("clear"):
		mano.clear()

func _physics_process(delta: float) -> void:
	var direction := Input.get_axis("izquierda", "derecha")
	var direction2 := Input.get_axis("arriba", "abajo")

	if direction != 0:
		velocity.x = direction * SPEED
		lucia.play("caminar derecha")
		lucia.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if direction2 != 0:
		velocity.y = direction2 * SPEED
		if direction2 < 0:
			lucia.play("caminar atras")
		else:
			lucia.play("caminar frente")
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	if direction == 0 and direction2 == 0:
		lucia.play("default")

	move_and_slide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interactuar") or event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select"):
		interactuar()

func registrar_estacion(estacion: Area2D) -> void:
	if not estacion in estaciones_cercanas:
		estaciones_cercanas.append(estacion)

func desregistrar_estacion(estacion: Area2D) -> void:
	estaciones_cercanas.erase(estacion)

func interactuar() -> void:
	if estaciones_cercanas.size() > 0:
		var estacion = estaciones_cercanas[-1]
		if estacion.has_method("interactuar"):
			estacion.interactuar(self)

func agarrar_item(item: String) -> void:
	mano_item = item
	if item == "plato":
		plato_en_mano = true
	if mano and mano.has_method("set_item"):
		mano.set_item(item)

func soltar_item() -> void:
	mano_item = ""
	plato_en_mano = false
	if mano and mano.has_method("clear"):
		mano.clear()
