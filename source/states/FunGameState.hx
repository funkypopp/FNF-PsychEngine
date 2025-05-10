package states;

class FunGameState extends MusicBeatState
{
    public var initialized:Bool = false;
    var text:FlxSprite;
    var bg:FlxSprite;
    var button:FlxSprite;
    override public function create()
    {
        super.create();
        FlxG.camera.flash(FlxColor.BLACK, 15);
        FlxG.mouse.visible = true;
        FlxG.sound.playMusic(Paths.music('title loop mycosis'), 1);

        bg = new FlxSprite(-75, -50).loadGraphic(Paths.image('mycosis_intro_bg_image_'));
        bg.scale.set(0.6, 0.6);
        add(bg);

        text = new FlxSprite(300, 25);
        text.frames = Paths.getSparrowAtlas('titletextdead');
        text.animation.addByPrefix('text', 'title text', 24, true);
        text.animation.play('text');
        text.scale.set(0.6, 0.6);
        add(text);

        button = new FlxSprite(350, 350).loadGraphic(Paths.image('play_now'));
        button.scale.set(0.6, 0.6);
        add(button);
    }
}