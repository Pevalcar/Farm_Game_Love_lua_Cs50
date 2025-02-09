UI = Object:extend()

function UI:new()
    self.type = "UI"
    self.parent = loveframes
    self:drawPanel()
    self:drawTabs()

end

function UI:draw()

end

function UI:update(dt)

end

function UI:drawPanel()
    local panel = self.parent.Create("image")
    panel:SetImage("assets/img/inventory/bg_inventory.png")
    panel:SetPos(460, 0)
    -- progress bar from exponent
    self.progressbar = self.parent.Create("progressbar")
    self.progressbar:SetMax(Player.nextLvl)
    self.progressbar:SetValue(Player.xp)
    self.progressbar:SetPos(572, 20)
    self.progressbar:SetWidth(208)
    self.progressbar:SetLerpRate(40)
    self.progressbar:SetLerp(true)
    -- lvl info 
    self.lvl_info = self.parent.Create("text")
    local text = {{
        font = love.graphics.newFont(15)
    }, "Level: " .. Player.lvlOfHarvest}
    self.lvl_info:SetText(text)
    self.lvl_info:SetPos(572, 60)
    -- coins info
    local coin_img = loveframes.Create("image")
    coin_img:SetImage("assets/img/inventory/coin.png")
    coin_img:SetPos(650, 55)
    coin_img:SetScale(0.5, 0.5)

    self.coins_info = self.parent.Create("text")
    local text = {{
        font = love.graphics.newFont(15)
    }, ": " .. Player.coins}
    self.coins_info:SetText(text)
    self.coins_info:SetPos(680, 60)

    -- name hoe 
    self.hoe_name = self.parent.Create("text")
    self.hoe_name:SetText(Player.Hoe.hoe_info.name)
    self.hoe_name:SetPos(480, 105)
    self.hoe_name:SetFont(love.graphics.newFont(15))
    self.hoe_name:SetDefaultColor(self:rarityColor(Player.Hoe.hoe_info.rarity))
    self.hoe_name:SetShadow(true)

end

function UI:updateProgressBar(value, max)

    if self.progressbar ~= nil then
        self.progressbar:SetValue(value)
        self.progressbar:SetMax(max)
    end

end

function UI:updateLvlInfo(lvl)

    if self.lvl_info ~= nil then
        self.lvl_info:SetText("Level: " .. lvl)
    end

end

function UI:updateCoinsInfo(coins)

    if self.coins_info ~= nil then
        self.coins_info:SetText(": " .. coins)
    end

end

function UI:updateHoeInfo(hoe_info)

    if self.hoe_name ~= nil then
        self.hoe_name:SetText(hoe_info.name)
        love.graphics.setColor(255, 255, 255)
        self.hoe_name:SetDefaultColor(self:rarityColor(hoe_info.rarity))
    end

end

function UI:rarityColor(rarity)
    if rarity == "common" then
        return {255 / 255, 255 / 255, 255 / 255, 255 / 255}
    elseif rarity == "legendary" then
        return {255 / 255, 0 / 255, 255 / 255, 255 / 255}
    elseif rarity == "rare" then
        return {255 / 255, 0 / 255, 0 / 255, 255 / 255}
    elseif rarity == "uncommon" then
        return {255 / 255, 255 / 255, 0 / 255, 255 / 255}
    elseif rarity == "epic" then
        return {0 / 255, 255 / 255, 255 / 255, 255 / 255}
    else
        return {255 / 255, 255 / 255, 255 / 255, 255 / 255}
    end
end
-- tabs
function UI:drawTabs()
    -- tabs 
    local tabs = loveframes.Create("tabs")
    tabs:SetPos(480, 130)
    tabs:SetSize(300, 485 - 50)

    -- inventory tabs
    self.inventory = loveframes.Create("list")
    self.inventory:SetSpacing(20)
    self.inventory:SetPadding(10)
    self:updateInventory(Player.inventory)

    -- tabs:AddTab("Inventory", inventory_panel, "Inventory",
    --     love.graphics.newImage("assets/img/inventory/inventoryslot.png"))
    tabs:AddTab("Inventory", self.inventory, "Inventory")

    -- mods tabs
    local mods_panel = loveframes.Create("panel")
    self.mods = loveframes.Create("text", mods_panel)
    self.mods:SetText("Mods")
    self.mods:SetAlwaysUpdate(true)
    self.mods.Update = function(object, dt)
        object:Center()
    end
    tabs:AddTab("Mods", mods_panel, "Mods")

    -- for i = 1, 20 do
    --     local panel = loveframes.Create("panel")
    --     local text1 = loveframes.Create("text", panel)
    --     text1:SetText("Tab " .. i)
    --     text1:SetAlwaysUpdate(true)
    --     text1.Update = function(object, dt)
    --         object:Center()
    --     end
    --     tabs:AddTab("Tab " .. i, panel, "Tab " .. i)
    -- end
end

function UI:updateInventory(inventory)
    if self.inventory ~= nil then
        self.inventory:Clear()
        for i, item in ipairs(inventory) do
            local grid = loveframes.Create("grid")
            grid:SetItemAutoSize(true)
            grid:SetColumns(2)
            grid:SetRows(1)
            grid:SetCellSize(25, 25)
            grid:SetCellPadding(5)
            -- crop image 
            local image = love.graphics.newImage(item.crop_info.img)
            local frames = {}
            image:setFilter("nearest", "nearest")
            Crop:getFrames(frames, image)
            local new_image = love.graphics.draw(image, frames[2], 0, 0, 0, 3, 3)

            local text = loveframes.Create("text")
            text:SetText(item.crop_info.name)
            text:SetFont(love.graphics.newFont(15))
            text:SetDefaultColor(self:rarityColor(item.crop_info.rarity))
            text:SetShadow(true)

            -- grid:AddItem(new_image, 1, 1, "center")
            grid:AddItem(text, 1, 2, "center")

            self.inventory:AddItem(grid)
        end
    end

end
