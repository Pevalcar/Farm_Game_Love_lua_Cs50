Player = Object:extend()

function Player:new()
    self.x = 0
    self.y = 0
    self.lvlOfHarvest = 1
    self.xp = 0
    self.nextlvl = 100
    self.Harvesting = false
end

function Player:UpdateExp(mount)
    self.xp = self.xp + 80

    -- lvl up self harvest
    if self.xp >= self.nextlvl then
        self.xp = self.xp - self.nextlvl
        self.lvlOfHarvest = self.lvlOfHarvest + 1
        self.nextlvl = self.nextlvl + 100

    end

end
