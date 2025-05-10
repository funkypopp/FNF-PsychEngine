local initialized = false

function onEvent(n, v1, v2)
    if n == 'Background Overlay Effects' then
        if not initialized then initializeBGFX() end

        if v1 == 'true' or v1 == 'ext' then
            if v2 == '' then v2 = '0.5,000000,1,circOut' end
        else
            if v2 == '' then v2 = '1,ffffff,1,expoOut' end
        end

        local split = stringSplit(v2, ',')
        local alpha = stringTrim(split[1]) -- int
        local color = stringTrim(split[2].upper(split[2])) -- color code
        local duration = stringTrim(split[3]) -- int
        local easeType = stringTrim(split[4]) -- ease

        cancelTween('dimBgTween')

        if v1 == 'true' or v1 == 'ext' then
            setProperty('dimBg.color', getColorFromHex(color))
            if v1 == 'true' then setProperty('dimBg.alpha', 0) end
            doTweenAlpha('dimBgTween', 'dimBg', alpha, duration, easeType)
        else
            setProperty('dimBg.color', getColorFromHex(color))
            setProperty('dimBg.alpha', alpha)
            doTweenAlpha('dimBgTween', 'dimBg', 0, duration, easeType)
        end
    end
end

function initializeBGFX()
    createInstance('dimBg', 'flixel.addons.display.FlxBackdrop', {nil, 0x11, 0})
    makeGraphic('dimBg', 1000, 1000, 'white')
    setProperty('dimBg.camera', instanceArg('camGame'), false, true)
    setScrollFactor('dimBg', 0, 0)
    setProperty('dimBg.alpha', 0)
    setBlendMode('dimBg', 'add')
    setObjectOrder('dimBg', getObjectOrder('gfGroup')-1)
    addInstance('dimBg', false)
    initialized = true
end