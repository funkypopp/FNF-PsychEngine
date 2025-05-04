local stepFlag = 0

function onCreate()
	createInstance('camBG', 'flixel.FlxCamera', {0, 0, screenWidth, screenHeight})
	setProperty('camBG.scroll.x', 1)
	setProperty('camBG.scroll.y', 1)
	setProperty('camGame.bgColor') -- dont know why this makes adding a custom camera work but whatever
	setProperty('camBG.bgColor', -1)
    for _, cam in ipairs({'camGame', 'camHUD', 'camOther'}) do
        callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg(cam), false})
    end
	
    for _, cam in ipairs({'camBG', 'camGame', 'camHUD', 'camOther'}) do
		if cam == 'camGame' then
			callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cam), true})
		else
			callMethodFromClass('flixel.FlxG', 'cameras.add', {instanceArg(cam), false})
		end
    end
end
function onCreatePost()
	scaleObject('boyfriend', 0.2, 0.2)
	scaleObject('dad', 0.2, 0.2)
	updateHitbox('boyfriend')
	updateHitbox('dad')

	runHaxeCode([[
	for (key in game.boyfriend.animOffsets.keys()) {
    		game.boyfriend.animOffsets[key][0] *= game.boyfriend.scale.x;
    		game.boyfriend.animOffsets[key][1] *= game.boyfriend.scale.y;
	};
	for (key in game.dad.animOffsets.keys()) {
    		game.dad.animOffsets[key][0] *= game.dad.scale.x;
    		game.dad.animOffsets[key][1] *= game.dad.scale.y;
	};
	]])

	if shadersEnabled then
		initLuaShader('perspective')
		initLuaShader('defective lens')
	end
	
	makeLuaSprite('fl-bg', 'fl studio', 90, 75) 
	if not shadersEnabled then setProperty('fl-bg.x', -45) setProperty('fl-bg.y', 40) end
	if shadersEnabled then scaleObject('fl-bg', 0.8, 0.8) end
	setScrollFactor('fl-bg', 0.1, 0.1)
	runHaxeCode("game.getLuaObject('fl-bg').camera = getVar('camBG');")
	
	makeLuaSprite('metronome', 'metronome', 0, 0)
	if shadersEnabled then scaleObject('fl-bg', 0.8, 0.8) end
	setProperty('metronome.x', getProperty('fl-bg.x')-14)
	setProperty('metronome.y', getProperty('fl-bg.y'))
	setScrollFactor('metronome', 0.1, 0.1)
	runHaxeCode("game.getLuaObject('metronome').camera = getVar('camBG');")
	
	createInstance('tile', 'flixel.addons.display.FlxBackdrop', {})
	loadGraphic('tile', 'tile')
	setProperty('tile.alpha', 0.0)
	scaleObject('tile', 0.5, 0.5)
	setProperty('tile.velocity.x', 25)
	setProperty('tile.velocity.y', 25)
	setBlendMode('tile', 'multiply')
	setScrollFactor('tile', 0.2, 0.2)
	runHaxeCode("game.getLuaObject('tile').camera = getVar('camBG');")
	
	makeLuaSprite('shadows', 'bg', -83, 20)
	runHaxeCode("game.getLuaObject('shadows').camera = getVar('camBG');")
	setScrollFactor('shadows', 0.2, 0.2)
		
	makeLuaSprite('floor', 'floor', 16, 73)
	scaleObject('floor', 0.6, 1)
	updateHitbox('floor')
	
	makeLuaSprite('floorwall', 'whatever this is', 16, 600)
	scaleObject('floorwall', 0.6, 1)
	updateHitbox('floorwall')
	
	setPerspective('floor', 0.35)
	
	if shadersEnabled then
		makeLuaSprite("bgShader")
		makeGraphic("bgShader", screenWidth, screenHeight)
		setSpriteShader("bgShader", 'defective lens')
		runHaxeCode([[
			var game = PlayState.instance;
			getVar('camBG').setFilters([
				new ShaderFilter(game.getLuaObject("bgShader").shader)
			]);
		]])
		setShaderFloat("bgShader", "pDistortion", 2)
	end

	makeLuaSprite('darkBG', nil, -1000, -1000)
	makeGraphic('darkBG', 3000, 4000, '000000')
	updateHitbox('darkBG')
	setScrollFactor('darkBG', 0, 0)
	setProperty('darkBG.alpha', 0)
	
	addLuaSprite('fl-bg')
	addLuaSprite('metronome')
	addInstance('tile')
	addLuaSprite('shadows')
	addLuaSprite('floor')
	addLuaSprite('floorwall')
	addLuaSprite('darkBG')
end

function onSongStart()
	onSectionHit()
	onStepHit()
end

function onSectionHit()
	if songName == "my-first-song" and not (curSection >= 20 and curSection < 24) then
		setProperty('metronome.x', getProperty('fl-bg.x')-14)
		doTweenX('metronomeTween', 'metronome', (getProperty('fl-bg.width')*4)/0.85, ((curBpm/60)*4)/getProperty('playbackRate'))
	end
end
luaDebugMode = true
local stepParams = {
	{56, 'tween', 0.8, 1.5},
	{64, 0, 'flash', 0.5},
	{384, 1},
	{390, 0, 'flash', 1}
}

function onStepHit()
	if songName == "my-first-song" then
		for i, s in ipairs(stepParams) do
			if curStep >= s[1] and stepFlag <= i then
				cancelTween('theCamThatHadToStepUp')
				if (s[2] == 'tween') then
					doTweenAlpha('theCamThatHadToStepUp', 'darkBG', s[3], s[4], 'sineInOut')
				else
					setProperty('darkBG.alpha', s[2])
					if s[3] ~= nil and s[3] == 'flash' then
						cameraFlash('camBG', 'FFFFFF', s[4], true) -- Use Psych Engine's built-in camera flash
					end
				end
				incrementStepFlag()
			end
		end
	end
end

function incrementStepFlag()
	stepFlag = stepFlag + 1
end

function onUpdate()
	setProperty('floor.x', 16) -- because for some reason it slides when the characters started singing
end
function onUpdatePost()
	setProperty('camBG.zoom', 0.85+(getProperty('camGame.zoom')*0.15))
	callMethod('camBG.scroll.set', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
end

function onGameOver()
	callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camBG'), false})
end