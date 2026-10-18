shader_type canvas_item;

uniform vec4 hueco = vec4(0.0);                    // x, y, ancho, alto en píxeles de pantalla
uniform vec2 tamanoPantalla = vec2(1152.0, 648.0);
uniform float oscuridad : hint_range(0.0, 1.0) = 0.75;
uniform float radio = 10.0;
uniform float suavizado = 3.0;

float distanciaRect(vec2 p, vec2 centro, vec2 mitad, float r) {
	vec2 d = abs(p - centro) - (mitad - vec2(r));
	return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0) - r;
}

void fragment() {
	vec2 p = UV * tamanoPantalla;
	vec2 mitad = hueco.zw * 0.5;
	vec2 centro = hueco.xy + mitad;
	float d = distanciaRect(p, centro, mitad, min(radio, min(mitad.x, mitad.y)));
	COLOR = vec4(0.0, 0.0, 0.0, oscuridad * smoothstep(0.0, suavizado, d));
}
