GardenCell = Object:extend()

function GardenCell:new(x, y, crop)
    self.Cell_x_size = 16 * 3
    self.Cell_y_size = 16 * 3

    self.x = x * self.Cell_x_size + 150 + (10 * (x - 1))
    self.y = y * self.Cell_y_size + 150 + (10 * (y - 1))
    self.crop = crop
    self.img = love.graphics.newImage("assets/img/misc.png")
    self.img:setFilter("nearest", "nearest")
    self.width = self.img:getWidth() / 3
    self.height = self.img:getHeight() / 3
    self.frames = {}

    -- image 3*3 frames
    for i = 0, 2 do
        for j = 0, 2 do
            table.insert(self.frames, love.graphics
                .newQuad(i * 16, j * 16, self.width, self.height, self.img:getWidth(), self.img:getHeight()))
        end
    end

end

-- function GardenCell:draw()
--     if self.crop ~= nil then
--         self.crop:draw()
--     end
-- end

function GardenCell:draw()
    if self:Hover() then
        love.graphics.setColor(255, 0, 0)
    else
        love.graphics.setColor(255, 255, 255)
    end
    love.graphics.draw(self.img, self.frames[7], self.x, self.y, 0, 3, 3)
    if self.crop ~= nil then
        self.crop:draw()
    end
end

function GardenCell:Hover()
    local x = self.x
    local y = self.y
    return love.mouse.getX() > x and love.mouse.getX() < x + self.Cell_x_size and love.mouse.getY() > y and
               love.mouse.getY() < y + self.Cell_y_size

end

-- set crop
function GardenCell:setCrop(crop_info)
    if crop_info == nil then
        self.crop = nil
        return
    end
    local newCrop = crop_info
    newCrop.x = self.x
    newCrop.y = self.y - self.Cell_y_size
    self.crop = Crop(newCrop, self)
end

