// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

void mainImage( out vec4 fragColor, in vec2 fragCoord ) 
{
    // pixel position normalised to [-1, 1]
	vec2 cPos = -1.0 + 2.0 * fragCoord.xy / iResolution.xy;
    
    // distance of current pixel from center
	float cLength = length(cPos);

	vec2 uv = fragCoord.xy/iResolution.xy+(cPos/cLength)*cos(cLength*12.0-iTime*4.0) * 0.03;
	
    
    vec3 col = texture(iChannel0,uv).xyz;

	fragColor = vec4(col, texture(iChannel0, uv).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}