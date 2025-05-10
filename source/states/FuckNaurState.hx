package states;

import states.PlayState;
import objects.VideoSprite;

class FuckNaurState extends MusicBeatState {

	public var videoCutscene:VideoSprite = null;

	public function startVideo(name:String, forMidSong:Bool = false, canSkip:Bool = true, loop:Bool = false, playOnLoad:Bool = true)
	{
		#if VIDEOS_ALLOWED

		var foundFile:Bool = false;
		var fileName:String = Paths.video(name);

		#if sys
		if (FileSystem.exists(fileName))
		#else
		if (OpenFlAssets.exists(fileName))
		#end
		foundFile = true;

		if (foundFile)
		{
			videoCutscene = new VideoSprite(fileName, forMidSong, canSkip, loop);
			// if(forMidSong) videoCutscene.videoSprite.bitmap.rate = playbackRate;

			add(videoCutscene);

			if (playOnLoad)
				videoCutscene.play();
			return videoCutscene;
		}
		else FlxG.log.error("Video not found: " + fileName);
        #end
		return null;
	}

    override public function create() {
        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();
        
        super.create();
        
        startVideo('mycosissss', false, false, false, true);
        new FlxTimer().start(33.5, function(t:FlxTimer) {
            MusicBeatState.switchState(new FunGameState());
        });
    }
}