package states;

import flixel.math.FlxAngle;
import flixel.input.keyboard.FlxKey;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.sound.FlxSound;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import substates.SansResultsSubstate;
import objects.sans.Ourp;
import objects.sans.Bullet;
import objects.Powerup;

#if ACHIEVEMENTS_ALLOWED
class AchievementsMenuState extends MusicBeatState
{
	public static var score:Int = 0;
	public static var wave:Int = 0;

	public static final BULLET_SPEED:Int = 400;

	public var sans:FlxSprite;

	var floor:FlxSprite;
	var bg:FlxSprite;
	var black:FlxSprite;

	/**
	 * value that decides which ourple will spawn next.
	 */
	var enemyIndex(default, set):Int = 1;

	function set_enemyIndex(value:Int):Int
	{
		return (enemyIndex = Math.round(FlxMath.bound(value, 1, 7)));
	}

	// blatently copying from you im so sorry :sob:
	var powerIndex(default, set):Int = 1;

	function set_powerIndex(value:Int):Int
	{
		return (powerIndex = Math.round(FlxMath.bound(value, 1, 7)));
	}

	final soundNames:Array<String> = ["sans1", "sans2", "sans3", "sans4"];

	var soundA:FlxSound = FlxG.sound.load(Paths.sound("sans1"));
	var soundD:FlxSound = FlxG.sound.load(Paths.sound("sans1"));
	var soundW:FlxSound = FlxG.sound.load(Paths.sound("sans1"));

	var deathSound:FlxSound;
	var hasDied:Bool = false;

	final bulletGroup:FlxTypedGroup<Bullet> = new FlxTypedGroup<Bullet>();
	final enemyGroup:FlxTypedGroup<Ourp> = new FlxTypedGroup<Ourp>();
	final powerupGroup:FlxTypedGroup<Powerup> = new FlxTypedGroup<Powerup>();

	override public function create()
	{
		// precache sounds
		for (i in soundNames)
			Paths.sound(i);

		super.create();

		FlxG.mouse.visible = true;

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

		deathSound = new FlxSound().loadEmbedded(Paths.sound('dead'), false);

		add(enemyGroup);
		add(bulletGroup);
		add(powerupGroup);
		spawnPower();
	}

	/**
	 * Collided with the floor. Triggers result screen.
	 */
	function onTouchFloor(obj1:FlxObject, obj2:FlxObject):Void
	{ // funky i fixed your goddamm sound ok

		hasDied = true;

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		deathSound.play();

		sans.visible = false;

		sans.kill();

		black = new FlxSprite(0, 0).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.alpha = 0;
		add(black);

		FlxTween.tween(black, {alpha: 1}, 2, {ease: FlxEase.sineInOut});
		new FlxTimer().start(2, function(t:FlxTimer)
		{
			openSubState(new SansResultsSubstate());
		});
	}

	function spawnOurp():Void
	{
		var _enemy = enemyGroup.recycle(Ourp, () -> new Ourp(enemyIndex));
		_enemy.setIndex(enemyIndex);
		_enemy.target = sans;
		enemyGroup.add(_enemy);
	}

	function spawnPower():Void
	{
		// data if you're seeing this i googled what the underscore before the variable means and now im learning
		var _powerup = powerupGroup.recycle(Powerup, () -> new Powerup());
		_powerup.setPosition(FlxG.random.int(-FlxG.width + 600, FlxG.width), 0);
		_powerup.screenCenter(Y);
		_powerup.y -= _powerup.y;
		_powerup.setIndex(powerIndex);
		_powerup.velocity.y = 200;
		powerupGroup.add(_powerup);
	}

	function spawnBullet():Void
	{
		var _bullet = bulletGroup.recycle(Bullet);
		_bullet.__garbaged = false;
		// maybe use rotated width ?
		_bullet.setPosition(sans.x + ((sans.width - _bullet.width) / 2), sans.y + ((sans.height - _bullet.height) / 2));
		bulletGroup.add(_bullet);

		_bullet.velocity.set(BULLET_SPEED);
		_bullet.velocity.degrees = FlxAngle.angleBetweenPoint(_bullet, FlxG.mouse.getPosition(), true);

		_bullet.angle = _bullet.velocity.degrees;
	}

	function doSpawnLoop():Void
	{
		new FlxTimer().start(10, function(t:FlxTimer)
		{
			spawnOurp();
		}, 0);
	}

	override public function update(elapsed:Float)
	{
		enemyIndex = FlxG.random.int(1, 7, [enemyIndex]);

		handleInputs();

		if (!hasDied)
		{
			FlxG.collide(sans, floor, onTouchFloor);

			inline function loadAndPlaySound(sound:FlxSound)
			{
				sound.loadEmbedded(Paths.sound(FlxG.random.getObject(soundNames)), true);
				sound.play();
				sound.volume = 0.5;
				return sound;
			}

			// technically less optimal but its cleaner ig
			final pressedInputs = [FlxG.keys.justPressed.A, FlxG.keys.justPressed.D, FlxG.keys.justPressed.W];
			final releasedInputs = [FlxG.keys.justReleased.A, FlxG.keys.justReleased.D, FlxG.keys.justReleased.W];
			final sounds = [soundA, soundD, soundW];

			for (i in 0...3)
			{
				if (pressedInputs[i])
					loadAndPlaySound(sounds[i]);
				else if (releasedInputs[i])
					sounds[i].stop();
			}
		}

		bulletGroup.forEachAlive(bullet ->
		{
			enemyGroup.forEachAlive(enemy ->
			{
				if (bullet.getScreenBounds().overlaps(enemy.getHitbox()))
				{
					enemy.takeDamage();
					bullet.__garbaged = true;
				}
			});
		});


		// clean up
		bulletGroup.forEachAlive(bullet ->
		{
			if (bullet.x > FlxG.width
				|| (bullet.x + bullet.width) < 0 || (bullet.y + bullet.height) < 0 || bullet.y > FlxG.height || bullet.__garbaged)
			{
				bullet.kill();
			}
		});

		super.update(elapsed);
	}

	function handleInputs()
	{
		final MOVE_SPEED = 200;
		final GRAVITY = 400;

		if (FlxG.keys.pressed.A)
		{
			sans.velocity.x = -MOVE_SPEED;
			sans.flipX = true;
		}
		else if (FlxG.keys.pressed.D)
		{
			sans.velocity.x = MOVE_SPEED;
			sans.flipX = false;
		}
		else
		{
			sans.velocity.x = 0;
		}

		if (FlxG.keys.justPressed.W)
		{
			sans.velocity.y = -GRAVITY;
		}

		#if debug
		if (FlxG.keys.justPressed.G)
		{
			spawnOurp();
		}
		#end

		if (FlxG.mouse.justPressed)
		{
			spawnBullet();
		}
	}
}
#end
