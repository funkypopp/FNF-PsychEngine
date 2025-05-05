package objects.sans;

import states.UntunedRoguelikeState;

class Powerup extends FlxSprite {
    public var __garbaged:Bool = false;
    public var __grabbed:Bool = false;
    public function new(poop:Int) {
        super();
        setIndex(poop);
    }

    public function setIndex(index:Int) {
        switch(index) {
            case 1:
                loadGraphic(Paths.image('untunedsansstuff/armupgrade'));
            case 2:
                loadGraphic(Paths.image('untunedsansstuff/blastupgrade'));
            case 3:
                loadGraphic(Paths.image('untunedsansstuff/boneupgrade'));
            case 4:
                loadGraphic(Paths.image('untunedsansstuff/flyupgrade'));
            case 5:
                loadGraphic(Paths.image('untunedsansstuff/dmupgrade'));
            case 6:
                loadGraphic(Paths.image('untunedsansstuff/speedupgrade'));
            case 7:
                loadGraphic(Paths.image('untunedsansstuff/jpgdowngrade'));
        }
        scale.x = 0.5;
        scale.y = 0.5;
        updateHitbox();
    }
}