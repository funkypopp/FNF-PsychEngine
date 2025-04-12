local camX
local camY
local camXOff = 0
local camYOff = 0

function onCreate()
	setProperty('camHUD.alpha', 0)
	
	setProperty('camGame.zoom', 1)
	setProperty('camHUD.alpha', 0)

	doTweenX('camFollowX', 'camFollow', 210, 0.001, 'linear')
	doTweenY('camFollowY', 'camFollow', 500, 0.001, 'linear')
	setProperty('camFollow.x', 210)
	setProperty('camFollow.y', 100)
end
function onCreatePost()
	setProperty('isCameraOnForcedPos', true)
end

function onSongStart()
	doTweenZoom('startZoom', 'camGame', 1.3, 10.5, 'smootherStepOut')
end

function onBeatHit()
	if curBeat == 15 then
		camX = 165
		camY = 527
		doTweenZoom('startZoom2', 'camGame', 2.7, 1.5, 'quadInOut')
		doTweenX('startPosX', 'camFollow', camX, 1.5, 'quadInOut')
		doTweenY('startPosY', 'camFollow', camY, 1.5, 'quadInOut')
	elseif curBeat == 16 then
		doTweenAlpha('uiFadeIn', 'camHUD', 1, 0.1, 'linear')
	end
end
function onSectionHit()
	if curSection > 4 and curSection < 12 then
		if mustHitSection then
			camX = 260
			camY = 527
		else
			camX = 165
			camY = 527
		end
	end
end

function onUpdate()
	if curSection > 4 then
		setProperty('camFollow.x', camX+camXOff)
		setProperty('camFollow.y', camY+camYOff)
	end
end