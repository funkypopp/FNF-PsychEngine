local changeScoreTxt = false
local scoreLerp = 0
local hudToggle = false

local function lerp(a, b, ratio)
    return math.ceil(a + ratio * (b - a))
end

function onEvent(n, v1, v2)
	if n == 'Trigger' and v1 == 'fakeout' then
		hudToggle = not hudToggle
		-- onSongStart
		if not middlescroll then
			for i = 0,3 do
				noteTweenX('balls'..i,i,getProperty('opponentStrums.members['..i..'].x')-50,0.5,'circOut')
			end
		end
		-- onCreate
		setProperty('camGame.bgColor', getColorFromHex('000000'))
		-- onCreatePost
		setProperty('timeBar.visible',false)
		setProperty('timeTxt.visible',false)
		setProperty('scoreTxt.visible',false)
		setProperty('botplayTxt.visible',false)

		if downscroll then
			makeLuaText('newScoreTxt', 'Score: 0', screenWidth-300, 150, 110)
		else
			makeLuaText('newScoreTxt', 'Score : 0', screenWidth-300, 150, 680)
		end
		setTextSize('newScoreTxt', 18)
		setProperty('newScoreTxt.camera', instanceArg('camHUD'), false, true)
		setProperty('newScoreTxt.origin.x', screenWidth/2)
		setObjectOrder('newScoreTxt', getObjectOrder('scoreTxt','uiGroup') - 1, 'uiGroup')
		addLuaText('newScoreTxt')
	end
end

function onUpdatePost()
	if hudToggle then
		setHealthBarColors('FF0066', '00FF66')

		scoreLerp = lerp(scoreLerp, score, 0.108)
		if changeScoreTxt then
			setTextString('newScoreTxt', 'Score: '..scoreLerp)
			if scoreZoom then
				local scoreTxtScale = math.min(1 + ((score - scoreLerp)/4000), 1.5)
				scaleObject('newScoreTxt', scoreTxtScale, scoreTxtScale, false)
			end
		end
		if scoreLerp == score then
			changeScoreTxt = false
		else
			changeScoreTxt = true
		end
	end
end