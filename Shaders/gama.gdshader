shader_type canvas_item;

uniform float value;

void fragment() {
	COLOR.rgb += vec3(value);
}
