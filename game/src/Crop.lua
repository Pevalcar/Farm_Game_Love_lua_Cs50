Crop = Object:extend()

function Crop:new(crop_info, father)
    self.father = father
    self.x = crop_info.x
    self.y = crop_info.y
    self.crop_info = crop_info
    self.crop_image = love.graphics.newImage(self.crop_info.img)
    self.crop_image:setFilter("nearest", "nearest")
    self.grow = 3
    self.frames = {}
    self.Harvesting = false
    self.harvest_time = crop_info.harvest_time
    self.width = self.crop_image:getWidth() / 5
    self.height = self.crop_image:getHeight()
    self.grow_mod = crop_info.mod

    -- grow mod
    if Player.mods[self.crop_info.name] ~= nil then
        self.grow_mod = Player.mods[self.crop_info.name]
    end
    -- cheacl if grow mod is negative
    local new_grow_time = self.crop_info.grow_time_sec - self.grow_mod
    if new_grow_time < 0.2 then
        new_grow_time = 0
    end

    self.grow_time_sec = new_grow_time

    -- circular bar properties
    self.circle_bar = CircularBar(self.x + self.width * 2, self.y + self.height * 2)

    self:getFrames(self.frames, self.crop_image)

end

function Crop:draw()
    love.graphics.draw(self.crop_image, self.frames[self.grow], self.x, self.y, 0, 3, 3)
    -- timer show 
    if self.Harvesting then
        love.graphics.print("Harvesting in:" .. math.floor(self.harvest_time) .. "s", self.x,
            self.y + self.height * 3 + 20)
        self:drawLoadingScreen(self.harvest_time / self.crop_info.harvest_time)
    end

end

function Crop:update(dt)
    if self.grow < 5 then

        if self.grow_time_sec > 0.0 then
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
    local harvest_time_calc = self.crop_info.harvest_time - lvlOfHarvest * Player.Hoe.hoe_info.multiplier
    print(harvest_time_calc, lvlOfHarvest, self.crop_info.harvest_time)
    if harvest_time_calc <= 0.2 then
        harvest_time_calc = 0.2
    end
    self.harvest_time = harvest_time_calc
    print(self.crop_info.name .. " harvesting in " .. self.harvest_time .. " sec")
    Player.Harvesting = true
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
    Player:UpdateCrops(self.crop_info)
    self.father:setCrop(nil)
end

function Crop:drawLoadingScreen(progress)
    self.circle_bar:draw(progress)
end

function Crop:save()
    -- save data
    local data = {}
    data.crop_info = self.crop_info
    data.grow_time_sec = self.grow_time_sec
    data.grow = self.grow

    return data
end

function Crop:load(data)
    self.grow_time_sec = data.grow_time_sec
    self.grow = data.grow
end

function Crop:getFrames(frames, image)
    for i = 0, 4 do

        table.insert(frames, love.graphics
            .newQuad(i * 16, 0, image:getWidth() / 5, image:getWidth(), image:getWidth(), image:getHeight()))
    end

end
