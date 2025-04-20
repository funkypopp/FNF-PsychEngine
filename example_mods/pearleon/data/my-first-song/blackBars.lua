local closePercentage = 0

function moveBars(tag, percent, dur, tween)
	local y1 = -360 + (percent/100) * 360
	local y2 = 720 - (percent/100) * 360

	if not tween then tween = 'linear' end
	doTweenY('bbTweenTop-'..tag, 'topBlackBar', y1, dur, tween)
	doTweenY('bbTweenBottom-'..tag, 'bottomBlackBar', y2, dur, tween)
end

function onCreate()
	makeLuaSprite('topBlackBar', _, 0, -360)
	addLuaSprite('topBlackBar', false)
	makeLuaSprite('bottomBlackBar', _, 0, 720)
	addLuaSprite('bottomBlackBar', false)
	
	makeGraphic('topBlackBar', 1280, 360, '000000')
	setObjectCamera('topBlackBar', 'camOther')
	makeGraphic('bottomBlackBar', 1280, 360, '000000')
	setObjectCamera('bottomBlackBar', 'camOther')
end

function onTweenCompleted(t)
	if songName == 'my-first-song' then
		if t == 'bbTweenBottom-blink' then
			moveBars('blink2', 100, 0.1)
		elseif t == 'bbTweenBottom-blink2' then
			removeLuaSprite('album', true)
			loadGraphic('shadows', 'bg')
			moveBars('', 0, 0.5, 'expoOut')
		end
	end
end