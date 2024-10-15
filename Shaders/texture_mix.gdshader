shader_type canvas_item;

uniform sampler2D mix_texture;
uniform float progress : hint_range(0.0, 1.0, 0.1);

void fragment() {
	COLOR = mix(texture(mix_texture, UV), COLOR, 1.0-progress);
}