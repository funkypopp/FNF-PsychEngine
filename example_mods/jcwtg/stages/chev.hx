import psychlua.LuaUtils;
import states.PlayState;
var chev:FlxSprite;
var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;
function onCreate() {
    chev = new FlxSprite(300, 450).loadGraphic(Paths.image("chev"));
    chev.cameras = [camGame];
    chev.scale.set(3, 3);
    chev.scrollFactor.set(1, 1);
    addBehindDad(chev);
}