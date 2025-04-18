package substates;

import states.AchievementsMenuState;
import lime.app.Application;

class SansResultsSubstate extends MusicBeatSubstate
{

    var scoreTxt:FlxText;
	var waveTxt:FlxText;
	var waveNum:FlxText;

    var resultsMusic:FlxSound = null;

    override public function create() {
        var dancingSans:FlxSprite = new FlxSprite((FlxG.width / 2) * 1.2, (FlxG.height / 2) - 250);
        dancingSans.frames = Paths.getSparrowAtlas('untunedsansstuff/sans_results_dance');
        dancingSans.animation.addByPrefix('dance', 'unlock', 12, true);
        dancingSans.animation.play('dance', true);

        scoreTxt = new FlxText(50, -300, 0, "SCORE: " + AchievementsMenuState.score);
        scoreTxt.setFormat(Paths.font('undertale.ttf'), 48, FlxColor.WHITE, "right", 0xFF000000);
        add(scoreTxt);
        scoreTxt.screenCenter();
        scoreTxt.x -= 450;
        scoreTxt.visible = false;

        waveTxt = new FlxText(50, -150, 0, "FINAL WAVE:");
        waveTxt.setFormat(Paths.font('undertale.ttf'), 48, FlxColor.WHITE, "left", 0xFF000000);
        add(waveTxt);
        waveTxt.screenCenter();
        waveTxt.x -= 400;
        waveTxt.y += 150;
        waveTxt.visible = false;

        waveNum = new FlxText(50, 0, 0, '0000');
        waveNum.setFormat(Paths.font('undertale.ttf'), 128, FlxColor.WHITE, "left", 0xFF000000);
        add(waveNum);  
        waveNum.screenCenter();
        waveNum.x -= 410;
        waveNum.y += 250;
        waveNum.visible = false;

        add(dancingSans);

        resultsMusic = new FlxSound();
        resultsMusic.loadEmbedded(Paths.music('sans results'), false);
        resultsMusic.play();
        resultsMusic.onComplete = function() {
            Application.current.window.alert("You're a faggot", "oops");
            #if DISCORD_ALLOWED
            DiscordClient.shutdown();
            #end
            Sys.exit(1);
        }
        new FlxTimer().start(1.8, function(t:FlxTimer) {
            scoreTxt.visible = true;
            trace('kms');
            new FlxTimer().start(0.6, function(t:FlxTimer) {
                trace('kms2');
                waveTxt.visible = true;
                waveNum.visible = true;
            });
        });
    }
}