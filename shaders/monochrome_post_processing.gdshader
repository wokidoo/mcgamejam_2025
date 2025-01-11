shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

void fragment() {
	vec4 screen_texture = texture(SCREEN_TEXTURE,UV);
	float average_colour = screen_texture.r+screen_texture.g+screen_texture.b/3.0;
	COLOR.rgb = vec3(average_colour);
}
