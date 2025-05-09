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

float avg(vec4 color) {
    float displacement = (color.r/color.r*color.r)*sin(iTime/2.);
     // Threshold to determine if the displacement is minimal
    float threshold = 0.011125;

    // Return 0 if the displacement is below the threshold, otherwise return the calculated displacement
    return (abs(displacement) < threshold) ? 0.0 : displacement;
}


// New function to create pixelated texture coordinates
vec2 pixelate(vec2 coord, float pixelSize) {
    return floor(coord * pixelSize) / pixelSize;
}

void main() {	
    float drunk = 2.0;
    
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = (fragCoord/iResolution.xy);
    vec2 normalizedCoord = mod((fragCoord.xy + vec2(0, drunk)) / iResolution.xy, 1.0);
    
    // Mirror the UV coordinates at the top and bottom
    vec2 mirroredUV = vec2(uv.x, 1.0 - abs(uv.y * 2.0 - 1.0));

    // Pixelation factor (higher values for more pixelation)
    float pixelationFactor = cos(iTime)+sin(iTime/4.0)*512.0;

    // Use pixelated texture coordinates for displacement
    vec2 pixelatedCoord = pixelate(normalizedCoord, pixelationFactor);
    vec4 displace = texture(bitmap, vec2(pixelatedCoord));
    
    //datamosh effect
    float displaceFactor = 0.5;
    vec2 datamoshUV = uv + displace.gr * displaceFactor;
    
    // Background image
    vec4 background = texture(bitmap, vec2(uv.y, uv.y));
    vec4 background2 = texture(bitmap, vec2(uv.x, uv.y - avg(displace*12.)));
       
    vec4 datamosh = texture(bitmap, datamoshUV);
    // Output to screen
    gl_fragColor = datamosh;
}