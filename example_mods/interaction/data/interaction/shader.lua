local shaderStage = 0
function onCreate()
	if not shadersEnabled then
		close(true);
	end
end

function onCreatePost()
	initLuaShader('bloom')

	makeLuaSprite('Bloom', 1.9, 3)
	makeGraphic('Bloom', 1, 1)
	setSpriteShader('Bloom', 'bloom')
	setShaderFloat("Bloom", "u_Amount", 1.9)
	setShaderFloat("Bloom", "u_Size", 3)
end

function bam(dur, ease)

end

function onEvent(n, v1, v2)
	if n == "bump" then
		if v1 == '' or v1 == nil then v1 = 3 end
		if v2 == '' or v2 == nil then v2 = 0 end
		setProperty('Bloom.x', 1.6)
		setProperty('Bloom.y', 40)
		startTween('tween_Bloom', 'Bloom', {x = 1.9, y = 3}, (curBpm/60)/v1, {ease = 'expoOut'})
		cancelTween('dimBgTween')
		if v2 == '1' then
			setProperty('dimBg.color', getColorFromHex('440033'))
            doTweenColor('dimBgTween', 'dimBg', '000000', (curBpm/60)/v1, 'circOut')
		elseif v2 == '2' then
			setProperty('dimBg.color', getColorFromHex('ff0066'))
            doTweenColor('dimBgTween', 'dimBg', '440033', (curBpm/60)/v1, 'circOut')
		end
	end
end

function onUpdate()
	if shaderStage == 1 then
		setShaderFloat("Bloom", "u_Amount", getProperty('Bloom.x'))
		setShaderFloat("Bloom", "u_Size", getProperty('Bloom.y'))
	end
end

function onBeatHit()
	if ((curBeat >= 48)) and shaderStage ~= 1 then
		shaderStage = 1
		runHaxeCode([[
			game.camGame.filters = ([
				new ShaderFilter(game.getLuaObject("Bloom").shader)
			]);
			return;
		]])
    end
end