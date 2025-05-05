local camX = 0
local camY = 0

function smoothCam(t, x, y, dur, tween, zoom)
	runHaxeCode([[
		import backend.MusicBeatState;
		import psychlua.LuaUtils;
	]])
	if not tween then tween = 'linear' end
	if not dur then dur = 0.0001 else dur = dur / playbackRate end
	
	local prevCamX, prevCamY = camX, camY
	if x and (x ~= camX) then
		runHaxeCode([[
			var tag = ']]..t..[[' + 'X';
			
			var target:Dynamic = LuaUtils.tweenPrepare(tag, 'camFollow');
			var variables = MusicBeatState.getVariables();
			if(tag != 'X')
			{
				var variables = MusicBeatState.getVariables();
				var originalTag:String = tag;
				tag = LuaUtils.formatVariable('tween_$tag');
				
				variables.set(tag, FlxTween.num(]]..prevCamX..[[, ]]..x..[[, ]]..dur..[[, { ease: LuaUtils.getTweenEaseByString(']]..tween..[['),
					onComplete: function(twn:FlxTween)
					{
						variables.remove(tag);
						if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag]);
					}
				},
					(twX) -> {
						setVar('twX', twX);
					}
				));
			}
		]])
		camX = x
	end
	if y and (y ~= camY) then
		runHaxeCode([[
			var tag = ']]..t..[[' + 'Y';
			
			var target:Dynamic = LuaUtils.tweenPrepare(tag, 'camFollow');
			var variables = MusicBeatState.getVariables();
			if(tag != 'Y')
			{
				var variables = MusicBeatState.getVariables();
				var originalTag:String = tag;
				tag = LuaUtils.formatVariable('tween_$tag');
				
				variables.set(tag, FlxTween.num(]]..prevCamY..[[, ]]..y..[[, ]]..dur..[[, { ease: LuaUtils.getTweenEaseByString(']]..tween..[['),
					onComplete: function(twn:FlxTween)
					{
						variables.remove(tag);
						if(PlayState.instance != null) PlayState.instance.callOnLuas('onTweenCompleted', [originalTag]);
					}
				},
					(twY) -> {
						setVar('twY', twY);
					}
				));
			}
		]])
		camY = y
	end
	if zoom then
		doTweenZoom(t..'Zoom', 'camGame', zoom, dur, tween)
		setProperty('defaultCamZoom', zoom)
	end
end

function onCreate()
	setProperty('camHUD.alpha', 0)
	
	setProperty('camGame.zoom', 1)
	setProperty('camHUD.alpha', 0)

	smoothCam('camFollow', 210, 500, 0.01)
	
	makeLuaSprite('album', 'tohobossanova', 150, 0) 
	if shadersEnabled then scaleObject('album', 0.65, 0.8) else scaleObject('album', 0.8, 0.8) end
	updateHitbox('album')
	setProperty('album.alpha', 0.5)
	setScrollFactor('album', 0.1, 0.1)
	runHaxeCode("game.getLuaObject('album').camera = getVar('camBG');")
	setObjectOrder('album', getObjectOrder('shadows'))
end
function onCreatePost()
	setProperty('isCameraOnForcedPos', true)
	callScript('data/my-first-song/blackBars', 'moveBars', {'', 100, 0.01})
end

function onSongStart()
	doTweenZoom('startZoom', 'camGame', 1.3, 10.5/playbackRate, 'smootherStepOut')
	callScript('data/my-first-song/blackBars', 'moveBars', {'', 50, 2, 'expoOut'})
end

function onBeatHit()
	if curBeat == 15 then
		doTweenZoom('startZoom2', 'camGame', 2.7, 1.5/playbackRate, 'quintInOut')
		smoothCam('startPos', 165, 527, 2, 'cubeInOut')
		callScript('data/my-first-song/blackBars', 'moveBars', {'Start', 0, (curBpm/60)/4, 'expoIn'})
	elseif curBeat == 16 then
		doTweenAlpha('uiFadeIn', 'camHUD', 1, 0.1, 'linear')
	elseif curBeat == 46 then
		doTweenAlpha('fl-gobyebye', 'fl-bg', 0, 1.5, 'quadIn')
		smoothCam('okletsdothisok', 210, 475, ((curBpm/60)/2)-0.25, 'cubeInOut', 1.5)
	elseif curBeat == 78 then
		smoothCam('postobf', 310, 527, (curBpm/60)/2, 'quadOut')
		doTweenZoom('zoomtobf', 'camGame', 3.33, ((curBpm/60)/2)/playbackRate, 'quartIn')
		setProperty('defaultCamZoom', 3.25)
		doTweenAngle('angletobf', 'camGame', -75, ((curBpm/60)/2)/playbackRate, 'expoIn')
	elseif curBeat == 79 then
		callScript('data/my-first-song/blackBars', 'moveBars', {'', 100, (curBpm/60)/4, 'sineOut'})
	elseif curBeat == 81 then
		loadGraphic('shadows', 'bg-nomario')
		addLuaSprite('album')
		setProperty('camGame.alpha', 0)
		setProperty('camBG.alpha', 0)
		setProperty('camHUD.alpha', 0)
		callScript('data/my-first-song/blackBars', 'moveBars', {'', 0, 0.01})
		doTweenAlpha('camGameA', 'camGame', 1, 5/playbackRate)
		doTweenAlpha('camBGA', 'camBG', 1, 5/playbackRate)
		cancelTween('zoomtobf'); cancelTween('angletobf'); cancelTween('angletobf2');
		setProperty('camGame.angle', 0)
		doTweenZoom('zoomOut', 'camGame', 2.7, 10/playbackRate, 'quartOut')
		setProperty('defaultCamZoom', 2.7)
	elseif curBeat == 86 then
		doTweenAlpha('camHUDA', 'camHUD', 1, (curBpm/60)/2)
	elseif curBeat == 95 then
		doTweenZoom('zoomIn', 'camGame', 2.9, ((curBpm/60)/4)/playbackRate, 'quartOut')
		callScript('data/my-first-song/blackBars', 'moveBars', {'blink', 33, (curBpm/60)/5, 'expoOut'})
	elseif curBeat == 96 then
		smoothCam('snapZoom', 165, 527, nil, 'linear', 3.5)
		doTweenZoom('zoomIn', 'camGame', 3.3, ((curBpm/60)/4)/playbackRate, 'expoIn')
	elseif curBeat == 97 then
		smoothCam('okdoitagainok', 210, 475, (curBpm/60)/8, 'cubeInOut', 1.5)
	elseif curBeat == 111 then
		cancelTween('bamZoom')
		doTweenZoom('zoomIn', 'camGame', 2.95, ((curBpm/60)/4)/playbackRate, 'expoIn')
		callScript('data/my-first-song/blackBars', 'moveBars', {'', 33, (curBpm/60)/5, 'expoOut'})
	elseif curBeat == 112 then
		callScript('data/my-first-song/blackBars', 'moveBars', {'', 0, 0.1})
	elseif curBeat == 143 then
		callScript('data/my-first-song/blackBars', 'moveBars', {'', 100, (curBpm/60)/4, 'expoIn'})
	end
end
function onSectionHit()
	if (curSection > 4 and curSection < 12) or (curSection >= 20 and curSection < 24) or (curSection >= 28 and curSection < 32) then
		if curSection == 28 then setProperty('defaultCamZoom', 2.7) end
		if mustHitSection then
			smoothCam('sectionCam', 260, 527, 2.75, 'expoOut')
		else
			smoothCam('sectionCam', 165, 527, 2.75, 'expoOut')
		end
	elseif curSection == 32 then
		smoothCam('camFollow', 210, 500, 3, 'quartOut')
		doTweenZoom('okbyeguys', 'camGame', 1.5, 10.5/playbackRate, 'sineIn')
		setProperty('defaultCamZoom', 1.3)
		doTweenAlpha('fl-welcomebackgoat', 'fl-bg', 1, 2.55, 'linear')
	end
end

function onUpdate()
	callMethod('camFollow.setPosition', {getVar('twX'), getVar('twY')})
	callMethod('camGame.snapToTarget', {''})
end