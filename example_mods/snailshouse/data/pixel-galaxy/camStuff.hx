import psychlua.LuaUtils;
import states.PlayState;
var wholeNoteLength = 0.4;

function centerCamera(?poop:Float) {
    var midX = FlxG.width / 2;
    var midY = (FlxG.height / 2) + 200;
    if (poop != null) {
        triggerEvent('Camera Follow Pos', midX, midY - poop);
    }
    else 
    {
        triggerEvent('Camera Follow Pos', midX, midY);
    }
}

// todo fix shader thing

function goIntoTheAir(reverse:Bool) {
    if (reverse) {
        centerCamera(200);
        game.defaultCamZoom = 0.5;
    }
    else {
        centerCamera(600);
        game.defaultCamZoom = 0.3;
    }
}

function onEvent(ev,v1,v2) {
    if (ev == '') {
        switch(v1) {
            case 'center':
                if (v2 != null) {
                    centerCamera(v2);
                }
                else {
                    centerCamera();
                }
            case 'fly': 
                if (v2 == 'true') {
                    goIntoTheAir(true);
                }
                else {
                    goIntoTheAir(false);
                }
            case 'reset':
                triggerEvent('Camera Follow Pos', '', '');
            case 'turn off':
                if (v2 == 'true') {
                    camGame.visible = true;
                }
                else {
                    camGame.visible = false;
                }
            case 'poop':
                if (v2 == 'true') {
                    centerCamera(200);
                    game.defaultCamZoom = 0.5;
                }
                else if (v2 == 'reset') {
                    triggerEvent('', 'reset', '');
                    game.defaultCamZoom = 0.5;
                    moveCameraSection();
                }
                else {
                    centerCamera(300);
                    game.defaultCamZoom = 0.35;
                }
            case 'movecam':
                if (v2 == 'true') {
                    moveCamera(true);
                }
                else {
                    moveCamera(false);
                }
        }
    }
}

function onBeatHit() {
    if (curBeat == 32) {
        FlxG.camera.flash(FlxColor.WHITE, 0.5, {ease: FlxEase.cubeOut});
    }
    if (curBeat == 96) {
        FlxTween.tween(game, {defaultCamZoom: 0.35}, 10.4, {ease: FlxEase.cubeInOut, onComplete: function() {
            triggerEvent('', 'reset', '');
            game.defaultCamZoom = 0.5;
            moveCameraSection();
        }});
    }
}