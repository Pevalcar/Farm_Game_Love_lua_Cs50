Player = Object:extend()

function Player:new()
    self.lvlOfHarvest = 1
    self.xp = 0
    self.nextLvl = 100
    self.coins = 0
    self.Harvesting = false
    self.inventory = {}
    self.Hoelvl = 1
    self.Hoe = Hoe(self.Hoelvl, self)
end

function Player:Update(dt)
    self.Hoe:update(dt)

end

function Player:UpdateCrops(crop_info)
    if self.inventory == nil then
        self.inventory = {}
    end
    self:UpdateExp(crop_info.exp)
    self:AddCoins(crop_info.coins)
    -- if crop in inventory, add 1 to amount
    local found = false
    for _, item in ipairs(self.inventory) do
        if item.crop_info.name == crop_info.name then
            item.amount = item.amount + 1
            found = true
            break
        end
    end

    -- Si no se encontró en el inventario, agregarlo como nuevo
    if not found then
        table.insert(self.inventory, {
            crop_info = crop_info,
            amount = 1
        })
    end

end

-- funtions for update
function Player:UpdateExp(mount)
    self.xp = self.xp + mount

    -- lvl up self harvest
    if self.xp >= self.nextLvl then
        self.xp = self.xp - self.nextLvl
        self.lvlOfHarvest = self.lvlOfHarvest + 1
        self.nextLvl = self.nextLvl + 100

    end

end
function Player:AddCoins(coins)
    self.coins = self.coins + coins

end

function Player:setHoe(lvl)
    if lvl > 7 then
        lvl = 7
    end

    self.Hoelvl = lvl
    self.Hoe = Hoe(lvl, self)
end

function Player:save()
    return {
        lvlOfHarvest = self.lvlOfHarvest,
        xp = self.xp,
        nextlvl = self.nextLvl,
        Harvesting = self.Harvesting,
        coins = self.coins,
        inventory = self.inventory,
        Hoelvl = self.Hoelvl
    }
end

function Player:load(data)
    if data == nil then
        return
    end
    self.lvlOfHarvest = data.lvlOfHarvest
    self.xp = data.xp
    self.nextLvl = data.nextlvl
    self.Harvesting = data.Harvesting
    self.coins = data.coins
    self.inventory = data.inventory
    if data.Hoelvl ~= nil then
        self.Hoelvl = data.Hoelvl
        self.Hoe = Hoe(self.Hoelvl, self)
    end
end
