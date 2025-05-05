package objects.sans;

import flixel.addons.effects.FlxTrail;
import flixel.FlxG;
import flixel.FlxSprite;
import states.UntunedRoguelikeState;

class Bullet extends FlxSprite {
    public var __garbaged:Bool = false;
    public var damage:Int = 5;

    private var trail:FlxTrail;

    public function new() {
        super();

        loadGraphic(Paths.image('untunedsansstuff/bullet'));
        scale.x = 0.5;
        scale.y = 0.5;
        updateHitbox();

        // cool trail fuck yeah
        FlxG.state.add(trail = new FlxTrail(this, null, 10, 1, 0.6, 0.1));
    }

    public override function update(elapsed:Float):Void {
        super.update(elapsed);

        if (x > FlxG.width || (x + width) < 0 || (y + height) < 0 || y > FlxG.height || __garbaged)
        {
            trail.kill();
            kill();
        }
    }
}