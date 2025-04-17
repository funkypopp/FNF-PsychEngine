package objects;

class Ourp extends FlxSprite {

    var rand:Int;
    public function new(wiener:Int) {
        var poopy:Float = FlxG.random.float(0.2, 0.4);
		var ourp:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('ourp/' + wiener));
		ourp.x = FlxG.random.int(-1000, 1000);
		ourp.y = FlxG.random.int(-500, 500);
		ourp.scale.set(poopy, poopy);
        super(wiener);
    }
}