#pragma header

vec2 uv = openfl_TextureCoordv.xy;
vec2 fragCoord = openfl_TextureCoordv*openfl_TextureSize;
vec2 iResolution = openfl_TextureSize;
uniform float u_Intensity;
#define iChannel0 bitmap
#define iChannel1 bitmap
#define iChannel2 bitmap
#define iChannelResolution bitmap
#define texture flixel_texture2D
#define fragColor gl_FragColor
#define mainImage main
float amount = u_Intensity;

void mainImage()
{
    vec2 uv = fragCoord / iResolution.xy;

    float intensity = amount;
    vec2 center = vec2(0.5, 0.5);
    float dist = abs(uv.x - center.x);

    vec2 red_offset = uv + vec2(dist * intensity, 0.0);
    vec2 green_offset = uv;
    vec2 blue_offset = uv - vec2(dist * intensity, 0.0);

    vec4 red_sample = texture(iChannel0, red_offset);
    vec4 green_sample = texture(iChannel0, green_offset);
    vec4 blue_sample = texture(iChannel0, blue_offset);

    vec3 color;
    color.r = red_sample.r;
    color.g = green_sample.g;
    color.b = blue_sample.b;

    float alpha = green_sample.a;

    fragColor = vec4(color, alpha);
}