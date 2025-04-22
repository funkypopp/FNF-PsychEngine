package shaders;

import flixel.system.FlxAssets.FlxShader;

class CircleShader extends FlxShader
{

	public var thickness(default,set):Float = 5;
	function set_thickness(value:Float):Float
	{
		thickness = value;
		this.u_thickness.value = [value / 100,value / 100];
		return thickness;
	}

	//fix transparency on this
	@:glFragmentSource('
		#pragma header

		uniform float u_thickness;

		vec3 drawCircle(vec2 uv, float radius)
		{
			float uvLength = length(uv);

			vec3 circle = vec3(smoothstep(radius, radius - 2.0 / openfl_TextureSize.y , uvLength));

			return vec3(circle);
		}

		void main()
		{
			vec2 uv = openfl_TextureCoordv;

			uv -= vec2(0.5,0.5); //center
			
			vec3 circle = drawCircle(uv.xy, 0.5);

			vec3 circle2 = drawCircle(uv.xy,0.5 - u_thickness);

			float circle2Alpha = circle2.r + circle2.g + circle2.b / 3.0;

			circle = mix(circle,vec3(0.0),circle2Alpha);

			vec4 sampleTex = flixel_texture2D(bitmap,openfl_TextureCoordv);

			circle.rgb *= sampleTex.a;

			float alpha = circle.r + circle.g + circle.b / 3.0;

			vec4 finalTex = mix(vec4(circle,0.0),sampleTex,alpha);

			finalTex.rgba *= sampleTex.a;
			
			gl_FragColor = finalTex;
		}

	
		')
	public function new()
	{
		super();
		thickness = 5;
	}
}
