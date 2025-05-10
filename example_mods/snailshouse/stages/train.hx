import psychlua.LuaUtils;
import states.PlayState;
import flixel.addons.display.FlxBackdrop;

var sky:FlxSprite;
function onCreate() {
    game.gfGroup.scrollFactor.set(1, 1);
    sky = new FlxSprite(0, 0).loadGraphic(Paths.image("trainbg/sky"));
    sky.scale.set(3.5, 3.5);
    sky.screenCenter();
    sky.y += 150;
    sky.x += 7750;
    sky.velocity.x = -50;
    sky.cameras = [camGame];
    sky.scrollFactor.set(0.2, 0.2);
    sky.zoomFactor = 0.5;
    addBehindGF(sky);

    var train2:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("trainbg/train2"));
    train2.scale.set(1.4, 1.4);
    train2.screenCenter();
    train2.y += 1175;
    train2.x -= (train2.width * 1.3) + 100;
    train2.cameras = [camGame];
    train2.scrollFactor.set(1, 1);
    addBehindGF(train2);

    var train3:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("trainbg/train2"));
    train3.scale.set(1.4, 1.4);
    train3.screenCenter();
    train3.y += 1175;
    train3.x += (train3.width * 1.3) + 100;
    train3.cameras = [camGame];
    train3.scrollFactor.set(1, 1);
    addBehindGF(train3);

    var train:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("trainbg/train"));
    train.scale.set(1.4, 1.4);
    train.screenCenter();
    train.y += 1175;
    train.cameras = [camGame];
    train.scrollFactor.set(1, 1);
    addBehindGF(train);
}

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

function goIntoTheAir(fag:Int) {
    if (fag == 1) {
        centerCamera(200);
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 1.437, {ease: FlxEase.cubeInOut});
    }
    else if (fag == 2) {
        triggerEvent('', 'reset', '');
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 1.437, {ease: FlxEase.cubeInOut});
    }
    else if (fag == 3) {
        triggerEvent('', 'reset', '');
        FlxTween.tween(game, {defaultCamZoom: 0.4}, 1.437, {ease: FlxEase.cubeInOut});
    }
    else {
        centerCamera(200);
        FlxTween.tween(game, {defaultCamZoom: 0.23}, 1.437, {ease: FlxEase.cubeInOut});
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
                if (v2 == '1') {
                    goIntoTheAir(1);
                }
                if (v2 == '2') {
                    goIntoTheAir(2);
                }
                if (v2 == '3') {
                    goIntoTheAir(2);
                }
                else {
                    goIntoTheAir(0);
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
        }
    }
}

function onBeatHit() {
    if (game.curSong == 'imaginary-express') {
        if (curBeat == 356) {
            FlxTween.tween(sky.velocity, {x: -75}, 11.50, {ease: FlxEase.quintOut});
        }
    }
}