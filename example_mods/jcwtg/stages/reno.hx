import psychlua.LuaUtils;
import states.PlayState;
var reno:FlxSprite;
var gummy:FlxSprite;
var stupid = game.createRuntimeShader("ripplw");
function onCreate() {
    reno = new FlxSprite(0, 0).loadGraphic(Paths.image("reno"));
    gummy = new FlxSprite(0, 0).loadGraphic(Paths.image("gummy"));
    reno.screenCenter();
    gummy.screenCenter();
    reno.cameras = [camGame];
    gummy.cameras = [camGame];
    reno.scale.set(1.8, 1.8);
    gummy.scale.set(1.8, 1.8);
    reno.scrollFactor.set(1, 1);
    gummy.scrollFactor.set(1, 1);
    addBehindDad(reno);
    addBehindDad(gummy);
    gummy.alpha = 0;
    gummy.shader = stupid;
}

function onBeatHit() {
    if (curBeat == 143) {
        FlxTween.tween(gummy, {alpha: 1}, 0.8, {ease: FlxEase.cubeIn});
    }
    if (curBeat == 176) {
        FlxTween.tween(gummy, {alpha: 0}, 1.5, {ease: FlxEase.cubeOut});
    }
}

function onUpdate(e) {
    stupid.setFloat('iTime', Conductor.songPosition / 1600);
}