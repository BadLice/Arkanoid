-----polygon class--------------------------
Polygon = {}
Polygon.__index = Polygon --used for function calls

------------------------------------------- obj functions

function Polygon.new()
  local self = setmetatable({}, Polygon)
  self.r = 15
  self.nVert=5
  self.rotation = 30
  self.ox=0
  self.oy=math.random(1,800)
  self.x, self.y = generatePolygonTable(self.ox,self.oy,self.nVert,self.r,self.rotation)
  return self
end

function Polygon.draw(self,mode)
  --mode =line/fill
  love.graphics.polygon(mode,self.x[1],self.y[1],self.x[2],self.y[2],self.x[3],self.y[3],self.x[4],self.y[4],self.x[5],self.y[5])

end

function Polygon.update(self)
  self.rotation=self.rotation + 5
  self.ox=self.ox+4
  self.x, self.y = generatePolygonTable(self.ox,self.oy,self.nVert,self.r,self.rotation)
  if(self.ox-self.r>love.graphics.getWidth()) then
    table.remove(poligons,1)
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
