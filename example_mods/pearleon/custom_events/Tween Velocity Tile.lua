function onCreatePost()
	runHaxeCode([[
		var eTween1:FlxTween = null;
		var eTween2:FlxTween = null;
		setVar('eTween1', eTween1);
		setVar('eTween2', eTween2);
	]])
end

function onEvent(n, v1, v2)
	if n == "Tween Velocity Tile" then
		runHaxeCode([[
			var eTween1 = getVar('eTween1');
			var eTween2 = getVar('eTween2');
			if (eTween1 != null) {
				eTween1.cancel();
				eTween1 = null;
			}
			
			if (eTween2 != null) {
				eTween2.cancel();
				eTween2 = null;
			}

			eTween1 = FlxTween.num(]]..v1..[[, 25, ]]..v2..[[, {ease: FlxEase.quintOut}, v -> {
				game.getLuaObject('tile').velocity.x = v;
				game.getLuaObject('tile').velocity.y = v;
			});
			
			eTween2 = FlxTween.num(0.75, 0.25, ]]..v2..[[, {ease: FlxEase.quintOut}, v -> {game.getLuaObject('tile').alpha = v;});
			setVar('eTween1', eTween1);
			setVar('eTween2', eTween2);
		]])
	end
end