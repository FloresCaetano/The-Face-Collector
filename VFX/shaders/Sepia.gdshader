shader_type canvas_item;

uniform float red : hint_range(0.1, 5.0) = 1.0;
uniform float green : hint_range(0.1, 5.0) = 1.0;
uniform float blue : hint_range(0.1, 5.0) = 1.0;

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    float r = (tex_color.r * 0.393 * red) + (tex_color.g * 0.769 * green) + (tex_color.b * 0.189 * blue);
    float g = (tex_color.r * 0.349 * red) + (tex_color.g * 0.686 * green) + (tex_color.b * 0.168 * blue);
    float b = (tex_color.r * 0.272 * red) + (tex_color.g * 0.534 * green) + (tex_color.b * 0.131 * blue);
    COLOR = vec4(r, g, b, tex_color.a);
}