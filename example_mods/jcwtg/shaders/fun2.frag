// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 1.5453);
}


float perlin(vec2 p){
	vec2 ip = floor(p);
	vec2 u = fract(p);
	u = u*u*(3.0-2.0*u);
	
	float res = mix(
		mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
	return res*res;
}

vec3 colorVariation(vec2 coord, float time) {
    // Generate Perlin noise based on the coordinate and time
    float noiseValue = perlin(coord * 1.0 + time * 1.0);

    // Map the noise value to a color offset
    vec3 colorOffset = vec3(
        sin(noiseValue * 120.0) * 12.95 + 0.0905,
        cos(noiseValue * 10.0) / 2.9095 + 0.0905,
        sin(noiseValue*12.0) * 0.9395 + 0.01025
    );

    return colorOffset;
}


float avg(vec4 color) {
    float displacement = (color.r/color.r*color.r)*sin(iTime/2.);
    // Threshold to determine if the displacement is minimal
    float threshold = 0.5;

    // Return 0 if the displacement is below the threshold, otherwise return the calculated displacement
    return (abs(displacement) < threshold) ? 0.0 : displacement;
}

// New function to create pixelated texture coordinates
vec2 pixelate(vec2 coord, float pixelSize) {
    return floor(coord * pixelSize) / pixelSize;
}


void main() {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord / iResolution.xy);

    // Pixelation factor (higher values for more pixelation)
    float pixelationFactor = sin(iTime) + sin(iTime / 8.0) * 256.0;
    
    
    // Use pixelated texture coordinates for displacement
    vec2 pixelatedCoord = pixelate(uv, pixelationFactor);
    
    // Create displacement vector
    vec4 displace = texture(bitmap, vec2(pixelatedCoord));
    
    
    displace.rg *= vec2(cos(iTime + pixelatedCoord.y * cos(iTime/2.0)*12.0) * 0.5 + 0.5, sin(iTime + pixelatedCoord.y * 10.0) * 0.5 + 0.5);

    // Datamosh effect
    float displaceFactor = .92125 + sin(iTime);
    vec2 datamoshUV = uv + displace.rg / displaceFactor;

    vec4 datamosh = texture(bitmap, datamoshUV);
    vec4 newColor = vec4(datamosh.rgb + colorVariation(datamosh.rg, iTime), 1.0);
    gl_fragColor = newColor;
}