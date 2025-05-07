function onUpdatePost()
    if getProperty('healthBar.percent') > 80 and getProperty('iconP1.animation.curAnim.numFrames') > 2 then
       setProperty('iconP1.animation.curAnim.curFrame',2)
    elseif getProperty('healthBar.percent') < 20 and getProperty('iconP2.animation.curAnim.numFrames') > 2 then
      setProperty('iconP2.animation.curAnim.curFrame',2)
    end
end