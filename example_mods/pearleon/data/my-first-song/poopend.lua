function onCreate()
	makeLuaSprite('endscreen', 'poop', 0, 0)
	setObjectCamera('endscreen', 'camOther')
end

function onBeatHit()
	if curBeat == 48 then
		addLuaSprite('endscreen', true)
		setPropertyFromClass('flixel.FlxG', 'sound.music.volume', 0)
	elseif curBeat > 48 then
		endSong()
	end
end