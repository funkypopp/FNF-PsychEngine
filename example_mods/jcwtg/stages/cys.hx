import psychlua.LuaUtils;
import states.PlayState;
var cys:FlxSprite;
var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;
function onCreate() {
    cys = new FlxSprite(0, 0).loadGraphic(Paths.image("cys"));
    cys.screenCenter();
    cys.cameras = [camGame];
    cys.scale.set(2.2, 2.2);
    cys.scrollFactor.set(1, 1);
    addBehindDad(cys);
}