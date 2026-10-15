extends Node

const rutaDialPedido = "res://dialogue/pedido_cliente.dialogue"
const rutaGlobo = "res://addons/dialogue_manager/example_balloon/example_balloon.tscn"

func mostrar_dialogo(nodo_padre: Node, nodo_contexto: Node, titulo: String) -> void:
	var dialogo = load(rutaDialPedido)
	var escena_globo = load(rutaGlobo).instantiate()
	nodo_padre.add_child(escena_globo)
	escena_globo.start(dialogo, titulo, [nodo_contexto])
	await escena_globo.tree_exited

func configurar_cliente_actual(cliente_nodo: Node) -> void:
	ClienteActual.nombre = cliente_nodo.nombre_cliente
	ClienteActual.pizza = cliente_nodo.orden_elegida["tipo"]
	ClienteActual.dificultad = cliente_nodo.dificultad_cliente
	ClienteActual.listaOrden = cliente_nodo.orden_elegida["ingredientes"]
	ClienteActual.reiniciarIndice()
