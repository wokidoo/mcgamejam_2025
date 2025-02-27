//based new version off of this code, could be useful later if adjustment is needed https://godotshaders.com/shader/analog-monitor/

shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;

vec4 to_grayscale(vec4 color) {
	float luminance = 0.21 * color.r + 0.72 * color.g + 0.07 * color.b;
	return vec4(luminance, luminance, luminance, color.a);
}

void fragment() {

	vec2 uv = SCREEN_UV;
	vec2 uv2 = SCREEN_UV;

	vec4 color1 = texture(SCREEN_TEXTURE, uv);

		color1 = to_grayscale(color1);

	// apply hard mix blending
	vec4 final_result = color1;

	COLOR = final_result;
}
