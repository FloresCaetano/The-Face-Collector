shader_type canvas_item;

uniform sampler2D noise : repeat_enable;
uniform float blood_coef : hint_range(0.0, 1.0) = 0.0;
uniform float blood_opacity : hint_range(0.0, 1.0) = 0.8; // <--- El nuevo slider
uniform vec3 color : source_color;

void fragment() {
    float noise_val = texture(noise, UV).r;
    
    float is_blood = step(noise_val, blood_coef);
    
    // Multiplicamos 'is_blood' por la opacidad del slider
    // Así, donde hay sangre, el alfa máximo será el que tú elijas
    vec4 blood_output = vec4(color, is_blood * blood_opacity);
    
    vec4 curr_texture = texture(TEXTURE, UV);
    blood_output.a *= curr_texture.a;
    
    COLOR = blood_output;
}