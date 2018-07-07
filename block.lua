-----button class--------------------------
	Block = {}
	Block.__index = Block --used for function calls

function Block.new(x,y,life,height,length,distance,hit,poinEffect,pointEffectSize,pointEffectValue)
  local self = setmetatable({}, Button)
  self.pointEffect=false
  self.pointEffectSize=1
  self.pointEffectValue=20
  self.x=x
  self.y=y
  self.life=life
  self.height=40*fx
  self.length=20*fy
  self.distance=50*fy
	self.hidden=false
  self.hit=love.audio.newSource("sound/hit.wav")
  return self
end


------------------------------------------------static functions

function positionBlocks()
	local x = pxStartX --x startig
	local y = pxStartY --y starting

	local index = 0
  local life

  --positioning blocks
	for i=0,nRow do
		for k=0,nCol do
			index = index + 1

      --depending on the patter, skip or not this block
      if pattern[index]==1 then life=level else life=0 end

			block[index] = Block.new(x,y,life,40*fx,20*fy,0*fy,love.audio.newSource("sound/hit.wav"),false,1,20)

      --used for collision control
			precBlockVertical[index] = false
			precBlockOrizon[index] = false

      x=x+block[index].length
		end
    y=y+block[index].height
    x=pxStartX
	end

end

--it creates level design; i dont have time to create different fancy levels; I should create a level editor.
function generatePattern()

	pattern = {}

	for i=1,getBlocksNumber() do
		if block[i].hidden then
			table.insert(pattern,0)
		else
			table.insert(pattern,1)
		end
	end

	state = 0
end

function fullPattern()

	for i=1,getBlocksNumber() do
			table.insert(pattern,1)
	end

	print(pattern[5])
end
