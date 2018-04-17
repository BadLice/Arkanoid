--on: release,press,over
-----powerUp class--------------------------
	powerUp = {}
	powerUp.__index = powerUp --used for function calls

	function powerUp.new(type,x,y)
		local self = setmetatable({}, powerUp)
		--setting power up type
		if type==1 then--magnete
			self.img = love.graphics.newImage("img/magnete.png") --img to draw
			self.type=type
			self.scalex = getScaleX(self.img,25) --scalex of img
			self.scaley = getScaleY(self.img,10)
			self.r = math.pi
		end

		if type==2 then--fireball
			self.img = love.graphics.newImage("img/fireball.png") --img to draw
			self.type=type
			self.scalex = getScaleX(self.img,25) --scalex of img
			self.scaley = getScaleY(self.img,10)
			self.r = math.pi/2
		end

		if type==3 then--3 balls
			self.img = love.graphics.newImage("img/three-ball-icon.png") --img to draw
			self.type=type
			self.scalex = getScaleX(self.img,25) --scalex of img
			self.scaley = getScaleY(self.img,10)
			self.r = math.pi/2
		end

		self.x=x --coordinates
		self.y=y --
		self.draw = true --to draw or not
		self.pointEffect = false --
		self.pointEffectSize = 1 --effects variables
		self.canGrab = true

		return self
	end

	function powerUp.isGrabbed(self)
		if self.x >= player.x and self.x <= (player.x+player.length)
		and self.y >= player.y and self.y <= (player.y+player.height)
		and self.canGrab
		then
			if self.type == 1 then
				magneteSound:play()
			else
				if self.type == 2 then
					fireballSound:play()
				else
					if self.type == 3 then
						triballSound:play()
					end
				end
			end
			return true
		else
			return false
		end
	end

------------------------------------------------
	--create table containing all power ups
	function createBonusTable(reset)
		if not reset then
			bonus = {}
			bonusIndex = 0
			bonusFallingSpeed = 10
			--magneteCounter = 3
			magneteTime = -1
		end

		fireball = false
		magnete = false
		fireballHit = false
	end

	function spawnBonus(x,y) --spawns a power up randomly
		--math.randomseed(os.time())
		if math.random(1,7) == 1 then
			--insert here spqwn code
			--spawn code test
			--math.randomseed(os.time())
			bonusIndex = bonusIndex + 1
			bonus[bonusIndex] = powerUp.new(math.random(1,3),x,y)
		end
	end


	function updateBonus()
		--sto pezzo sarebbe giusto, è uguale a quello dopo ma col foreach, ma non funziona a caso
		--[[for i,o in ipairs(bonus) do

			if o.x>love.graphics.getWidth() then
				o=nil--remove cause out of screen
			end

			if not (o == nil) then
				love.graphics.print(i.."= ok, type= "..o.type,100,100+(10*i))
				if o.draw then
					o.x=o.x+bonusFallingSpeed
					love.graphics.draw(o.img,o.x,o.y,o.r,o.scalex,o.scalex,o.img:getWidth()/2,o.img:getWidth()/2)
				end

				--when bonus is grabbed
				if o:isGrabbed() then
					o.draw = false
					if o.type == 1 then --effect of magnete bonus
						magnete = true
						magneteCounter = 10
					end
					if o.type == 2 then --effect of fireball bonus
						fireball = true
					end
					o=nil--remove this item cause grabbed
				end
			else
				love.graphics.print(i.."= null",100,100+(10*i))
			end
		end]]

		for i=1,bonusIndex do
			if not (bonus[i] == nil) then
				if bonus[i].x>love.graphics.getWidth() then
					bonus[i]=nil--remove cause out of screen
				end
			end

			if not (bonus[i] == nil) then
				--love.graphics.print(i.."= ok, type= "..bonus[i].type.."magnete counter= "..magneteCounter,100,100+(10*i))
				if bonus[i].draw then
					if not pause then bonus[i].x=bonus[i].x+bonusFallingSpeed end
					love.graphics.draw(bonus[i].img,bonus[i].x,bonus[i].y,bonus[i].r,bonus[i].scalex,bonus[i].scalex,bonus[i].img:getWidth()/2,bonus[i].img:getWidth()/2)
				end

				--when bonus is grabbed
				if bonus[i]:isGrabbed() then
					bonus[i].draw = false
					bonus[i].pointEffect = true
					bonus[i].canGrab = false

					score = score + bonusScoreValure

					if bonus[i].type == 1 then --effect of magnete bonus
						magnete = true
						--magneteCounter = 3
						magneteTime = love.timer.getTime()
					end
					if bonus[i].type == 2 then --effect of fireball bonus
						fireball = true
					end
					if bonus[i].type==3 then--3-balls bonus
						for i=0,ballIndex do
							if not (balls[i]==nil) then
								k = i
								break
							end
						end
						balls[ballIndex+1] = Ball.new(rad,balls[k].x,balls[k].y,balls[k].angle+2,1)
						balls[ballIndex+2] = Ball.new(rad,balls[k].x,balls[k].y,balls[k].angle-2,1)
						ballIndex=ballIndex+2
					end

				end
			end
			-- +50 points print when a bonus is grabbed handler
			if not (bonus[i] == nil) then
				if bonus[i].pointEffect then
					if bonus[i].pointEffectSize < 15 then
						--[[love.graphics.setColor(230,88,160)
						love.graphics.setFont(getFont(math.ceil(bonus[i].pointEffectSize)))
						love.graphics.print("50",bonus[i].x,bonus[i].y,-math.pi/2,1,1,getFont():getWidth(math.ceil(bonus[i].pointEffectSize)))
						love.graphics.setColor(255,255,255)
						bonus[i].pointEffectSize = bonus[i].pointEffectSize + 0.5]]
						bonus[i].pointEffectSize = drawScoreDynamic("50",bonus[i].pointEffectSize,bonus[i].x,bonus[i].y)
					else
						bonus[i].pointEffect = false
						bonus[i]=nil--remove this item cause grabbed
					end
				end
			end
		end

	end

	function resetBonus()
		createBonusTable()
	end

	function magneteHandler(ball)
		if magnete then
			ball.playerPositionDif = ball.y - player.y
			ball.playerState = 3
			--[[magneteCounter = magneteCounter - 1
			if magneteCounter <=0 then
				magnete = false
			end]]

		end
	end

	function magneteTimer()
		if magnete then
			if (love.timer.getTime()-magneteTime)>=10 then
				magnete=false
				magneteTime = -1
			end
		end
	end

	function fireballHandler()
		if fireballHit and fireball then --end fireball bonus (if hit player and at least one brick)
			fireball = false
			fireballHit = false
		end
	end

	function fireballHitf() --when hit a brick
		if fireball then
			fireballHit = true
		end
	end
