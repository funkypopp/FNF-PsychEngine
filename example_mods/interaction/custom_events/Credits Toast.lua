creditsToggle = true
creditsStyle = 'Cassette'

local creditsList = {
    {song = 'Interaction', style = 'Cassette', art = 'debug'}
}

local creditsArt = 'debug'

function getIconColor(chr, valR, valG, valB)
    return rgbToHex(getProperty(chr .. ".healthColorArray"), valR, valG, valB)
end

function rgbToHex(array, valR, valG, valB)
    return string.format('%.2x%.2x%.2x', math.min(array[1]*valR,255), math.min(array[2]*valG,255), math.min(array[3]*valB,255))
end

function onCreatePost()
    if creditsToggle and curStage ~= 'maniac-mode [ftt]' then
        for i = 1,#creditsList do
            if songName == creditsList[i].song then
                if creditsStyle == 'Default' then
                    creditsStyle = creditsList[i].style
                end
                creditsArt = creditsList[i].art
            end
        end
        if creditsStyle == 'Vinyl' then
            makeLuaSprite('creditsContainer', 'creditsToast/vinylBox', -500, 0)
            setProperty('creditsContainer.camera', instanceArg('camOther'), false, true)
            scaleObject('creditsContainer', 0.8, 0.8)
            screenCenter('creditsContainer', 'y')
            addLuaSprite('creditsContainer', true)

            makeLuaText('songTitle', '~x~', 350, -490, 230)
            setTextAlignment('songTitle', 'center')
            setTextSize('songTitle', 35)
            setTextFont('songTitle', 'tardlingFilled.ttf')
            setTextColor('songTitle', getIconColor('dad', 1, 1, 1))
            setTextBorder('songTitle', 5, getIconColor('dad', 0.2, 0.2, 0.2))
            setProperty('songTitle.camera', instanceArg('camOther'), false, true)
            addLuaText('songTitle')

            makeLuaText('creditTxt', '~x~', 300, -525, 0)
            setTextAlignment('creditTxt', 'center')
            setTextSize('creditTxt', 20)
            setTextFont('creditTxt', 'phantomMuff.ttf')
            setProperty('creditTxt.camera', instanceArg('camOther'), false, true)
            screenCenter('creditTxt', 'y')
            addLuaText('creditTxt')

            makeLuaSprite('recordDisc', 'creditsToast/vinylRecord', -600, 0)
            setProperty('recordDisc.camera', instanceArg('camOther'), false, true)
            scaleObject('recordDisc', 0.8, 0.8)
            screenCenter('recordDisc', 'y')
            addLuaSprite('recordDisc', true)

            makeLuaSprite('recordIcon', '', -500, 0)
            setProperty('recordIcon.camera', instanceArg('camOther'), false, true)
            loadGraphic('recordIcon', 'icons/icon-'..getProperty('iconP2.char'), 150)
            screenCenter('recordIcon', 'y')
            addLuaSprite('recordIcon', true)
        elseif creditsStyle == 'Cassette' then
            makeLuaSprite('creditsContainer', 'creditsToast/cassettePlayer_On', -700, 0)
            setProperty('creditsContainer.camera', instanceArg('camOther'), false, true)
            scaleObject('creditsContainer', 0.8, 0.8)
            screenCenter('creditsContainer', 'y')
            addLuaSprite('creditsContainer', true)
    
            makeLuaSprite('cassette', 'creditsToast/cassette/'..creditsArt, -635, 0)
            setProperty('cassette.camera', instanceArg('camOther'), false, true)
            scaleObject('cassette', 0.8, 0.8)
            screenCenter('cassette', 'y')
            addLuaSprite('cassette', true)
    
            makeLuaText('songTitle', '~x~', 350, -490, 180)
            setTextAlignment('songTitle', 'center')
            setTextSize('songTitle', 35)
            setTextFont('songTitle', 'tardlingFilled.ttf')
            setTextColor('songTitle', getIconColor('dad', 1, 1, 1))
            setTextBorder('songTitle', 5, getIconColor('dad', 0.2, 0.2, 0.2))
            setProperty('songTitle.camera', instanceArg('camOther'), false, true)
            addLuaText('songTitle')
    
            makeLuaText('creditTxt', '~x~', 250, -500, 0)
            setTextAlignment('creditTxt', 'center')
            setTextSize('creditTxt', 20)
            setTextFont('creditTxt', 'phantomMuff.ttf')
            setTextColor('creditTxt', 'ffffff')
            setProperty('creditTxt.camera', instanceArg('camOther'), false, true)
            screenCenter('creditTxt', 'y')
            addLuaText('creditTxt')

            makeLuaSprite('cassetteCover', 'creditsToast/cassetteCover_Closed', -645, 0)
            setProperty('cassetteCover.camera', instanceArg('camOther'), false, true)
            scaleObject('cassetteCover', 0.8, 0.8)
            screenCenter('cassetteCover', 'y')
            setProperty('cassetteCover.y', getProperty('cassetteCover.y')-70)
            addLuaSprite('cassetteCover', true)
        end
    end
end

function onEvent(eventName, value1, value2)
    if creditsToggle then
        if eventName == 'Credits Toast' then
            local split = stringSplit(value2, ',')
            local line1 = stringTrim(split[1])
            local line2 = stringTrim(split[2])
            local line3 = stringTrim(split[3])
            local line4 = stringTrim(split[4])
            local line5 = stringTrim(split[5])
            if line2 ~= '' then
                comma1 = ','
            else
                comma1 = ''
            end
            if line4 ~= '' then
                comma2 = ','
            else
                comma2 = ''
            end
            setTextString('songTitle', value1)
            setTextAlignment('songTitle', 'center')
            setTextString('creditTxt', 'Music - '..line1..comma1..'\n'..line2..'\n\nCoding - '..line3..comma2..'\n'..line4..'\n\nChart - '..line5..'')
            screenCenter('creditTxt', 'y')
            if creditsStyle == 'Vinyl' then
                doTweenX('boxEnter', 'creditsContainer', 125, 1, 'circOut')
                doTweenX('titleEnter', 'songTitle', 175, 1, 'circOut')
                doTweenX('textEnter', 'creditTxt', 200, 1, 'circOut')
                doTweenX('discEnter', 'recordDisc', -150, 1, 'circOut')
                doTweenX('iconEnter', 'recordIcon', -50, 1, 'circOut')
                doTweenAngle('iconSpin', 'recordIcon', 1440, 10, 'linear')
            elseif creditsStyle == 'Cassette' then
                doTweenX('boxEnter', 'creditsContainer', -25, 1, 'circOut')
                setTextWidth('songTitle', 300)
                doTweenX('titleEnter', 'songTitle', 200, 1, 'circOut')
                doTweenX('textEnter', 'creditTxt', 225, 1, 'circOut')
                doTweenX('cassetteEnter', 'cassette', 40, 1, 'circOut')
                doTweenX('coverEnter', 'cassetteCover', 30, 1, 'circOut')
            end
            runTimer('cardWait'..creditsStyle, 3)
        end
    end
end

function onTimerCompleted(t)
    if t == 'cardWaitVinyl' then
        doTweenX('boxLeave', 'creditsContainer', -600, 1, 'circIn')
        doTweenX('discLeave', 'recordDisc', -650, 1, 'circIn')
        doTweenX('iconLeave', 'recordIcon', -550, 1, 'circIn')
        doTweenX('textLeave', 'creditTxt', -500, 1, 'circIn')
        doTweenX('titleLeave', 'songTitle', -515, 1, 'circIn')
        doTweenAlpha('boxDisappear', 'creditsContainer', 0, 1, 'circIn')
        doTweenAlpha('textDisappear', 'creditTxt', 0, 1, 'circIn')
        doTweenAlpha('titleDisappear', 'songTitle', 0, 1, 'circIn')
    end
    if t == 'cardWaitCassette' then
        doTweenX('boxLeave', 'creditsContainer', -700, 1, 'circIn')
        doTweenX('cassetteLeave', 'cassette', -635, 1, 'circIn')
        doTweenX('textLeave', 'creditTxt', -500, 1, 'circIn')
        doTweenX('titleLeave', 'songTitle', -515, 1, 'circIn')
        doTweenX('coverLeave', 'cassetteCover', -645, 1, 'circIn')
        doTweenAlpha('boxDisappear', 'creditsContainer', 0, 1, 'circIn')
        doTweenAlpha('textDisappear', 'creditTxt', 0, 1, 'circIn')
        doTweenAlpha('titleDisappear', 'songTitle', 0, 1, 'circIn')
    end
end