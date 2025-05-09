local shaderStage = 0
function onCreate()
	if not shadersEnabled then
		close(true);
	end
end

function onCreatePost()
	initLuaShader('bloom')

	makeLuaSprite('Bloom', 1.9, 0)
	makeGraphic('Bloom', 1, 1)
	setSpriteShader('Bloom', 'bloom')
	setShaderFloat("Bloom", "u_Amount", 1.9)
	setShaderFloat("Bloom", "u_Size", 3)
end

function bam(dur, ease)
	setProperty('Bloom.x', 1.7)
	setProperty('Bloom.y', 40)
	startTween('tween_Bloom', 'Bloom',{x = 2, y = 3}, dur,{ease = ease, onUpdate = 'tweenNum1'})
end
function tweenNum1()
	setShaderFloat("Bloom", "u_Amount", getProperty('Bloom.x'))
	setShaderFloat("Bloom", "u_Size", getProperty('Bloom.y'))
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