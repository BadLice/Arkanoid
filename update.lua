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

	if not (love.mouse.getY()-(player.height/2) < 0) and not ((love.mouse.getY()+(player.height/2)) > love.graphics.getHeight() )then
			player.y = love.mouse.getY() - (player.height/2)

			else if ((love.mouse.getY()+(player.height/2)) > love.graphics.getHeight() )then
				player.y = love.graphics.getHeight()-player.height

				else if (love.mouse.getY()-(player.height/2) < 0) then
					player.y = 0
				end

			end

		end

	--updateAI()
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

	lose=false
	--remove balls lost
	for _,o in ipairs(balls) do
			if o.x >=love.graphics.getWidth() then
					table.remove(balls,tablefind(balls,o))
			end
	end
	if tablelength(balls)<=0 then
		lose=true
	end

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

function updateAI ()

	--immortal AI
	--pressing mouse to start game or to launche when magnete
	--[[for _,ball in ipairs(balls) do
		if (ball.playerState==2) or (ball.playerState==3) then
			ball.playerState=1
			ball.angle=135
		end
	end

	aiy={}
	aix={}
	--y of all balls
	for _,ball in ipairs(balls) do
		if ball.x < player.x then
			table.insert(aix,player.x-ball.x)
			table.insert(aiy,ball.y)
		end
	end
	--y of all bonus
	for i=1,tablelength(bonus) do
		if not (bonus[i]==nil) then
			if bonus[i].x < player.x then
				table.insert(aix,player.x-bonus[i].x)
				table.insert(aiy,bonus[i].y)
			end
		end
	end
	--calculating min distance
	min = love.graphics.getWidth()
	minIndex = -1
	if tablelength(aiy)>0 then

		for i=1,tablelength(aiy) do
			if aix[i]<min then
				min=aix[i]
				minIndex=i
			end
		end

	end
	--updating player
	if not (minIndex== -1) then
		if not (aiy[minIndex]-(player.height/2) < 0) and not ((aiy[minIndex]+(player.height/2)) > love.graphics.getHeight() )then
			player.y=aiy[minIndex] - (player.height/2)

			else if ((aiy[minIndex]+(player.height/2)) > love.graphics.getHeight() )then
				player.y = love.graphics.getHeight()-player.height

				else if (aiy[minIndex]-(player.height/2) < 0) then
					player.y = 0
				end
			end
		end
	end]]

	player.y=balls[ballIndex].y-(player.height/2)


end
