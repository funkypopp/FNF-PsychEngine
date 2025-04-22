package objects;

class Circle extends FlxSprite
{
	var circleShader = new shaders.CircleShader();

	public function new(x:Float = 0, y:Float = 0, width:Int = 100, height:Int = 100, color:FlxColor = FlxColor.WHITE)
	{
		super(x, y);

		makeGraphic(width, height, FlxColor.WHITE);
        this.color = color;
		this.shader = circleShader;
	}

    override function update(elapsed:Float) {
        super.update(elapsed);
    }

	override function destroy()
	{
		circleShader = null;

		super.destroy();
	}
}
