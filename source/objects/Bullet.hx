package objects;

import states.AchievementsMenuState;

class Bullet extends FlxSprite {
    public var __garbaged:Bool = false;
    public function new() {
        super();

        loadGraphic(Paths.image('untunedsansstuff/bullet'));
        scale.x = 0.5;
        scale.y = 0.5;
        updateHitbox();

    }
}