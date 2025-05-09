import psychlua.LuaUtils;
import states.PlayState;

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
        }
    }
}

function onCreate() {
    game.gfGroup.scrollFactor.set(1, 1);

    var sky:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("castlebg/sky"));
    sky.screenCenter();
    sky.cameras = [camGame];
    sky.scrollFactor.set(0.2, 0.2);
    addBehindGF(sky);

    var castle:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("castlebg/mainbg"));
    castle.screenCenter();
    castle.y -= 975;
    castle.cameras = [camGame];
    castle.scrollFactor.set(1, 1);
    addBehindGF(castle);

    var additiveColor:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("castlebg/add"));
    additiveColor.screenCenter();
    additiveColor.y -= 200;
    additiveColor.blend = LuaUtils.blendModeFromString("add");
    additiveColor.cameras = [camGame];
    additiveColor.scrollFactor.set(1, 1);
    addBehindGF(additiveColor);
}

// function onCreatePost() {
//     centerCamera(200);
// }