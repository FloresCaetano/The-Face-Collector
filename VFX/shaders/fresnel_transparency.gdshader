shader_type spatial;
render_mode blend_mix, depth_test_disabled, unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform vec4 edge_color : source_color = vec4(0.0, 0.5, 1.0, 0.0);
uniform float fresnel_power : hint_range(0.1, 10.0) = 2.0;

void fragment() {
	vec3 bg_color = texture(screen_texture, SCREEN_UV).rgb;
	vec3 inverted_bg = vec3(1.0) - bg_color;
	
	float fresnel = pow(clamp(dot(NORMAL, VIEW), 0.0, 1.0), fresnel_power);
	
	vec3 final_rgb = mix(edge_color.rgb, inverted_bg, fresnel);
	float final_alpha = mix(edge_color.a, 1.0, fresnel);
	
	ALBEDO = final_rgb;
	ALPHA = final_alpha;
}