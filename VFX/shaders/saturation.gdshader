shader_type canvas_item;

// 1.0 es normal, > 1.0 sube el brillo, < 1.0 lo baja
uniform float brightness : hint_range(0.0, 5.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    // Multiplicamos solo el RGB para no afectar la transparencia
    COLOR = vec4(tex_color.rgb * brightness, tex_color.a);
}