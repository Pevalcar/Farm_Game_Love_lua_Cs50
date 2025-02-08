Player = Object:extend()

function Player:new()
    self.lvlOfHarvest = 1
    self.xp = 0
    self.nextlvl = 100
    self.Harvesting = false
end

function Player:UpdateExp(mount)
    self.xp = self.xp + mount

    -- lvl up self harvest
    if self.xp >= self.nextlvl then
        self.xp = self.xp - self.nextlvl
        self.lvlOfHarvest = self.lvlOfHarvest + 1
        self.nextlvl = self.nextlvl + 100

    end

end

function Player:save()
    return {
        lvlOfHarvest = self.lvlOfHarvest,
        xp = self.xp,
        nextlvl = self.nextlvl,
        Harvesting = self.Harvesting
    }
end

function Player:load(data)
    if data == nil then
        return
    end
    self.lvlOfHarvest = data.lvlOfHarvest
    self.xp = data.xp
    self.nextlvl = data.nextlvl
    self.Harvesting = data.Harvesting
end
