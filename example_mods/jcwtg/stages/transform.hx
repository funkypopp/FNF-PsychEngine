import psychlua.LuaUtils;
import states.PlayState;
var transform:FlxSprite;
var midX = FlxG.width / 2;
var midY = (FlxG.height / 2) + 200;
function onCreate() {
    transform = new FlxSprite(0, 0).loadGraphic(Paths.image("transform"));
    transform.screenCenter();
    transform.cameras = [camGame];
    transform.scale.set(3, 3);
    transform.scrollFactor.set(1, 1);
    addBehindDad(transform);
}