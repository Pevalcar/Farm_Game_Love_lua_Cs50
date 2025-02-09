GardenCell = Object:extend()

function GardenCell:new(x, y, crop)
    self.crop = crop
    self.initial_x = x
    self.initial_y = y

    self.Cell_x_size = 16 * 3
    self.Cell_y_size = 16 * 3
    self:updateposition()
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
    love.graphics.setColor(255, 255, 255)
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

function GardenCell:save()
    -- save data
    local data = {}
    data.x = self.initial_x
    data.y = self.initial_y
    data.crop = self.crop:save()
    return data
end

function GardenCell:load(data)

    self.initial_x = data.x
    self.initial_y = data.y
    self:setCrop(data.crop.crop_info)
    self.crop:load(data.crop)
end

function GardenCell:updateposition()
    local pos_x = 10
    local pos_y = 100
    self.x = self.initial_x * self.Cell_x_size + pos_x + (10 * (self.initial_x - 1))
    self.y = self.initial_y * self.Cell_y_size + pos_y + (10 * (self.initial_y - 1))

end
