local notifCount = 0

function onCreate()
    if songName == 'brb' then
        -- Precache images
        precacheImage('events/discordNotif-vader')
        precacheImage('events/discordNotif-skyan')
    end
end

function onEvent(n, v1, v2)
    if n == 'BRB Notification' then
        notifCount = notifCount + 1
        local spriteName = 'brbNotification'..notifCount
        local user = (v1 == 'skyan' or getRandomInt(1, 20) == 1) and 'skyan' or 'vader'
        makeLuaSprite(spriteName, 'events/discordNotif-'..user, 0, 0)
        setProperty(spriteName .. '.x', screenWidth - getProperty(spriteName .. '.width') - 20)
        setProperty(spriteName .. '.y', 20)
        setProperty(spriteName .. '.alpha', 0)
        setObjectCamera(spriteName, 'camHUD')
        addLuaSprite(spriteName, true)

        doTweenAlpha(spriteName .. 'FadeIn', spriteName, 1, 0.25, 'linear')
        for i = 1, notifCount - 1 do
            local prevSpriteName = 'brbNotification'..i
            if luaSpriteExists(prevSpriteName) then
                local moveY = getProperty(spriteName ..'.height') + 10
                cancelTween(prevSpriteName .. 'MoveDown')
                doTweenY(prevSpriteName .. 'MoveDown', prevSpriteName, 20 + (moveY * (notifCount-i)), 0.25, 'circOut')
            end
        end
        runTimer(spriteName .. 'Wait', 5)
    end
end

function onTimerCompleted(tag)
    if string.find(tag, 'brbNotification') then
        local cleanedTag = tag:match('%d+') -- Extract only numbers from the tag
        if string.find(tag, 'Wait') then
            doTweenAlpha('brbNotificationFadeOut'..cleanedTag, 'brbNotification'..cleanedTag, 0, 0.5, 'linear')
            runTimer('brbNotification'..cleanedTag..'Remove', 0.25)
        elseif string.find(tag, 'Remove') then
            removeLuaSprite('brbNotification'..cleanedTag, true)
            notifCount = notifCount - 1
        end
    end
end