function updateGame( ... )
	if not pause then
		updatePlayer()

		for i=1,ballIndex do
			if not (balls[i]==nil) then
				for k=0,vel do --processes <vel> times the bounce function, so ball will behave good, without missing hits
					balls[ballIndex+1] = balls[i]:bounce()
				end
			end
		end

	end
	--call bounce function for every ball


	gameSong:play()

	levelComplete()
	gameOver()
	--modifica velocita per test
	--if ball.x>love.graphics.getWidth()/2 then vel=3 else vel=20 end
	--TEST EXIT

end

function updatePlayer( ... )
	--player.y=love.mouse.getY()-(player.height/2)
		if not (love.mouse.getY()-(player.height/2) < 0) and not ((love.mouse.getY()+(player.height/2)) > love.graphics.getHeight() )then
			player.y = love.mouse.getY() - (player.height/2)

			else if ((love.mouse.getY()+(player.height/2)) > love.graphics.getHeight() )then
				player.y = love.graphics.getHeight()-player.height

				else if (love.mouse.getY()-(player.height/2) < 0) then
					player.y = 0
				end

			end

		end

		--immortal AI
		-- player.y=balls[ballIndex].y - (player.height/2)
end

function levelComplete( ... )
	win=true;
	for _,o in ipairs(block) do
		if o.life>0 then
			win=false
		end
	end
	if win then
		gameSong:stop()
		level=inc(level)
		state=2
	end
end

function resetGame()
	toReset = true
	init()
	--restart game
	state =1
	--updateValues()
end

function gameOver( ... )
	local removed = 0
	lose=true
	for i=1,ballIndex do
		if not (balls[i]==nil) then
			if not (balls[i].x >=love.graphics.getWidth()) then
				lose = false
			else
				balls[i]=nil
				removed = removed + 1
			end
		end
	end

	-- recompressing the balls array to delete nil items
	local tempBuffer = {}
	bufIndex = 1

	for i=1,ballIndex do
		if not (balls[i]==nil) then
			tempBuffer[bufIndex] = balls[i]
			bufIndex = bufIndex + 1
		end
	end
	balls = tempBuffer

	ballIndex = ballIndex - removed

	--ball lost animation and game over handling
	if lose then
		loseSound:play()
		if player.lives <= 0 then
			state = 4
		else
			player.lives = player.lives-1
			playerState = 2
			resetBall()--delete other balls
			resetBonus()--delete active bonus
		end
	end
end
