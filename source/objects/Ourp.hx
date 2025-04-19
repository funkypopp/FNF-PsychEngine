package objects;

import states.AchievementsMenuState;
import flixel.FlxObject;

class Ourp extends FlxSprite {

    private var rand:Int;
    private var poopy:Float;
    private var piss:Int;
    private var kys:Int;
    private var poopHealth:Int;
    public function new(wiener:Int) {
        super();
        if (wiener == 7) {
            poopy = FlxG.random.float(0.20, 0.30);
        }
        else {
            poopy = FlxG.random.float(0.40, 0.60); 
        }
        poopHealth = FlxG.random.int(10, 20);
        kys = wiener;
        piss = FlxG.random.int(60, 120);
        loadGraphic(Paths.image('ourp/' + wiener));
        x = FlxG.random.int(-1000, 1000);
        y = FlxG.random.int(-500, 500);
        scale.x = poopy;
        scale.y = poopy;
        centerOffsets();
        updateHitbox();
    }

    function hurtOuch(obj1:FlxObject, obj2:FlxObject):Void {
        poopHealth -= 10;
        AchievementsMenuState.score += 5;
        trace(poopHealth);
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        FlxG.overlap(AchievementsMenuState.bullet, this, hurtOuch);
        if (poopHealth <= 0) {
            kill();
        }

        if (kys == 7) {
            if (x > AchievementsMenuState.sans.x - 125) {
                velocity.x = -piss;
            }
            if (x < AchievementsMenuState.sans.x - 125) {
                velocity.x = piss;
            }
            if (y > AchievementsMenuState.sans.y - 125) {
                velocity.y = -piss;
            }
            if (y < AchievementsMenuState.sans.y - 125) {
                velocity.y = piss;
            }
            if (x == AchievementsMenuState.sans.x - 125) {
                velocity.x = 0;
            }
            if (y == AchievementsMenuState.sans.y - 125) {
                velocity.y = 0;
            }
        }
        else {
            if (x > AchievementsMenuState.sans.x - 50) {
                velocity.x = -piss;
            }
            if (x < AchievementsMenuState.sans.x - 50) {
                velocity.x = piss;
            }
            if (y > AchievementsMenuState.sans.y - 50) {
                velocity.y = -piss;
            }
            if (y < AchievementsMenuState.sans.y - 50) {
                velocity.y = piss;
            }
            if (x == AchievementsMenuState.sans.x - 50) {
                velocity.x = 0;
            }
            if (y == AchievementsMenuState.sans.y - 50) {
                velocity.y = 0;
            }
        }
    }
}