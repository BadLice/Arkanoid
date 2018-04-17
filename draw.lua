function drawPlayer( ... )
	--love.graphics.rectangle("fill",player.x,player.y,player.length,player.height)
	if magnete then --blue player if magnete bonus is active
		love.graphics.setColor(0,0,255)
	end
	love.graphics.draw(playerTexture,player.x+player.length,player.y,math.pi/2,fx-fz,fy+fz)
end

function drawBlocks()
	for _,o in ipairs(block)do
		local x = o.x+o.length
		local y = o.y
		local r = math.pi/2
		local sx = 0.8*fx
		local sy = 0.85*fy
		if o.life>0 then
			love.graphics.setColor(255,255,255)

			-- progressively breaking of the bricks
			if o.life>level-(level/3) and o.life<=level then
				love.graphics.draw(greyBlock0,x,y,r,sx,sy)
			else
				if o.life>(level/3) and o.life<=level-(level/3) then
					love.graphics.draw(greyBlock1,x,y,r,sx,sy)
				else
					love.graphics.draw(greyBlock2,x,y,r,sx,sy)
				end
			end

			love.graphics.setColor(0,0,0)
			--love.graphics.print(o.life,o.x,o.y+10,-math.pi/2,1,1)
			love.graphics.setColor(255,255,255)
		end
		--print score gained with blocks hit
		if o.pointEffect then
				if o.pointEffectSize < 15 then
					--[[love.graphics.setColor(230,88,160)
					love.graphics.setFont(getFont(math.ceil(o.pointEffectSize)))
					line = ""..o.pointEffectValue
					love.graphics.print(line,o.x-15,o.y+30,-math.pi/2,1,1,getFont(math.ceil(o.pointEffectSize)):getWidth(line)/2)
					o.pointEffectSize = o.pointEffectSize + 0.5]]
					o.pointEffectSize = drawScoreDynamic(""..o.pointEffectValue,o.pointEffectSize,o.x-15,o.y+30)
				else
					o.pointEffect = false
					o.pointEffectSize = 1
					--o=nil--remove this item cause grabbed
					--print("effect")
				end
		end
	end
end

function drawBall()
	--red ball if fireball bonus is active
	if fireball then
		love.graphics.setColor(255,0,0)
	else
		--love.graphics.setColor(180,13,255)
		--love.graphics.setColor(180,180,180)
		love.graphics.setColor(255,255,255)
	end
	for i=1,ballIndex do--draw all balls
		if not (balls[i]==nil) then--if ball at index i exists

			love.graphics.circle("fill",balls[i].x,balls[i].y,balls[i].radius,50)
			--love.graphics.setColor(255,255,255)
		end
	end
	love.graphics.setColor(255,255,255)
end

--win animation
function drawWin( ... )

	if winOnce then
		winSound:play()
		winOnce = false
	end

	love.graphics.setBackgroundColor(80,80,80)

	--moving text
	if winFontY < love.graphics.getHeight()/2+(150*fy) then
		winFontY = winFontY + 20
	end

	love.graphics.setColor(74, 144, 226)
	love.graphics.setFont(getFont(70))
	line = "your score: "..score
	love.graphics.print(line,100*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(70):getWidth(line)/2)
	love.graphics.setColor(255,255,255)

	love.graphics.setFont(getFont(65))
	love.graphics.print("  LEVEL\nCOMPLETED",love.graphics.getWidth()/2-(100*fx),winFontY,-math.pi/2)

	playBtn:draw(0.1)

	exitBtn.x=650
	exitBtn:draw(0.1)
end

function drawGameOver()
	gameSong:stop()
	if time<0 then
		time=love.timer.getTime()
	end
	--animation game over lasts 5 sec
	if love.timer.getTime()-time <3.5 then

		anim1 = img1x < 501.5+(gameOverImg:getHeight()/2)
		anim2 = img2x > 501.5+(gameOverImg:getHeight()/2)
		--image from up to down

		if anim1 then
			img1x = img1x + 10
			love.graphics.setColor(255, 255, 255, 50)
			love.graphics.draw(gameOverImg,img1x,549-(gameOverImg:getWidth()/2),-math.pi/2,fx-fz,fy,gameOverImg:getWidth()/2,gameOverImg:getHeight()/2)
		end

		--image from down to up
		if anim2 then
			img2x = img2x - 10
			love.graphics.setColor(255, 255, 255, 50)
		love.graphics.draw(gameOverImg,img2x,549-(gameOverImg:getWidth()/2),-math.pi/2,fx-fz,fy,gameOverImg:getWidth()/2,gameOverImg:getHeight()/2)
		end

		--center image
		if not (anim1 or anim2) then
			--game over sound
			if gameOverOnce then
				gameOverSound:play()
				gameOverOnce = false
			end
		--set image opacity
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.draw(gameOverImg,501.5+(gameOverImg:getHeight()/2),549-(gameOverImg:getWidth()/2),-math.pi/2,fx-fz,fy,gameOverImg:getWidth()/2,gameOverImg:getHeight()/2)
			--flashing background
			love.graphics.setBackgroundColor(r,g,b)
			r = r-2
			g = g-2
			b = b-2
		end
	else
		love.graphics.draw(gameOverImg,501.5+(gameOverImg:getHeight()/2),549-(gameOverImg:getWidth()/2),-math.pi/2,fx-fz,fy,gameOverImg:getWidth()/2,gameOverImg:getHeight()/2)

		exitBtn.x = 800
		exitBtn:draw(0.1)
		replayBtn:draw(0.1)

		love.graphics.setColor(74, 144, 226)
		love.graphics.setFont(getFont(70))
		line = "your score: "..score
		love.graphics.print(line,100*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(70):getWidth(line)/2)
		love.graphics.setColor(255, 255, 255)

	end
end

function drawLives()
	if player.lives <= 5 then
		for i=0,player.lives-1 do
			love.graphics.draw(heart,10*fx,love.graphics.getHeight()-(fy*(10+(30*i))),-math.pi/2,0.025*fx,0.03*fy)
		end
	else
		love.graphics.setFont(getFont(30))
		love.graphics.setColor(255,0,0)
		line = ""..player.lives
		love.graphics.print(line,10*fx,love.graphics.getHeight()-(fy*(10+(30))),-math.pi/2,1,1,getFont(30):getWidth(line)/2)
		love.graphics.setColor(255,255,255)
	end
end

function drawBackground()
	--1:width=Iw:x  x=love.graphics.getWidth()/1024
	--1heigth=Ih:x  y=love.graphics.getHeigth()/640
	love.graphics.draw(background,0,0,0,love.graphics.getWidth()/background:getWidth(),love.graphics.getHeight()/background:getHeight())
end

function drawPause()
	pauseBtn:draw(0.1)

	if pause then
		love.graphics.setColor(230,88,160)
		love.graphics.rectangle("fill",love.graphics.getWidth()/2-(125*fx),love.graphics.getHeight()/2-(250*fy),200*fx,500*fy,20,20)

		love.graphics.setFont(getFont(65))
		love.graphics.setColor(74, 144, 226)
		love.graphics.print("GAME PAUSED",love.graphics.getWidth()/2-(75*fx),love.graphics.getHeight()/2+(200*fy),-math.pi/2)

		resumeBtn:draw(0.1)
		exitBtn.x=650
		exitBtn:draw(0.1)

		love.graphics.setColor(255, 255, 255)
	end
end

function drawBonus()
	updateBonus()
end

function drawScore()
	love.graphics.setFont(getFont(30))
	love.graphics.setColor(230,88,160)
	line = ""..score
	love.graphics.print(line,5*fx,love.graphics.getHeight()/2+(1*fy),-math.pi/2,1,1,getFont(30):getWidth(line)/2)
	love.graphics.setColor(255,255,255)
end

function drawGame( ... )
	drawBackground()
	drawScore()
	drawPlayer()
	drawBlocks()
	drawBall()
	drawLives()
	drawPause()
	drawBonus()
end
