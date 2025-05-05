package objects.sans;

import flixel.util.FlxDestroyUtil;
import flixel.graphics.frames.FlxFrame.FlxFrameAngle;
import states.UntunedRoguelikeState;
import flixel.FlxObject;

class Ourp extends FlxSprite
{
	/*
	 * object to follow.
	 */
	public var target:FlxObject;
	/*
	 * screen bounds for the little bastard to move around in.
	 */
	private var screenBoundsX = FlxG.width + 100;
	private var screenBoundsY = FlxG.height + 100;

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
		scale.x = poopy;
		scale.y = poopy;
		centerOffsets();
		if (FlxG.random.bool()) { // this is a 50/50 chance to spawn on the top or bottom edge of the screen to prevent unfair spawns
			x = FlxG.random.int(-100 - Std.int(width), screenBoundsX);
			y = FlxG.random.bool() ? -100 - Std.int(height) : screenBoundsY;
		} else {
			x = FlxG.random.bool() ? -100 - Std.int(width) : screenBoundsX;
			y = FlxG.random.int(-100 - Std.int(height), screenBoundsY);
		}
		updateHitbox();
	}

	public function takeDamage(damageTaken):Void
	{
		poopHealth -= damageTaken;
		UntunedRoguelikeState.score += 5;
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
			final targetX = (target.x + target.width / 2) - (width / 2);
			final targetY = (target.y + target.height / 2) - (height / 2);

			final nextX = Math.abs(targetX - this.x) * FlxMath.signOf(targetX - this.x); // i think the abs and sign of part is pointless but idc
			final nextY = Math.abs(targetY - this.y) * FlxMath.signOf(targetY - this.y);

			if (x < -100 || x > screenBoundsX || y < -100 || y > screenBoundsY) // if outside the screen bounds, heavily limit movement so it doesn't go offscreen
			{
				velocity.x = FlxMath.signOf(nextX) * (speed*15) * elapsed;
				velocity.y = FlxMath.signOf(nextY) * (speed*15)  * elapsed;
			}
			else
			{
				velocity.x += FlxMath.signOf(nextX) * speed * elapsed;
				velocity.y += FlxMath.signOf(nextY) * speed * elapsed;
			}
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
