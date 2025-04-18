package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import substates.SansResultsSubstate;
import objects.Ourp;

#if ACHIEVEMENTS_ALLOWED
class AchievementsMenuState extends MusicBeatState
{
	public static var sans:FlxSprite;
	
	var floor:FlxSprite;
	var bg:FlxSprite;
	var black:FlxSprite;

	var rand:Int;

	var soundNames:Array<String> = ["sans1", "sans2", "sans3", "sans4"];
	
	var soundA:FlxSound = null;
	var soundD:FlxSound = null;
	var soundW:FlxSound = null;

	var deathSound:FlxSound;
	var hasDied:Bool = false;

	var enemyGroup:FlxTypedGroup<Ourp> = new FlxTypedGroup<Ourp>();
	var enemy:Ourp;

	var spawned:Bool = false;

	public static var score:Int = 0;
	public static var wave:Int = 0;

	override public function create()
	{
		super.create();

		if(FlxG.sound.music != null)
			FlxG.sound.music.stop();

		FlxG.sound.playMusic(Paths.music('sans 1'), 1);

		bg = new FlxSprite(-80).loadGraphic(Paths.image('beautifulworld'));
		bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

		sans = new FlxSprite(100, 100, Paths.image('sans'));
		sans.setGraphicSize(32, 32);
		sans.updateHitbox();
		sans.acceleration.y = 800; 
		sans.maxVelocity.set(200, 400);
		sans.drag.x = 800;
		add(sans);

		floor = new FlxSprite(0, FlxG.height - 64).makeGraphic(FlxG.width + 64, 64, FlxColor.GREEN);
		floor.immovable = true;
		floor.moves = false;
		add(floor);

		doSpawnLoop();

		deathSound = new FlxSound();
		deathSound.loadEmbedded(Paths.sound('dead'), false);

		add(enemyGroup);
	}

	function onTouchFloor(obj1:FlxObject, obj2:FlxObject):Void
	{	//funky i fixed your goddamm sound ok
		if (!hasDied){ //shyge fix sound okay thanks

			deathSound.play(); 
			if(FlxG.sound.music != null)
				FlxG.sound.music.stop();
			

			hasDied = true;
			sans.y += 1000;
			sans.kill();

			black = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
			black.alpha = 0;
			add(black);

			FlxTween.tween(black, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
			new FlxTimer().start(2, function(t:FlxTimer) {
				openSubState(new SansResultsSubstate());
			});
		}
	}

	function spawnOurp():Void {
		enemy = new Ourp(rand);
		enemyGroup.add(enemy);
		trace('spawned');

		if (!spawned) {
			spawned = true;
		}
		else {
			spawned = false;
			spawned = true;
		}
	}

	function doSpawnLoop():Void {
		new FlxTimer().start(10, function(t:FlxTimer) {
			spawnOurp();
			doSpawnLoop();
		});
	}

	override public function update(elapsed:Float)
	{
		rand = FlxG.random.int(1, 7);

		var moveSpeed = 200;

		if (FlxG.keys.pressed.A) {
			sans.velocity.x = -moveSpeed;
			sans.flipX = true;
		} else if (FlxG.keys.pressed.D) {
			sans.velocity.x = moveSpeed;
			sans.flipX = false;
		} else {
			sans.velocity.x = 0;
		}

		if (FlxG.keys.justPressed.W) {
			sans.velocity.y = -400;
		}

		FlxG.collide(sans, floor, onTouchFloor);

		if (!hasDied) {
			if (FlxG.keys.justPressed.A) {
				var s = FlxG.random.getObject(soundNames);
				soundA = new FlxSound();
				soundA.loadEmbedded(Paths.sound(s), true);
				soundA.play();
				FlxG.sound.list.add(soundA);
				soundA.volume = 0.5;
			} else if (FlxG.keys.justReleased.A && soundA != null) {
				soundA.stop();
				soundA = null;
			}
	
			if (FlxG.keys.justPressed.D) {
				var s = FlxG.random.getObject(soundNames);
				soundD = new FlxSound();
				soundD.loadEmbedded(Paths.sound(s), true);
				soundD.play();
				FlxG.sound.list.add(soundD);
				soundD.volume = 0.5;
			} else if (FlxG.keys.justReleased.D && soundD != null) {
				soundD.stop();
				soundD = null;
			}
	
			if (FlxG.keys.justPressed.W) {
				var s = FlxG.random.getObject(soundNames);
				soundW = new FlxSound();
				soundW.loadEmbedded(Paths.sound(s), true);
				soundW.play();
				soundW.volume = 0.5;
				FlxG.sound.list.add(soundW);
			} else if (FlxG.keys.justReleased.W && soundW != null) {
				soundW.stop();
				soundW = null;
			} 
		}

		super.update(elapsed);
	}
}
#end