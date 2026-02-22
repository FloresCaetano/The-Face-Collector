shader_type canvas_item;

// En Godot 4, necesitamos declarar explícitamente la textura de la pantalla
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float threshold : hint_range(0.0, 1.0) = 0.0;
uniform float blend : hint_range(0.0, 1.0) = 0.01;

float getGrayScale(sampler2D sampler, vec2 coords){
    // Usamos la textura de pantalla declarada
    vec4 color = texture(sampler, coords);
    float gray = (color.r + color.g + color.b) / 3.0;
    return gray;
}

void fragment(){
    vec2 delta = vec2(0.0, 0.003);
    vec2 texCoords = SCREEN_UV;
    
    // Obtenemos el color original de la pantalla
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
    
    // Cálculos de bordes usando la nueva referencia a screen_texture
    float c1y = getGrayScale(screen_texture, texCoords.xy - delta / 2.0);
    float c2y = getGrayScale(screen_texture, texCoords.xy + delta / 2.0);
    
    float c1x = getGrayScale(screen_texture, texCoords.xy - delta.yx / 2.0);
    float c2x = getGrayScale(screen_texture, texCoords.xy + delta.yx / 2.0);
    
    float dcdx = (c2x - c1x) / (delta.y * 10.0);
    float dcdy = (c2y - c1y) / (delta.y * 10.0);
    
    vec2 dcdi = vec2(dcdx, dcdy);
    float edge = length(dcdi) / 10.0;
    edge = 1.0 - edge;
    edge = smoothstep(threshold, threshold + blend, edge);
    
    COLOR.rgb = mix(edge_color.rgb, screen_color.rgb, edge);
}