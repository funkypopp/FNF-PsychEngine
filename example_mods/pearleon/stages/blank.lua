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
	addHaxeLibrary("ShaderFilter", "openfl.filters")
	
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

	initLuaShader('perspective')
	initLuaShader('defective lens')
	
	makeLuaSprite('fl-bg', 'fl studio', 90, 90)
	scaleObject('fl-bg', 0.8, 0.8)
	setScrollFactor('fl-bg', 0.1, 0.1)
	runHaxeCode("game.getLuaObject('fl-bg').camera = getVar('camBG');")
	
	makeLuaSprite('metronome', 'metronome', 0, 0)
	scaleObject('fl-bg', 0.8, 0.8)
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
	
	makeLuaSprite("bgShader")
	makeGraphic("bgShader", screenWidth, screenHeight)
	setSpriteShader("bgShader", 'defective lens')
	addHaxeLibrary("ShaderFilter", "openfl.filters")
	runHaxeCode([[
		var game = PlayState.instance;
		getVar('camBG').setFilters([
			new ShaderFilter(game.getLuaObject("bgShader").shader)
			]);
	]])
	setShaderFloat("bgShader", "pDistortion", 2)
	
	addLuaSprite('fl-bg')
	addLuaSprite('metronome')
	addInstance('tile')
	addLuaSprite('shadows')
	addLuaSprite('floor')
	addLuaSprite('floorwall')
end

function onSongStart()
	onSectionHit()
end

function onSectionHit()
	setProperty('metronome.x', getProperty('fl-bg.x')-14)
	doTweenX('metronomeTween', 'metronome', (getProperty('fl-bg.width')*4)/0.85, ((curBpm/60)*4)/getProperty('playbackRate'))
end

function onUpdate()
	setProperty('floor.x', 16) -- because for some reason it slides when the characters started singing
end
function onUpdatePost()
	setProperty('camBG.zoom', 0.8+(getProperty('camGame.zoom')*0.15))
	callMethod('camBG.scroll.set', {getProperty('camGame.scroll.x'), getProperty('camGame.scroll.y')})
end

function onGameOver()
	callMethodFromClass('flixel.FlxG', 'cameras.remove', {instanceArg('camBG'), false})
end