local fakeoutBg = false

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

function fakeoutBg()
    fakeoutBg = not fakeoutBg
    removeLuaSprite('interactiveBack', false)
    removeLuaSprite('interactiveFront', false)
    doTweenX('dadTween', 'dadGroup', getProperty('dadGroup.x')-150, 0.5, 'circOut')
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
    makeGraphic('sunEffect', 13000, 13000, 'white')
    setScrollFactor('sunEffect', 0.02, 0.02)
    setProperty('sunEffect.alpha', 1)
    addLuaSprite('sunEffect', false)
    setSpriteShader('sunEffect', 'sun')
    setObjectOrder('sunEffect', getObjectOrder('gfReflect')-3)
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
            doTweenY('sunEffectTween', 'sunEffect', getProperty('sunEffect.y') - 4500, 15, 'sineOut')
        end
    end
end