package states;


class TestState extends MusicBeatState
{

    override function create() {
        super.create();

        FlxG.camera.bgColor = FlxColor.GRAY;

        var test = new objects.Circle(FlxG.width/2 - 50,FlxG.height/2 - 50,100,100,FlxColor.BLUE);
        add(test);

        FlxTween.tween(test, {alpha: 0},3,{type: 4});
    }
}