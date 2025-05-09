import psychlua.LuaUtils;
import states.PlayState;

function onCreate() {
    var bg:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("bg/interactiveBack"));
    bg.scale.set(1, 1);
    bg.screenCenter();
    bg.y += 200;
    bg.scrollFactor.set(0.8, 0.8);
    addBehindGF(bg);
    var floor:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image("bg/interactiveFront"));
    floor.scale.set(1.5, 1.5);
    floor.screenCenter();
    floor.y += 645;
    floor.cameras = [camGame];
    floor.scrollFactor.set(1, 1);
    addBehindGF(floor);
}