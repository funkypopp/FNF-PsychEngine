import psychlua.LuaUtils;
import states.PlayState;

function onCreate() {
    var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("alley"));
    bg.scale.set(2, 2);
    bg.screenCenter();
    bg.y -= 200;
    bg.cameras = [camGame];
    bg.scrollFactor.set(1, 1);
    addBehindGF(bg);
}