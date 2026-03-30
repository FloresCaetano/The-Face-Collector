shader_type spatial;
render_mode blend_mix,depth_draw_opaque,cull_back,diffuse_lambert,specular_schlick_ggx, shadows_disabled;

uniform bool animate_noise = true;
uniform vec2  uv_scroll_speed = vec2(0.01, 0.01);
uniform sampler2D noise;
uniform lowp float edgefade : hint_range(0, 1) = 0.2;
uniform lowp float globalfade : hint_range(0, 1) = 0.5;
varying vec2 uv_scrolled;


void vertex ()
{
uv_scrolled = ( UV + TIME * uv_scroll_speed );
}

void fragment () {
    float sinvresnel = pow(dot(normalize(NORMAL), normalize(VIEW)), (edgefade*25.0))*(1.0-globalfade);
    sinvresnel = clamp(sinvresnel, 0.0, 1.0);
    if(animate_noise){
    vec3 noise_tex = texture(noise, uv_scrolled).rgb;
    ALPHA = sinvresnel * noise_tex.r;
    ALBEDO += noise_tex.rgb;
    }
    else{
    vec3 noise_tex = texture(noise, UV).rgb;
    ALPHA = sinvresnel * noise_tex.r;
    ALBEDO += noise_tex.rgb;
    }
}