package objects;

import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import states.AchievementsMenuState;
import flixel.FlxObject;

class Ourp extends FlxSprite
{
	/**
	 * object to follow.
	 */
	public var target:FlxObject;

	private var rand:Int;
	private var poopy:Float;
	private var speed:Int = 60;
	private var kys:Int = 1;
	private var poopHealth:Int;

	var shakeOffset:FlxPoint = new FlxPoint();
	var shakeCount:Int = 0;
	var shakeTimer:Float = 1 / 24;

	public function new(wiener:Int)
	{
		super();
		setIndex(wiener);
	}

	public function setIndex(index:Int)
	{
		if (index == 7)
		{
			poopy = FlxG.random.float(0.20, 0.30);
		}
		else
		{
			poopy = FlxG.random.float(0.40, 0.60);
		}
		poopHealth = FlxG.random.int(10, 20);
		kys = index;
		speed = FlxG.random.int(60, 120);
		loadGraphic(Paths.image('ourp/' + kys));
		x = FlxG.random.int(-1000, 1000);
		y = FlxG.random.int(-500, 500);
		scale.x = poopy;
		scale.y = poopy;
		centerOffsets();
		updateHitbox();
	}

	public function takeDamage():Void
	{
		poopHealth -= 10;
		AchievementsMenuState.score += 5;
		trace(poopHealth);
		shakeCount = 5;

        FlxTween.cancelTweensOf(this, ['color']);
        FlxTween.color(this,1,FlxColor.RED,FlxColor.WHITE);
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (shakeCount > 0)
		{
			shakeTimer -= elapsed;
			if (shakeTimer <= 0)
			{
				shakeTimer = 1 / 144;
				shakeOffset.set(FlxG.random.float(-5, 5), FlxG.random.float(-5, 5));
				shakeCount -= 1;
			}
		}
		else
		{
			shakeOffset.set();
		}

		if (poopHealth <= 0)
		{
			kill();
		}

		if (target != null)
		{
			inline function moveToward(from:Float, to:Float, delta:Float) // godot
				return Math.abs(to - from) <= delta ? to : from + FlxMath.signOf(to - from) * delta;

			final targetX = target.x + target.width / 2;
			final targetY = target.y + target.height / 2;

			final nextX = Math.abs(targetX - this.x) * FlxMath.signOf(targetX - this.x); // i think the abs and sign of part is pointless but idc
			final nextY = Math.abs(targetY - this.y) * FlxMath.signOf(targetY - this.y);

			velocity.x = moveToward(velocity.x, nextX, speed * elapsed);
			velocity.y = moveToward(velocity.y, nextY, speed * elapsed);
		}
	}

	override function drawComplex(camera:FlxCamera)
	{
		_frame.prepareMatrix(_matrix, FlxFrameAngle.ANGLE_0, checkFlipX(), checkFlipY());
		_matrix.translate(-origin.x, -origin.y);
		_matrix.scale(scale.x, scale.y);

		if (bakedRotationAngle <= 0)
		{
			updateTrig();

			if (angle != 0)
				_matrix.rotateWithTrig(_cosAngle, _sinAngle);
		}

		getScreenPosition(_point, camera).subtract(offset);
		_point.add(origin.x, origin.y);

		_point.add(shakeOffset);

		_matrix.translate(_point.x, _point.y);

		if (isPixelPerfectRender(camera))
		{
			_matrix.tx = Math.floor(_matrix.tx);
			_matrix.ty = Math.floor(_matrix.ty);
		}

		camera.drawPixels(_frame, framePixels, _matrix, colorTransform, blend, antialiasing, shader);
	}

    override function destroy() {
        super.destroy();

        shakeOffset = FlxDestroyUtil.put(shakeOffset);
    }
}
