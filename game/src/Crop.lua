Crop = Object:extend()

function Crop:new(crop_info, father)
    self.father = father
    self.x = crop_info.x
    self.y = crop_info.y
    self.crop_info = crop_info
    self.crop_image = love.graphics.newImage(self.crop_info.img)
    self.crop_image:setFilter("nearest", "nearest")
    self.grow_time_sec = crop_info.grow_time_sec
    self.grow = 3
    self.frames = {}
    self.Harvesting = false
    self.harvest_time = crop_info.harvest_time
    self.harves_speed = 1
    self.width = self.crop_image:getWidth() / 5
    self.height = self.crop_image:getHeight()

    -- circular bar properties
    self.circle_bar = CircularBar(self.x + self.width * 2, self.y + self.height * 2)

    for i = 0, 4 do

        table.insert(self.frames,
            love.graphics.newQuad(i * 16, 0, self.width, self.height, self.crop_image:getWidth(), self.height))
    end

end

function Crop:draw()
    love.graphics.draw(self.crop_image, self.frames[self.grow], self.x, self.y, 0, 3, 3)
    -- timer show 
    love.graphics.print(math.floor(self.grow_time_sec) .. "s", self.x + self.width * 3 / 2, self.y + self.height * 3)
    if self.isHavester(self) then
        love.graphics.print("Harvester", self.x, self.y + self.height * 3 + 10)
    end
    if self.Harvesting then
        love.graphics.print("Harvesting in:" .. math.floor(self.harvest_time) .. "s", self.x,
            self.y + self.height * 3 + 20)
        self:drawLoadingScreen(self.harvest_time / self.crop_info.harvest_time)
    end

end

function Crop:update(dt)
    if self.grow < 5 then

        if self.crop_info.grow_time_sec > 0.0 then
            self.grow_time_sec = self.grow_time_sec - (dt)
            if self.grow_time_sec <= 0 then
                self.grow_time_sec = self.crop_info.grow_time_sec
                self.grow = self.grow + 1
            end
        end
    end

    if self.Harvesting then
        if self.harvest_time > 0 then
            self.harvest_time = self.harvest_time - (dt)
            if self.harvest_time <= 0 then
                self:Harvest()
            end
        end
    end
end

function Crop:isHover()
    local x = self.x
    local y = self.y
    local w = self.width * 3
    local h = self.height * 3
    local mx = love.mouse.getX()
    local my = love.mouse.getY()
    if mx == nil or my == nil then
        return false
    end
    return mx > x and mx < x + w and my > y and my < y + h

end

function Crop:harvestCrop(lvlOfHarvest)
    if Player.Harvesting == true then
        return
    end
    -- posicion que quiera darle luego
    Player.Harvesting = true
    self.harvest_time = self.crop_info.harvest_time - (lvlOfHarvest * 0.5)
    self.Harvesting = true
end

function Crop:isHavester()
    return self.grow == 5

end
-- Harves functionality
function Crop:Harvest()
    self.harvest_time = self.crop_info.harvest_time
    self.Harvesting = false
    Player.Harvesting = false
    Player:UpdateExp(self.crop_info.exp)
    self.grow = 3
    self.father:setCrop(nil)

end

function Crop:drawLoadingScreen(progress)
    self.circle_bar:draw(progress)
end

