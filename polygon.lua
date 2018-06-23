-----polygon class--------------------------
Polygon = {}
Polygon.__index = Polygon --used for function calls

------------------------------------------- obj functions

function Polygon.new()
  local self = setmetatable({}, Polygon)
  self.r = 15
  self.speed=math.random(1,15)
  self.rotationSpeed=math.random(1,8)
  self.angle = math.random(1,180)
  self.nVert=5
  self.rotation = 30

  rnd1 = math.random(1, 2)==1

  --set randomically from which side of screen spawn
  if rnd1 then
    self.ox=0
    self.angle=self.angle-90
  else
    self.ox=love.graphics.getWidth()
    self.angle=self.angle+90
  end

  self.oy=math.random(1,love.graphics.getHeight())

  self.x, self.y = generatePolygonTable(self.ox,self.oy,self.nVert,self.r,self.rotation)
  return self
end

function Polygon.draw(self,mode)
  --mode =line/fill
  love.graphics.polygon(mode,self.x[1],self.y[1],self.x[2],self.y[2],self.x[3],self.y[3],self.x[4],self.y[4],self.x[5],self.y[5])

end

function Polygon.update(self)

  --rotate polygon
  self.rotation=self.rotation + self.rotationSpeed
  --move polygon
  self.ox = self.ox + self.speed*(math.cos(math.pi*self.angle/180))
  self.oy = self.oy + self.speed*(math.sin(math.pi*self.angle/180))

  --delete polygon if out of screen
  self.x, self.y = generatePolygonTable(self.ox,self.oy,self.nVert,self.r,self.rotation)
  if not (((self.ox+self.r)<=love.graphics.getWidth()+(self.r*2)) and (self.ox+self.r)>=0-(self.r*2) and ((self.oy+self.r)<=love.graphics.getHeight()+(self.r*2)) and (self.oy+self.r)>=0-(self.r*2))  then
    table.remove(poligons,tablefind(poligons,self))
  end
end

------------------------------------------------ class functions

--generates polygon coordintes
function generatePolygonTable(ox,oy,nVert,r,rotation)
  --x = ox + r * cos(a)
  --y = oy + r * sin(a)

  --ox = 500
  --oy = 300
  --nVert = 5
  --r=100
  --rotation=30

  x={}
  y={}

  cont=1

  for i = 1+rotation,360+rotation do
    if ((360/nVert)*cont)+rotation<=i  then
      table.insert(x, ox + r * math.cos(math.pi*i/180))
      table.insert(y, oy + r * math.sin(math.pi*i/180))
        cont = cont + 1
    end
  end
  return x,y
end
