shader_type spatial;

uniform sampler2D TEXTURE;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

void fragment(){
	
	vec4 color = vec4(texture(SCREEN_TEXTURE, SCREEN_UV).rgb, texture(TEXTURE, UV).a);
	
	ALBEDO = 1.0 - color.rgb;
}