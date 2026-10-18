extends CanvasLayer
class_name TutorialOverlay

const SHADER = preload("res://assets/shaders/spotlight.gdshader")
const oscuridadMax := 0.75

var fondo: ColorRect
var materialSpot: ShaderMaterial
var etiqueta: Label
var rectActual := Rect2()
var activo := false
var tween: Tween

func _ready() -> void:
	layer = 90   # por encima del globo q usa 100
	visible = false

	fondo = ColorRect.new()
	fondo.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	fondo.mouse_filter = Control.MOUSE_FILTER_IGNORE
	materialSpot = ShaderMaterial.new()
	materialSpot.shader = SHADER
	materialSpot.set_shader_parameter("radio", 999.0)
	fondo.material = materialSpot
	add_child(fondo)

	etiqueta = Label.new()
	etiqueta.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	etiqueta.offset_top = 20
	etiqueta.offset_bottom = 70
	etiqueta.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	etiqueta.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	etiqueta.add_theme_font_size_override("font_size", 22)
	etiqueta.add_theme_color_override("font_outline_color", Color.BLACK)
	etiqueta.add_theme_constant_override("outline_size", 8)
	etiqueta.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(etiqueta)

func resaltar(rect: Rect2, texto: String = "") -> void:
	var veniaOculto := not activo
	activo = true
	visible = true
	etiqueta.text = texto
	etiqueta.visible = texto != ""
	materialSpot.set_shader_parameter("tamanoPantalla", fondo.size)

	var inicio := rectActual
	if veniaOculto or rectActual.size == Vector2.ZERO:
		inicio = Rect2(rect.get_center(), Vector2.ZERO)   # el hueco "crece" desde el centro
	rectActual = rect

	if tween:
		tween.kill()
	tween = create_tween().set_parallel(true)
	tween.tween_method(aplicarHueco.bind(inicio, rect), 0.0, 1.0, 0.35).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if veniaOculto:
		tween.tween_method(aplicarOscuridad, 0.0, oscuridadMax, 0.3)

func ocultar() -> void:
	if !activo: return
	activo = false
	rectActual = Rect2()
	etiqueta.visible = false
	
	if tween: tween.kill()
	tween = create_tween()
	tween.tween_method(aplicarOscuridad, oscuridadMax, 0.0, 0.25)
	tween.tween_callback(func(): visible = false)

func aplicarHueco(t: float, inicio: Rect2, fin: Rect2) -> void:
	var pos= inicio.position.lerp(fin.position, t)
	var tam= inicio.size.lerp(fin.size, t)
	materialSpot.set_shader_parameter("hueco", Vector4(pos.x, pos.y, tam.x, tam.y))

func aplicarOscuridad(valor: float) -> void:
	materialSpot.set_shader_parameter("oscuridad", valor)
