import psychlua.LuaUtils;
import states.PlayState;
import flixel.addons.display.FlxBackdrop;

var sky:FlxSprite;
function onCreate() {
    game.gfGroup.scrollFactor.set(1, 1);
    sky = new FlxSprite(0, 0).loadGraphic(Paths.image("trainbg/sky"));
    sky.scale.set(3.5, 3.5);
    sky.screenCenter();
    sky.y  += 150;
    sky.x -= 500;
    sky.cameras = [camGame];
    sky.scrollFactor.set(0.2, 0.2);
    addBehindGF(sky);

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

function goIntoTheAir(reverse:Bool) {
    if (reverse) {
        centerCamera(200);
        FlxTween.tween(game, {defaultCamZoom: 0.5}, 1.437, {ease: FlxEase.cubeInOut});
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
                if (v2 == 'true') {
                    goIntoTheAir(true);
                }
                else {
                    goIntoTheAir(false);
                }
            case 'reset':
                triggerEvent('Camera Follow Pos', '', '');
        }
    }
}