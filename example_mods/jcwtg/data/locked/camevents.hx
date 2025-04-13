
var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;
var black:FlxSprite;
var funnyText:FlxText;
var pants:FlxText;
var shittyFuckingTimer:FlxTimer;
function onCreatePost() {
    black = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xff000000);
    black.scrollFactor.set(0, 0);
    black.scale.set(1.2, 1.2);
    black.cameras = [camGame];
    black.screenCenter();
    black.visible = false;
    add(black);

    funnyText = new FlxText(0, 0, 0, "CAN'T").setFormat("tnr.ttf", 75, 0xffffffff, "left", 0xff000000);
    funnyText.cameras = [camGame];
    funnyText.screenCenter();
    funnyText.x -= 350;
    funnyText.y += 250;
    funnyText.visible = false;
    add(funnyText);

    pants = new FlxText(0, 0, 0, "PANTS").setFormat("tnr.ttf", 75, 0xffffffff, "center", 0xff000000);
    pants.cameras = [camGame];
    pants.screenCenter();
    pants.y += 250;
    pants.visible = false;
    add(pants);
}

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
    if (curBeat == 128) {
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 4.65, {ease: FlxEase.sineInOut});
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 200}, 4.65, {ease: FlxEase.sineInOut, onComplete: function() {
            centerCamera();
        }});
    }
    if (curBeat == 163) {
        FlxTween.tween(game, {defaultCamZoom: 0.75}, 0.5, {ease: FlxEase.backInOut});
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
    if (curStep == 508) {
        black.visible = true;
        funnyText.visible = true;
        shittyFuckingTimer = new FlxTimer().start(0.12, () -> {
            funnyText.text = "CAN'T KEEP";
            new FlxTimer().start(0.12, () -> {
                funnyText.text = "CAN'T KEEP MY";
                new FlxTimer().start(0.12, () -> {
                    funnyText.text = "CAN'T KEEP MY DICK";
                    new FlxTimer().start(0.08, () -> {
                        funnyText.text = "CAN'T KEEP MY DICK IN";
                        new FlxTimer().start(0.08, () -> {
                            funnyText.text = "CAN'T KEEP MY DICK IN MY";
                        });
                    });
                });
            });
        });
    }
    if (curStep == 512) {
        funnyText.visible = false;
        pants.visible = true;
        FlxTween.tween(black, {alpha: 0}, 0.4, {ease: FlxEase.cubeOut, onComplete: function() {
            black.destroy();
        }});
        FlxTween.tween(pants, {alpha: 0}, 0.6, {ease: FlxEase. cubeOut, onComplete: function() {
            pants.destroy();
        }});
    }
    if (curStep == 566) {
        focusOnDad();
    }
    if (curStep == 567) {
        focusOnBf();
    }
    if (curStep == 568) {
        focusOnDad();
    }
    if (curStep == 569) {
        focusOnBf();
    }
    if (curStep == 570) {
        centerCamera(100);
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 0.45, {ease: FlxEase.backOut, onComplete: function() {
            FlxTween.tween(game, {defaultCamZoom: 0.75}, 0.25, {ease: FlxEase.quintIn});
        }});
        FlxTween.tween(camGame.scroll, {y: camGame.scroll.y - 100}, 0.65, {ease: FlxEase.backOut});
        FlxTween.tween(boyfriendGroup, {x: boyfriendGroup.x + 250}, 0.45, {ease: FlxEase.backOut, onComplete: function() {
            FlxTween.tween(boyfriendGroup, {x: boyfriendGroup.x - 200}, 0.3, {ease: FlxEase.quintIn});
        }});
        FlxTween.tween(dadGroup, {x: dadGroup.x - 250}, 0.45, {ease: FlxEase.backOut, onComplete: function() {
            FlxTween.tween(dadGroup, {x: dadGroup.x + 200}, 0.3, {ease: FlxEase.quintIn});
        }});
    }
}

function onEvent(ev,v1,v2) {
    if (ev == 'Set Property' && v1 == 'camGame.zoom') {
        game.defaultCamZoom = v2;
    }
    if (ev == '') {
        switch(v1) {
            case 'bf':
                focusOnBf();
            case 'dad':
                focusOnDad();
            case 'center':
                if (v2 != null) {
                    centerCamera(v2);
                }
                else {
                    centerCamera();
                }
            case 'reset':
                triggerEvent('Camera Follow Pos', '', '');
        }
    }
}