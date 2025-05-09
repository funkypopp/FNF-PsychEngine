#pragma header

#define iResolution vec3(openfl_TextureSize, 0.)
#define iChannel0 bitmap
#define texture flixel_texture2D

// variables which are empty, they need just to avoid crashing shader
uniform vec4 iDate;

void mainImage( out vec4 f, in vec2 p )
{
    vec2 d=(p.xy/iResolution.x-.5)*3;
    f=texture(iChannel0,vec2(atan(d.y,d.x),.3)+.02*iDate.w)/length(5.0*d);
}

void main() {
	mainImage(gl_FragColor, openfl_TextureCoordv*openfl_TextureSize);
}