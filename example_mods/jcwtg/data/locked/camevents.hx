var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;

// to make my life easier
function centerCamera(?poop:Float) {
    if (poop != null) {
        triggerEvent('Camera Follow Pos', midX, midY - poop);
    }
    else 
    {
        triggerEvent('Camera Follow Pos', midX, midY);
    }
}
function focusOnBf() {
    triggerEvent('Camera Follow Pos', midX + 350, midY);
}
function focusOnDad() {
    triggerEvent('Camera Follow Pos', midX - 350, midY);
}

function onBeatHit() {
    if (curBeat == 45) {
        FlxTween.tween(camGame.scroll, {x: (midX / 2) - 325, y: (midY / 2) - 50}, 1.7, {ease: FlxEase.cubeIn, onComplete: function() {
            centerCamera();
        }});
        FlxTween.tween(game, {defaultCamZoom: 1}, 1.5, {ease: FlxEase.cubeIn, onComplete: function() {
            game.defaultCamZoom = 0.65;
        }});
        isCameraOnForcedPos = true;
    }
    if (curBeat == 63) {
        FlxTween.tween(camGame, {zoom: 0.8}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.8;
        focusOnBf();
    }
    if (curBeat == 64) {
        centerCamera();
    }
    if (curBeat == 76) {
        centerCamera();
        FlxTween.tween(camGame, {zoom: 0.65}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.65;
    }
    if (curBeat == 82) {
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 7.89, {ease: FlxEase.sineInOut});
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 200}, 7.89, {ease: FlxEase.sineInOut});
    }
    if (curBeat == 96) {
        FlxTween.tween(camGame, {zoom: 0.8}, 0.000001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.8;
        focusOnDad();
    }
    if (curBeat == 98) {
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 7, {ease: FlxEase.sineInOut});
        FlxTween.tween(camGame.scroll, {x: camGame.scroll.x + 350 ,y: camGame.scroll.y - 200}, 7, {ease: FlxEase.sineInOut});
    }
    if (curBeat == 112) {
        centerCamera(200);
        FlxTween.tween(camGame, {zoom: 0.5}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.5;
        FlxTween.tween(game, {defaultCamZoom: 1}, 8.6, {ease: FlxEase.sineInOut});
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y + 50}, 8.6, {ease: FlxEase.sineInOut, onComplete: function() {
            centerCamera(-40);
        }});
    }
}

function onStepHit() {
    if (curStep == 256) {
        FlxTween.tween(camGame, {zoom: 1.05}, 0.0001, {ease: FlxEase.cubeIn});
    }
    if (curStep == 257) {
        FlxTween.tween(camGame, {zoom: 0.85}, 0.0001, {ease: FlxEase.cubeIn});
    }
    if (curStep == 258) {
        FlxTween.tween(camGame, {zoom: 0.65}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.65;
    }
    if (curStep == 288) {
        focusOnDad();
        FlxTween.tween(camGame, {zoom: 0.8}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.8;
    }
    if (curStep == 290) {
        triggerEvent('Camera Follow Pos', '', '');
    }
    if (curStep == 308) {
        FlxTween.tween(camGame, {zoom: 0.7}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.7;
    }
    if (curStep == 310) {
        FlxTween.tween(camGame, {zoom: 0.75}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.75;
    }
    if (curStep == 314) {
        FlxTween.tween(camGame, {zoom: 0.85}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.85;
    }
    if (curStep == 316) {
        FlxTween.tween(camGame, {zoom: 0.95}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.95;
    }
    if (curStep == 317) {
        FlxTween.tween(game.boyfriendGroup, {x: game.boyfriendGroup.x - 150}, 0.6, {ease: FlxEase.cubeOut});
        FlxTween.tween(game.dadGroup, {x: game.dadGroup.x + 150}, 0.6, {ease: FlxEase.cubeOut});
    }
    if (curStep == 318) {
        FlxTween.tween(camGame, {zoom: 1}, 0.0001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 1;
    }
    if (curStep == 442) {
        focusOnBf();
        FlxTween.tween(camGame, {zoom: 0.8}, 0.000001, {ease: FlxEase.cubeIn});
        game.defaultCamZoom = 0.8;
    }
}