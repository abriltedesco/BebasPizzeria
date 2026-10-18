shader_type canvas_item;

uniform sampler2D pantalla : hint_screen_texture, filter_nearest;

void fragment() {
	vec4 c = texture(pantalla, SCREEN_UV);
	float g = dot(c.rgb, vec3(0.299, 0.587, 0.114));
	COLOR = vec4(vec3(g), 1.0);
}