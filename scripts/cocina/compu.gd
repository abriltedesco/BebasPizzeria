extends Area2D

@onready var sprite_compu = $sprite
@onready var colision = $CollisionShape2D

func _ready() -> void:
	if ControladorIngredientes.esta_desbloqueado("compu"):
		sprite_compu.material = null 
		colision.set_deferred("disabled", false)
	else:
		colision.set_deferred("disabled", true)

## desp aca deberíamos agregar q cuando interactue la lleve a lucia a la pantalla de la compuu
