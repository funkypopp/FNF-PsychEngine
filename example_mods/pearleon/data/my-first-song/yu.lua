precacheImage('yu')

function onCreate()
    makeLuaSprite('yu', 'yu', 0, 0)
    setProperty('yu.x', (screenWidth - getProperty('yu.width')) / 2)
    setProperty('yu.y', (screenHeight - getProperty('yu.height')) / 2)
    setObjectCamera('yu', 'hud')
    setProperty('yu.visible', false)
    addLuaSprite('yu', true)
end

function onEvent(n, v1, v2)
    if n == 'Yu!' then
        setProperty('yu.visible', v1)
    end
end