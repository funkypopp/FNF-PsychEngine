// Automatically converted with https://github.com/TheLeerName/ShadertoyToFlixel

#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
uniform float iTime;
#define iChannel0 bitmap
#define texture flixel_texture2D

// end of ShadertoyToFlixel header

#define PI         3.14159265
#define colBase    vec3(.71, .80, .56)
#define colShadow1 vec3(.57, .64, .47)
#define colShadow2 vec3(.47, .52, .36)
#define colShadow3 vec3(.51, .59, .48)
#define colFoam    vec3(.90, .97, .77)
#define colLight   vec3(1., 1., .83)
#define colSplash  vec3(0.77,0.86,0.68)

float S (float a) {
    return smoothstep(0., .1, a);
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;
    uv.x *= 1.;
    
    vec3 col = vec3(0.);
    
    float n1 = (1.-uv.y)*-snoise(vec3(uv.x * 10. + iTime, 0., uv.y * .2 + iTime * .5));
    float lightShadow = n1+smoothstep(.2, 0., uv.y);
    lightShadow = S(lightShadow - .2);

    float n2 = (1.-uv.y)*-snoise(vec3(uv.x * 15. + iTime * 2., 0., uv.y * .2 + iTime * .5));
    float midShadow = n2+smoothstep(.04, 0., uv.y);
    midShadow = S(midShadow-.5);
    
    float n3 = snoise(vec3(uv.x * 50. + iTime, 0., uv.y * .1 + iTime * 1.5));
    float darkShadow = n3 * smoothstep(0.25, 0., abs((uv.y - .15) + sin(uv.x * 20. + iTime * 4.) * .045));
    darkShadow = S(darkShadow - .4);
    
    float n4 = snoise(vec3(uv.x * 90. + iTime * 2., 0., uv.y * .1 + iTime * 1.5));
    float n5 = snoise(vec3(uv.x * 2., 0., uv.y * 1. + iTime * 1.));
    
    float foamSpeed = S(n4 - n5 - .6);
    
    float n6 = snoise(vec3(uv.x * 10. + iTime * .5, iTime * .1, uv.y * .5 + iTime * 1.5));
    float foam = sin(n6 * PI * 2.) - .9;
    foam = S(foam);
    
    float midReflection = abs(n3) * smoothstep(0.16, 0., abs((uv.y - .5) + sin(uv.x * 10. + iTime * 1.) * .08));
    midReflection *= 1. + sin(uv.x * PI * 4.);
    midReflection = S(midReflection - .1);
    

    float topReflection = abs(n3) * smoothstep(0.1, 0., abs((uv.y - .95) + sin(uv.x * 30. + iTime * .5) * .045));
    topReflection *= cos(uv.x * PI * 4.);
    topReflection = S(topReflection - .1);
    
    float n7 = snoise(vec3(uv.x * 10. - iTime * 2., uv.y + iTime * .5, iTime * 2.));
    float splash1 = smoothstep(0.1, 0.09, uv.y + .03 + n7 * n1 * .09);
    float splash2 = smoothstep(0.07, 0.06, uv.y + .03 + n7 * n1 * .09);
    
    float bubbles = snoise(vec3(uv.x * 20. + iTime * .3, uv.y * 10. - iTime * 3., iTime * .5));
    bubbles = S(bubbles - .72);
    bubbles *= smoothstep(.2, .0, abs(uv.y - .15)) - splash1;

    
    col = mix(colBase, colShadow1, lightShadow);
    col = mix(col, colShadow2, midShadow);
    col = mix(col, colShadow3, darkShadow);
    col = mix(col, colFoam, foamSpeed);
    col = mix(col, colFoam, foam);
    col = mix(col, colLight, midReflection + topReflection + splash1 + bubbles);
    col = mix(col, colSplash, splash2);
    col *= smoothstep(0., 0.01, sin(uv.x * PI) - .6);
    
    fragColor = vec4(col, texture(iChannel0, fragCoord / iResolution.xy).a);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}