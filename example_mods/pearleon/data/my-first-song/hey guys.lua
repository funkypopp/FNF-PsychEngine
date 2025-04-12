function onCreate()
	makeLuaSprite('black', 'black', 0, 0)
	addLuaSprite('black', false)
	makeLuaSprite('black2', 'black', 0, 360)
	addLuaSprite('black2', false)
	
	makeGraphic('black', 1280, 360, '000000')
	setObjectCamera('black', 'camOther')
	makeGraphic('black2', 1280, 360, '000000')
	setObjectCamera('black2', 'camOther')
end

function onSongStart()
	doTweenY('blackuptween', 'black', -190, 2, 'expoOut')
	doTweenY('blackdowntween', 'black2', 520, 2, 'expoOut')
end

function onBeatHit()
	if curBeat == 15 then
		doTweenY('blackuptweenfinal', 'black', -360, (curBpm/60)/4, 'expoIn')
		doTweenY('blackdowntweenfinal', 'black2', 720, (curBpm/60)/4, 'expoIn')
	end
end

function onTweenComplete(t)
	if t == 'blackuptweenfinal' then
		removeLuaSprite('black', true)
		removeLuaSprite('black2', true)
	end
end