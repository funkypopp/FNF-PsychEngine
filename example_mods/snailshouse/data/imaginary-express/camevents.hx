import psychlua.LuaUtils;
import states.PlayState;

function onBeatHit() {
    if (curBeat == 196) {
        FlxTween.tween(game, {defaultCamZoom: 0.7}, 2.68, {ease: FlxEase.cubeIn, onComplete: function() {
            game.defaultCamZoom = 0.5;
            moveCameraSection();
        }});
    }
}