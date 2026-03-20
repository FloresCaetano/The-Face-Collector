shader_type canvas_item;

uniform bool enabled = true;
uniform bool dithering = true;
uniform int colors : hint_range(1, 32) = 12;
uniform int dither_size : hint_range(1, 8) = 1;
// Importante para post-procesado en Godot 4
uniform sampler2D screen_texture : hint_screen_texture, filter_nearest;

float dithering_pattern(ivec2 fragcoord) {
    // Definimos el patrón de forma que Godot lo entienda
    float pattern[16] = float[](
        0.00, 0.50, 0.10, 0.65, 
        0.75, 0.25, 0.90, 0.35, 
        0.20, 0.70, 0.05, 0.50, 
        0.95, 0.40, 0.80, 0.30
    );
    
    int x = fragcoord.x % 4;
    int y = fragcoord.y % 4;
    
    return pattern[y * 4 + x];
}

float reduce_color(float raw, float dither, int depth) {
    float float_depth = float(depth);
    // Una forma mucho más simple y rápida de hacer posterización/dithering:
    float val = floor(raw * float_depth + dither) / float_depth;
    return clamp(val, 0.0, 1.0);
}

void fragment() {
    // Cambiado de TEXTURE a screen_texture para que afecte a la pantalla
    vec4 raw = texture(screen_texture, SCREEN_UV);
    ivec2 uv = ivec2(FRAGCOORD.xy / float(dither_size));

    if (enabled) {
        float d_val = 0.0;
        if (dithering) {
            // El valor de dither suele normalizarse para que no desplace el color
            d_val = (dithering_pattern(uv) - 0.5) / float(colors);
        }
        
        vec3 final_rgb;
        final_rgb.r = reduce_color(raw.r, d_val, colors - 1);
        final_rgb.g = reduce_color(raw.g, d_val, colors - 1);
        final_rgb.b = reduce_color(raw.b, d_val, colors - 1);
        
        COLOR = vec4(final_rgb, raw.a);
    } else {
        COLOR = raw;
    }
}