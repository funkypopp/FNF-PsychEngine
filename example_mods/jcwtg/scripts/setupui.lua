function onCreatePost()
	for i = 0,3 do
		setPropertyFromGroup('strumLineNotes',i,'x',-330)
    end
end

function onCreatePost()
    setProperty('scoreTxt.visible',false)
    setProperty('botplayTxt.visible',false)
    setProperty('timeBar.visible',false)
end