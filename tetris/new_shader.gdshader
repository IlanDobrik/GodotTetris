shader_type spatial;
render_mode unshaded;

uniform sampler2D SCEEN_TEXTURE : hint_screen_texture;
uniform vec4 outline_colour : source_color;
uniform float outline_width = 1.0;

void fragment() {
	vec4 pixelatedtext = texture(SCEEN_TEXTURE, SCREEN_UV);
	vec2 pixle_size = 1.0/ VIEWPORT_SIZE;
	ALBEDO = pixelatedtext.rgb;
	
	for(int y = -1*int(outline_width); y <= 1*int(outline_width); y++)
	for(int x = -1*int(outline_width); x <= 1*int(outline_width); x++) {
		vec4 tex = texture(SCEEN_TEXTURE, SCREEN_UV + vec2(float(x),float(y))*pixle_size);
		if(tex.a == 0.0 &&
		SCREEN_UV.x + float(x) * pixle_size.x < 1.0 &&
		SCREEN_UV.x + float(x) * pixle_size.x > 0.0 &&
		SCREEN_UV.y + float(x) * pixle_size.y < 1.0 &&
		SCREEN_UV.y + float(x) * pixle_size.y > 0.0) {
			ALBEDO = outline_colour.rgb;
			ALPHA = 1.0;
		}
	}
	
}