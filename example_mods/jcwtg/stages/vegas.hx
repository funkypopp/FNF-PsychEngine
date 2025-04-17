import psychlua.LuaUtils;
import states.PlayState;
var vegas:FlxSprite;
var aero:FlxSprite;
var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;
function onCreate() {
    vegas = new FlxSprite(0, 0).loadGraphic(Paths.image("vegas"));
    aero = new FlxSprite(0, 0).loadGraphic(Paths.image("aero"));
    vegas.screenCenter();
    aero.screenCenter();
    vegas.cameras = [camGame];
    aero.cameras = [camGame];
    vegas.scale.set(2.2, 2.2);
    aero.scale.set(2.2, 2.2);
    vegas.scrollFactor.set(1, 1);
    aero.scrollFactor.set(1, 1);
    addBehindDad(vegas);
    addBehindDad(aero);
    aero.alpha = 0;
}

function onBeatHit() {
    if (curBeat == 216) {
        aero.alpha = 1
    }
}