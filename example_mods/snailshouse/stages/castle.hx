import psychlua.LuaUtils;
import states.PlayState;

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

function onCreatePost() {
    if (game.curSong == 'Pixel Galaxy') {
        camGame.visible = false;
    }
}