package states;

import states.PlayState;
import states.LoadingState;
import backend.Highscore;
import backend.Song;
import backend.WeekData;

class FunGameState extends MusicBeatState
{
    public var initialized:Bool = false;
    public var poop:Bool = false;
    var text:FlxSprite;
    var bg:FlxSprite;
    var button:FlxSprite;
    var bgs:FlxSprite;
    var pixel:FlxSprite;
    var levelNum:Int = 0;
    override public function create()
    {
        super.create();

        #if LUA_ALLOWED
		Mods.pushGlobalMods();
		#end
		Mods.loadTopMod();

        FlxG.camera.flash(FlxColor.BLACK, 15);
        FlxG.mouse.visible = true;
        FlxG.sound.playMusic(Paths.music('title fucker'), 1);

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
        
        bgs = new FlxSprite(0, 0).loadGraphic(Paths.image('bg1'));
        bgs.screenCenter();
        add(bgs);
        bgs.visible = false;

        pixel = new FlxSprite(0, 0).makeGraphic(24, 24, FlxColor.BLACK, true);
        pixel.scale.set(1.5, 1.5);
        add(pixel);
        pixel.visible = false;
    }

    public function loadLevel(lvlNum:Int) {
        poop = false;
        levelNum += lvlNum;
        FlxG.sound.music.pause();
        FlxG.camera.flash(FlxColor.BLACK, FlxG.random.float(4, 6));
        FlxG.mouse.visible = false;
        if (levelNum == 7) {
            new FlxTimer().start(FlxG.random.float(2, 4), function(t:FlxTimer) {
                WeekData.reloadWeekFiles(true);
                PlayState.SONG = Song.loadFromJson('mycosis', 'mycosis');
                PlayState.isStoryMode = true;
                PlayState.storyDifficulty = 1;
                PlayState.storyPlaylist = ['mycosis'];
                PlayState.storyWeek = WeekData.weeksList.indexOf('mycosis');
                MusicBeatState.switchState(new PlayState());
            });
        }
        else {
            FlxG.camera.shake(0.01, 0.2);
            bgs.loadGraphic(Paths.image('bg' + levelNum));
            bgs.screenCenter();
            new FlxTimer().start(FlxG.random.float(2, 4), function(t:FlxTimer) {
                FlxG.mouse.visible = true;
                bgs.visible = true;
                spawnPixel(0.9);
                FlxG.sound.music.play();
                poop = true;
            });
        }
    }

    public function spawnPixel(poopy:Float) {
        pixel.scale.set(pixel.scale.x * poopy, pixel.scale.y * poopy);
        pixel.x = FlxG.random.float(0, FlxG.width - pixel.width);
        pixel.y = FlxG.random.float(0, FlxG.height - pixel.height);
        pixel.visible = true;
    }

    override public function update(elapsed:Float):Void
    {
        super.update(elapsed);
        if (!initialized && !poop)
        {
            if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(button))
                {
                    if (FlxG.random.bool(0.25))
                    {
                        button.x = FlxG.random.float(0, FlxG.width - button.width);
                        button.y = FlxG.random.float(0, FlxG.height - button.height);
                    }
                    else
                    {
                        initialized = true;
                        bg.kill();
                        text.kill();
                        button.kill();
                        loadLevel(1);
                    }
                }
        }
        else if (poop && initialized) {
            if (FlxG.mouse.justPressed && FlxG.mouse.overlaps(pixel)) {
                pixel.visible = false;
                bgs.visible = false;
                loadLevel(1);
            }
        }
    }
}