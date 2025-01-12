shader_type canvas_item;

uniform sampler2D NOISE_TEXTURE: repeat_enable;
uniform sampler2D NOISE_TEXTURE_2: repeat_enable;
uniform vec2 player_pos;

void fragment() {
	vec4 noise_texture = texture(NOISE_TEXTURE,UV+player_pos);
	COLOR.rgb = noise_texture.rgb;
}

