import psychlua.LuaUtils;
import states.PlayState;

var stupid2 = game.createRuntimeShader("fun");

function onCreatePost() {
    stupid2.setFloat('u_mix', 0.3);
    game.camGame.filters = ([new ShaderFilter(stupid2)]);
}

function onUpdate(e) {
    stupid2.setFloat('iTime', Conductor.songPosition / 1600);
}

function onBeatHit() {
    if (curBeat == 104) {
        FlxG.camera.flash(FlxColor.WHITE, 0.8, {ease: FlxEase.cubeOut});
        game.camGame.filters = ([]);
    }
    if (curBeat == 344) {
        game.camGame.visible = false;
    }
    if (curBeat == 408) {
        game.camGame.visible = true;
        stupid2.setFloat('u_mix', 0.04);
        game.camGame.filters = ([new ShaderFilter(stupid2)]);
    }
    if (curBeat == 480) {
        FlxG.camera.flash(FlxColor.WHITE, 0.8, {ease: FlxEase.cubeOut});
        stupid2.setFloat('u_mix', 0.5);
    }
}

function onStepHit() {
    if (curStep == 2694) {
        game.camGame.visible = false;
    }
}