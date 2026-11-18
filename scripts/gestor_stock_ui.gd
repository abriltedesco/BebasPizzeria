extends Node

const LABELS_STOCK = {
	"Queso": ["queso", "QUESO"],
	"Tomate": ["tomate", "TOMATE"],
	"Cebolla": ["cebolla", "CEBOLLA"],
	"Jamón": ["jamon", "JAMON"],
	"Rucula": ["rucula", "RUCULA"],
	"Huevo": ["huevo", "HUEVO"],
	"Aceitunas": ["aceitunas", "ACEITUNAS"],
	"Papas": ["papas", "PAPAS"],
	"Cheddar": ["cheddar", "CHEDDAR"],
	"Roquefort": ["roquefort", "ROQUEFORT"],
	"Parmesano": ["parmesano", "PARMESANO"],
	"Aceite": ["aceite", "ACEITE"],
	"Pepperoni": ["pepperoni", "PEPPERONI"],
	"harina": ["harina", "HARINA"]
}

func _ready() -> void:
	StockManager.stock_actualizado.connect(actualizar_todos)
	actualizar_todos()

func actualizar_todos() -> void:
	var cocina = get_parent()
	var mostrar_stock := ProgresoManager.nivel_actual >= 4
	
	for nombre_nodo in LABELS_STOCK:
		var estacion = cocina.get_node_or_null(nombre_nodo)
		if estacion == null:
			continue
		var lbl: Label = estacion.get_node_or_null("Label")
		if lbl == null:
			lbl = estacion.get_node_or_null("Label2")
		if lbl == null:
			continue
			
		var clave_bd: String = LABELS_STOCK[nombre_nodo][0]
		var texto_base: String = LABELS_STOCK[nombre_nodo][1]
		
		if mostrar_stock:
			var cant: int = StockManager.obtener_stock(clave_bd)
			lbl.text = "%s: %d" % [texto_base, cant]
			if cant <= 1:
				lbl.add_theme_color_override("font_color", Color(1, 0.25, 0.25))
			else:
				lbl.remove_theme_color_override("font_color")
		else:
			lbl.text = texto_base
			lbl.remove_theme_color_override("font_color")
