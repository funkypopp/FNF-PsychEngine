package states;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;

#if ACHIEVEMENTS_ALLOWED
class AchievementsMenuState extends MusicBeatState
{
	var sans:FlxSprite;
	
	var floor:FlxSprite;

	var soundNames:Array<String> = ["sans1", "sans2", "sans3", "sans4"];
	
	var soundA:FlxSound = null;
	var soundD:FlxSound = null;
	var soundW:FlxSound = null;

	var deathSound:FlxSound;
	var hasDied:Bool = false;

	override public function create():Void
	{
		super.create();

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Paths.image('beautifulworld'));
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

		deathSound = new FlxSound();
		deathSound.loadEmbedded(Paths.sound('dead'), true);
	}

	override public function update(elapsed:Float):Void
	{
		function onTouchFloor(obj1:FlxObject, obj2:FlxObject):Void
			{
				if (!hasDied){ //shyge fix sound okay thanks

					deathSound.play(); 
					for (sound in FlxG.sound.list) {
						sound.stop(); 
					}

					hasDied = true;
					sans.kill(); 
				}
			}

		super.update(elapsed);

		var moveSpeed = 200;

		if (FlxG.keys.pressed.A) and (hasDied = false) {
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

		if (FlxG.keys.justPressed.A) {
			var s = FlxG.random.getObject(soundNames);
			soundA = new FlxSound();
			soundA.loadEmbedded(Paths.sound(s), true);
			soundA.play();
			FlxG.sound.list.add(soundA);
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
		} else if (FlxG.keys.justReleased.D && soundD != null) {
			soundD.stop();
			soundD = null;
		}

		if (FlxG.keys.justPressed.W) {
			var s = FlxG.random.getObject(soundNames);
			soundW = new FlxSound();
			soundW.loadEmbedded(Paths.sound(s), true);
			soundW.play();
			FlxG.sound.list.add(soundW);
		} else if (FlxG.keys.justReleased.W && soundW != null) {
			soundW.stop();
			soundW = null;
		} 
	}
}
#end