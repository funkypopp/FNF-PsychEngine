local init = false
local cinema0 = 0
local cinema1 = 0
local cinemaType = 1
local real = true

function onEvent(n, v1, v2)
    if n == 'Real Cinema' then
        real = true
        realCinema(v1, v2)
    end
    if n == 'Fake Cinema' then
        real = false
        realCinema(v1, v2)
    end
end

function realCinema(value1, value2)
    for i = -2,2 do
        if i ~= 0 then
            cancelTween('cinemaAngle'..i)
            cancelTween('cinemaSlow'..i)
            cancelTween('cinemaSlowEnd'..i)
            cancelTween('cinemaFast'..i)
            cancelTween('cinemaFuckOff'..i)
        end
    end
    if value1 == 'true' then
        if value2 == '' then value2 = '100,0,in,slow,0.2' end
    else
        if value2 == '' then value2 = '0.5' end
    end
    local split = stringSplit(value2, ',')
    local distance = stringTrim(split[1]) -- 0-360
    local angle = stringTrim(split[2]) -- int
    local direction = stringTrim(split[3]) -- in/out
    local style = stringTrim(split[4]) -- slow/fast
    local time = stringTrim(split[5]) -- int

    if value1 == 'true' then
        if not init then initialize() end
        if real then
            doTweenAlpha('camHUD', 'camHUD', 0, 0.5, 'sineOut')
        end
        for i = -1, 1 do
            if i ~= 0 then
                if real then cinemaType = i else cinemaType = i*2 end
                if direction == 'out' then
                    if i < 0 then
                        cinema0 = (-360-distance)
                    else
                        cinema1 = (360+distance)
                    end
                    setProperty('cinema'..cinemaType..'.y', 360*i)
                    doTweenAngle('cinemaAngle'..cinemaType, 'cinema'..cinemaType, angle, 1, 'sineOut')
                    if style == 'fast' then
                        doTweenY('cinemaFast'..cinemaType, 'cinema'..cinemaType, (360+distance)*i, time, 'circOut')
                    else
                        doTweenY('cinemaSlow'..cinemaType, 'cinema'..cinemaType, (360+distance*0.8)*i, time, 'sineIn')
                    end
                else
                    if i < 0 then
                        cinema0 = (-720+distance)
                    else
                        cinema1 = (720-distance)
                    end
                    doTweenAngle('cinemaAngle'..cinemaType, 'cinema'..cinemaType, angle, 1, 'sineOut')
                    if style == 'fast' then
                        doTweenY('cinemaFast'..cinemaType, 'cinema'..cinemaType, (720-distance)*i, time, 'circOut')
                    else
                        doTweenY('cinemaSlow'..cinemaType, 'cinema'..cinemaType, (720-distance*0.8)*i, time, 'sineIn')
                    end
                end
            end
        end
    else
        doTweenAlpha('camHUD', 'camHUD', 1, 0.5, 'sineOut')
        if init then
            for i = -1, 1 do
                if i ~= 0 then
                    if real then cinemaType = i else cinemaType = i*2 end
                    cancelTween('cinemaSlow'..cinemaType)
                    cancelTween('cinemaSlowEnd'..cinemaType)
                    cancelTween('cinemaAngle'..cinemaType)
                    doTweenY('cinemaFuckOff'..cinemaType, 'cinema'..cinemaType, 820*i, value2, 'circOut')
                    doTweenAngle('cinemaAngle'..cinemaType, 'cinema'..cinemaType, 0, value2, 'sineOut')
                end
            end
        end
    end
end

function onTweenCompleted(t)
    if t == 'cinemaSlow'..cinemaType then
        doTweenY('cinemaSlowEnd'..cinemaType, 'cinema'..cinemaType, cinema0, time*4, 'circOut')
    elseif t == 'cinemaSlow'..cinemaType then
        doTweenY('cinemaSlowEnd'..cinemaType, 'cinema'..cinemaType, cinema1, time*4, 'circOut')
    end
end

function initialize()
    init = true
    for i = -2, 2 do
        if i ~= 0 then
            if i % 2 == 0 then
                makeLuaSprite('cinema'..i, '', -400, i*360)
                setProperty('cinema'..i..'.camera', instanceArg('camHUD'), false, true)
                setObjectOrder('cinema'..i, -10000)
            else
                makeLuaSprite('cinema'..i, '', -400, i*720)
                setProperty('cinema'..i..'.camera', instanceArg('camOther'), false, true)
            end
            makeGraphic('cinema'..i, 2080, 720, '000000')
            setProperty('cinema'..i..'.origin.x', 1040)
            setProperty('cinema'..i..'.origin.y', 360)
            addLuaSprite('cinema'..i)
        end
    end
end

runHaxeCode([[
	createGlobalCallback("skyan_realCinema", function(real:String, params:String) {parentLua.call("realCinema", [real, params]);});
]])