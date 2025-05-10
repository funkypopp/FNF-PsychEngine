import psychlua.LuaUtils;
import states.PlayState;

function onBeatHit() {
    if (curBeat == 196) {
        FlxTween.tween(game, {defaultCamZoom: 0.7}, 2.68, {ease: FlxEase.cubeIn, onComplete: function() {
            game.defaultCamZoom = 0.5;
        }});
    }
    if (curBeat == 260) {
        FlxTween.tween(game, {defaultCamZoom: 0.25}, 5.3, {ease: FlxEase.cubeInOut});
        FlxTween.tween(game.camGame, {alpha: 0.35}, 5.3, {ease: FlxEase.cubeInOut});
    }
    if (curBeat == 275) {
        game.defaultCamZoom = 0.5;
        game.camGame.alpha = 1;
        FlxTween.tween(game, {defaultCamZoom: 0.25}, 5.3, {ease: FlxEase.cubeInOut});
        FlxTween.tween(game.camGame, {alpha: 0.35}, 5.3, {ease: FlxEase.cubeInOut, onComplete: function() {
            game.camGame.alpha = 1;
            game.defaultCamZoom = 0.5;
        }});
    }
    if (curBeat == 340) {
        FlxTween.tween(game, {defaultCamZoom: 0.8}, 5.75, {ease: FlxEase.quintIn});
    }
    if (curBeat == 356) {
        FlxTween.globalManager.completeTweensOf(game.defaultCamZoom);
        FlxTween.tween(game, {defaultCamZoom: 0.15}, 11.50, {ease: FlxEase.quintOut});
    }
    if (curBeat == 416) {
        FlxTween.tween(game, {defaultCamZoom: 0.175}, .44, {ease: FlxEase.cubeIn});
    }
    if (curBeat == 420) {
        FlxTween.globalManager.completeTweensOf(game.defaultCamZoom);
    }
    if (curBeat == 612) {
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 0.25, {ease: FlxEase.expoOut});
    }
}