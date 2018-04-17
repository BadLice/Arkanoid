--on: release,press,over
-----button class--------------------------
	Button = {} 
	Button.__index = Button --used for function calls

	function Button.new(img,x,y,r,scalex,scaley,action,on)
	  local self = setmetatable({}, Button)
	  self.img = love.graphics.newImage(img) --img to draw
	  self.x=x --coordinates
	  self.y=y--
	  self.precPressed = false--used for release
	  self.r = r --rotation og image
	  self.scalex=scalex --scalex of img
	  self.scaley=scaley --scaley of img
	  self.action=action --event to handle(funcion)
	  self.on = on --when to handle event (over,release,press)
	  return self
	end

	function Button.isMouseOver(self)
		if love.mouse.getX() >= self.x-self.img:getHeight()/2  and love.mouse.getX()<=self.x+self.img:getHeight()/2 
		and love.mouse.getY() <= self.y+self.img:getWidth()/2 and love.mouse.getY()>=self.y-self.img:getWidth()/2 
		then
			return true
		else 
			return false
		end
	end

	function Button.isMousePressed(self)
		if self:isMouseOver() and love.mouse.isDown(1,2,3,4)
		then
			return true
		else 
			return false
		end
	end

	function Button.isMouseReleased(self)
		if (not self:isMousePressed()) and self.precPressed then
			self.precPressed = self:isMousePressed()
			return true
		else 
			self.precPressed = self:isMousePressed()
			return false
		end
	end

	function Button.draw(self,dif)
		--effect when clicked
		--dif = difference of scale between pressed or not
		if self:isMousePressed() then
			love.graphics.draw(self.img,self.x,self.y,self.r,self.scalex-dif,self.scalex-dif,self.img:getWidth()/2,self.img:getWidth()/2)
		else
			love.graphics.draw(self.img,self.x,self.y,self.r,self.scalex,self.scalex,self.img:getWidth()/2,self.img:getWidth()/2)
		end
		self:update()
	end

	--event handler
	function Button.update(self)
		if self:isMouseReleased() and self.on == "release" then
			self.action() 
		elseif  self:isMousePressed() and self.on == "press" then
			self.action()
		elseif  self:isMouseOver() and self.on == "over" then
			self.action()
		end
	end

------------------------------------------------ 	
	