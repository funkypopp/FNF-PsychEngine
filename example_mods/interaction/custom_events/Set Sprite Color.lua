function onEvent(n,v1,v2)
	if n == 'Set Sprite Color' then
		setProperty(v1..'.color', FlxColor(v2))
	end
end