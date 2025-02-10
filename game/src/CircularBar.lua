CircularBar = Object:extend()

function CircularBar:new(x, y)
    self.x = x
    self.y = y
    self.img_b = love.graphics.newImage("assets/img/progres_circle/circle_bar_progres.png")
    self.img_b:setFilter("nearest", "nearest")
    self.img = love.graphics.newImage("assets/img/progres_circle/circle_bar_over.png")
    self.img:setFilter("nearest", "nearest")
    self.hand_img = love.graphics.newImage("assets/img/progres_circle/Hand.png")
    self.hand_img:setFilter("nearest", "nearest")
    self.frame = 1
    self.frames = {}
    for i = 0, 15 do
        table.insert(self.frames, love.graphics.newQuad(i * 16, 0, 16, 16, self.img_b:getWidth(), self.img:getHeight()))
    end
end

function CircularBar:draw(progress)
    if progress == nil then
        progress = 1

    end

    self.frame = math.floor(1 + (progress * 15))
    if self.frame > 15 then
        self.frame = 15
    end
    love.graphics.draw(self.img_b, self.frames[self.frame], self.x, self.y, 0, 1.5, 1.5)
    -- animate hand move 
    local angle = math.sin(progress * math.pi * 6) * 0.2
    love.graphics.draw(self.hand_img, self.x - 16, self.y - 16, angle, 1.5, 1.5)

end

