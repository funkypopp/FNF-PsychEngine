--[[
    Value 1 Functions
    
    clear (or nil)
    - clears all notes from screen

    scale[x, y]
    - sets scale for when notes appear.

    horizontal[dir, line, offset]
    - makes notes appear in a straight line. 
]]--

local noteColors = getPropertyFromClass('backend.ClientPrefs', 'data.arrowRGB')

local notesOnScreen = 0
local noteVFXscaleX = 1.0
local noteVFXscaleY = 1.0

function onEvent(n, v1, v2)
    if n == 'Note VFX' then
        notesOnScreen = notesOnScreen + 1
        if v1 == '' or v1 == 'clear' then
            for i = 1,notesOnScreen do
                cancelTween('noteVFXTween'..i)
                removeLuaSprite('noteVFX'..i)
            end
            notesOnScreen = 0
        elseif v1 == 'scale' then
            local split = stringSplit(v2, ',')
            noteVFXscaleX = stringTrim(split[1])
            noteVFXscaleY = stringTrim(split[2])
        elseif v1 == 'horizontal' then
            if v2 == '' then v2 = '0,0,0' end
            local split = stringSplit(v2, ',')
            local noteVFXDir = stringTrim(split[1])
            local noteVFXLine = stringTrim(split[2])
            local noteVFXOffset = stringTrim(split[3])

            createNoteVFX(notesOnScreen, noteVFXDir, 550-(85*noteVFXscaleX) + (notesOnScreen*(85+noteVFXOffset)*noteVFXscaleX), 370-((85*noteVFXscaleX) + (noteVFXLine*85)*noteVFXscaleX))
            if notesOnScreen > 1 then
                for i = 1,(notesOnScreen-1) do
                    setProperty('noteVFX'..i..'.x', getProperty('noteVFX'..i..'.x')-((85+noteVFXOffset)*noteVFXscaleX))
                    setProperty('noteVFX'..i..'.y', 280-((85*noteVFXLine)*noteVFXscaleY))
                end
            end
        end
    end
end

function createNoteVFX(noteVFXCount, direction, x, y)
    makeAnimatedLuaSprite('noteVFX'..noteVFXCount, 'noteSkins/NOTE_assets'..noteSkinPostfix, x, y)

    addAnimationByIndices('noteVFX'..noteVFXCount, '0', 'purple', '0')
    addAnimationByIndices('noteVFX'..noteVFXCount, '1', 'blue', '0')
    addAnimationByIndices('noteVFX'..noteVFXCount, '2', 'green', '0')
    addAnimationByIndices('noteVFX'..noteVFXCount, '3', 'red', '0')

    scaleObject('noteVFX'..noteVFXCount, noteVFXscaleX, noteVFXscaleY)

    runHaxeCode([[
        import shaders.RGBPalette;
        import shaders.RGBShaderReference;

        function noteVFXrhc(spriteName){
            var rgbShader = new RGBShaderReference(game.getLuaObject(spriteName), new RGBPalette());
            setVar("rgbShader", rgbShader);
        }
    ]])
    runHaxeFunction('noteVFXrhc', {'noteVFX'..noteVFXCount})
    setProperty('rgbShader.r', noteColors[direction + 1][1])
    setProperty('rgbShader.g', noteColors[direction + 1][2])
    setProperty('rgbShader.b', noteColors[direction + 1][3])

    setProperty('noteVFX'..noteVFXCount..'.camera', instanceArg('camHUD'), false, true)

    addLuaSprite('noteVFX'..noteVFXCount, true)

    if getPropertyFromClass('states.PlayState', 'stageData.isPixelStage') then
        setProperty('noteVFX'..noteVFXCount..'.antialiasing', false)
    end
    playAnim('noteVFX'..noteVFXCount, direction, true)
end