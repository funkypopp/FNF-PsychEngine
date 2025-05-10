local fakeoutBg = false

local shadersAffectedObjects = {
    'boyfriend', 'bfReflect',
    'gf', 'gfReflect',
    'dad',
    'interactivePlanet',
    'interactivePlanetShadow',
}

local shadersArray = {
    {name = 'none', hue = 0, saturation = 0, brightness = 0, contrast = 0},
    {name = 'normal', hue = -15, saturation = -10, brightness = -25, contrast = 0},
    {name = 'sunset', hue = 5, saturation = 15, brightness = 0, contrast = 5},
    {name = 'bright', hue = 0, saturation = 100, brightness = 100, contrast = 100},
}

function onCreate()
    precacheImage('bg/interactivePlanet')
    precacheImage('bg/interactivePlanetShadow')
    -- Create the background sprite
    makeLuaSprite('interactiveBack', 'bg/interactiveBack', -750, -200)
    setScrollFactor('interactiveBack', 0.6, 0.6)
    addLuaSprite('interactiveBack', false)

    -- Create the foreground sprite
    makeLuaSprite('interactiveFront', 'bg/interactiveFront', -750, 630)
    setScrollFactor('interactiveFront', 1.0, 1.0)
    scaleObject('interactiveFront', 1.0, 1.2)
    addLuaSprite('interactiveFront', false)
end

function shaderFunc(typeUse, range)
    if range == nil or range == '' then range = {1,#shadersAffectedObjects} end
    if (shadersEnabled) then
        for i = range[1],range[2] do
            setSpriteShader(shadersAffectedObjects[i], 'adjustColor')
            setShaderFloat(shadersAffectedObjects[i], 'hue', shadersArray[typeUse].hue)
            setShaderFloat(shadersAffectedObjects[i], 'saturation', shadersArray[typeUse].saturation)
            setShaderFloat(shadersAffectedObjects[i], 'brightness', shadersArray[typeUse].brightness)
            setShaderFloat(shadersAffectedObjects[i], 'contrast', shadersArray[typeUse].contrast)
        end
    end
end

function fakeoutBg()
    fakeoutBg = not fakeoutBg
    doTweenAlpha('interactiveBackTween', 'interactiveBack', 0, 0.5, 'circOut')
    doTweenAlpha('interactiveFrontTween', 'interactiveFront', 0, 0.5, 'circOut')
    doTweenX('dadTween', 'dadGroup', getProperty('dadGroup.x')-100, 0.5, 'circOut')
    doTweenX('bfTween', 'boyfriendGroup', getProperty('boyfriendGroup.x')+100, 0.5, 'circOut')

    makeLuaSprite('interactivePlanetShadow', 'bg/interactivePlanetShadow', -6250, 500)
    setScrollFactor('interactivePlanetShadow', 1.0, 1.0)
    scaleObject('interactivePlanetShadow', 1.75, 1.75)
    addLuaSprite('interactivePlanetShadow', false)
    setObjectOrder('interactivePlanetShadow', getObjectOrder('gfReflect')-1)
    setProperty('interactivePlanetShadow.alpha', 0)

    makeLuaSprite('interactivePlanet', 'bg/interactivePlanet', -6250, 500)
    setScrollFactor('interactivePlanet', 1.0, 1.0)
    scaleObject('interactivePlanet', 1.75, 1.75)
    addLuaSprite('interactivePlanet', false)
    setObjectOrder('interactivePlanet', getObjectOrder('gfReflect')-2)

    makeLuaSprite('sunEffect', '', -6000, -2000)
    makeGraphic('sunEffect', 3250, 3250, 'white')
    scaleObject('sunEffect', 4, 4)
    setScrollFactor('sunEffect', 0.02, 0.02)
    setProperty('sunEffect.alpha', 1)
    addLuaSprite('sunEffect', false)
    setSpriteShader('sunEffect', 'sun')
    setObjectOrder('sunEffect', getObjectOrder('gfReflect')-3)

    createInstance('interactiveSpace', 'flixel.addons.display.FlxBackdrop', {nil, 0x11, 0})
    scaleObject('interactiveSpace', 3,3)
    loadGraphic('interactiveSpace', 'bg/space')
    setProperty('interactiveSpace.camera', instanceArg('camGame'), false, true)
    setProperty('interactiveSpace.velocity.x', 60)
    setProperty('interactiveSpace.velocity.y', 30)
    setScrollFactor('interactiveSpace', 0, 0)
    setObjectOrder('interactiveSpace', getObjectOrder('gfReflect')-4)
    addInstance('interactiveSpace', false)

    for i = 0, getProperty('playerStrums.length') - 1 do
        setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/NOTE_assets-ftt')
    end

    for i = 0, getProperty('opponentStrums.length') - 1 do
        setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/NOTE_assets-ftt')
    end

    setProperty('noteSplashTexture', 'noteSplashes/noteSplashes-ftt')
end

function onCreatePost()
    -- BOYFRIEND
	bfpath = 'characters/bfFTT/bfFTTweek1'
	bfframe = getProperty('boyfriend.atlas.anim.curSymbol.name')
	bfx = getProperty('boyfriend.x') - 12

	bfoffsetX = getProperty('boyfriend.offset.x')
	bfoffsetY = getProperty('boyfriend.offset.y')

	makeFlxAnimateSprite('bfReflect', bfx-800, 0, bfpath..'reflect')
	setObjectOrder('bfReflect', getObjectOrder('boyfriendGroup')-1)
	addLuaSprite('bfReflect', false)

	setProperty('bfReflect.offset.x',bfoffsetX)
	setProperty('bfReflect.offset.y',bfoffsetY)
	setProperty('bfReflect.flipX', false)
	setProperty('bfReflect.y',(getProperty('boyfriend.y')) + getProperty('boyfriend.frameHeight')*getProperty('boyfriend.scale.y') + 10)
	-- GF
	makeLuaSprite('gfReflect','characters/gfFTT/reflectionGF',210,760)
	setObjectOrder('gfReflect', getObjectOrder('gfGroup')-1)
	addLuaSprite('gfReflect',false)
	-- end

    setScrollFactor('gfGroup', 1, 1)
    initLuaShader('adjustColor')
    shaderFunc(1)

    for i = 0, getProperty('playerStrums.length') - 1 do
        setPropertyFromGroup('playerStrums', i, 'texture', 'noteSkins/NOTE_assets')
    end

    for i = 0, getProperty('opponentStrums.length') - 1 do
        setPropertyFromGroup('opponentStrums', i, 'texture', 'noteSkins/NOTE_assets')
    end
end

function onUpdate()
    bfframe = getProperty('boyfriend.atlas.anim.curSymbol.name')
    bfcurframe = getProperty('boyfriend.atlas.anim.curSymbol.curFrame')
    bfindices = nil
    if string.find(bfframe, "left") then
        bfframe = 'reflectionBFleft'
        bfoffsetX = 62
        bfoffsetY = 64
    elseif string.find(bfframe, "down") or string.find(bfframe, "danceMid") then
        bfframe = 'reflectionBFdown'
        bfoffsetX = 33
        bfoffsetY = -117
    elseif string.find(bfframe, "up") then
        bfframe = 'reflectionBFup'
        bfoffsetX = -38
        bfoffsetY = 108
    elseif string.find(bfframe, "right") then
        bfframe = 'reflectionBFright'
        bfoffsetX = -27
        bfoffsetY = 35
    elseif string.find(bfframe, "results") or string.find(bfframe, "loop") then
        bfframe = 'reflectionBFidle'
        bfoffsetX = 0
        bfoffsetY = 0
        bfcurframe = 12
    else
        bfframe = 'reflectionBFidle'
        bfoffsetX = 0
        bfoffsetY = 0
    end
    if bfindices ~= nil then
        addAnimationBySymbolIndices('bfReflect', 'b', bfframe, bfindices, 1, true, 0, 0)
    else
        addAnimationBySymbol('bfReflect', 'b', bfframe, 1, true, 0, 0)
    end
    playAnim('bfReflect', 'b', true)
    setProperty('bfReflect.anim.curSymbol.curFrame', bfcurframe)
    setProperty('bfReflect.offset.x', bfoffsetX)
    setProperty('bfReflect.offset.y', bfoffsetY)
    setProperty('bfReflect.x', getProperty('boyfriend.x') - 12)
    setProperty('bfReflect.y', (getProperty('boyfriend.y')) + getProperty('boyfriend.frameHeight')*getProperty('boyfriend.scale.y') + 10)
end

function onEvent(n,v1,v2)
    if n == 'Trigger' then
        if v1 == 'fakeoutBg' then
            fakeoutBg()
            shaderFunc(2)
        elseif v1 == 'shadow' then
            setProperty('interactivePlanetShadow.alpha', 1)
            doTweenAlpha('interactivePlanetShadowTween', 'interactivePlanetShadow', 0, 15, 'sineIn')
            setProperty('boyfriendGroup.color', getColorFromHex('000000'))
            setProperty('gfGroup.color', getColorFromHex('000000'))
            setProperty('dadGroup.color', getColorFromHex('000000'))
            setProperty('bfReflect.color', getColorFromHex('000000'))
            setProperty('gfReflect.color', getColorFromHex('000000'))
            doTweenColor('bfTween', 'boyfriendGroup', 'ffffff', 15, 'sineIn')
            doTweenColor('gfTween', 'gfGroup', 'ffffff', 15, 'sineIn')
            doTweenColor('dadTween', 'dadGroup', 'ffffff', 15, 'sineIn')
            doTweenColor('bfReflectTween', 'bfReflect', 'ffffff', 15, 'sineIn')
            doTweenColor('gfReflectTween', 'gfReflect', 'ffffff', 15, 'sineIn')
            setObjectOrder('dimBg', getObjectOrder('sunEffect'))
            doTweenY('sunEffectTween', 'sunEffect', getProperty('sunEffect.y') - 5000, 15, 'sineOut')
            shaderFunc(3)
        elseif v1 == 'coolColor' then
            doTweenColor('dimBgTween', 'dimBg', 'ff66bb', 6, 'sineInOut')
        elseif v1 == 'skyanultra' then
            for i = 3,#shadersAffectedObjects do
                setProperty(shadersAffectedObjects[i]..'.visible', false)
            end
            removeSpriteShader('sunEffect')
            if v2 == 'again' then
                shaderFunc(2,{1,2})
            else
                shaderFunc(4,{1,2})
            end
        elseif v1 == 'fade1' then
            cameraFade('game', 'ffffff', 1.1, true, false)
        elseif v1 == 'skyannopetra' then
            for i = 3,#shadersAffectedObjects do
                setProperty(shadersAffectedObjects[i]..'.visible', true)
            end
            shaderFunc(3)
            setSpriteShader('sunEffect', 'sun')
            cameraFade('game', 'ffffff', 0.1, true, true)
            setProperty('dimBg.alpha', 1)
            setProperty('dimBg.color', getColorFromHex('ff66bb'))
            doTweenColor('dimBgTween', 'dimBg', 'aaffbb', 14, 'sineInOut')
        elseif v1 == 'fadeBG' then
            doTweenColor('dimBgTween', 'dimBg', '000000', 0.5, 'sineInOut')
        end
    end
end