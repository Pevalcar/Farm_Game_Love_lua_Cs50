UI = Object:extend()

function UI:new()
    self.type = "UI"
    self.parent = loveframes
    self:drawPanel()
    self:drawTabs()

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
    UI:updateMods(Player.mods)
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
    tabs:AddTab("Inventory", self.inventory, "Inventory", love.graphics.newImage("assets/img/inventory/chest.png"))

    -- mods tabs
    self.mods_panel = loveframes.Create("list")
    self.mods_panel:SetSpacing(20)
    self.mods_panel:SetPadding(10)
    self:updateMods(Player.mods)

    tabs:AddTab("Mods", self.mods_panel, "Mods")

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

function UI:updateMods(mods)

    if self.mods_panel ~= nil then
        self.mods_panel:Clear()
        -- hoe title 
        local hove_lvl = mods.Hoe.lvl + 1
        if hove_lvl <= 7 then
            self:drawTitle("Hoe")
            local panel = loveframes.Create("list")
            panel:SetSize(300, 71)
            panel:EnableHorizontalStacking(true)
            panel:SetSpacing(20)
            panel:SetPadding(10)

            local image = loveframes.Create("image", panel)
            image:SetImage("assets/img/inventory/hoe/Hoes" .. hove_lvl .. ".png")
            image:SetSize(30, 30)
            image:SetScale(0.8, 0.8)

            local text = loveframes.Create("text", panel)

            local text_name = {{}, string.format("Upgrade to level %d", hove_lvl), {
                color = {1, 1, 1, 1},
                font = love.graphics.newFont(15)
            }, "\n", {}, string.format("Cost: %d", Hoes_lib_info[hove_lvl].price)}
            text:SetText(text_name)
            text:SetSize(100, 0)
            text:SetFont(love.graphics.newFont(15))
            text:SetShadow(true)

            local button = loveframes.Create("imagebutton", panel)
            button:SetText("")
            button:SetImage("assets/img/inventory/buy_button1.png")
            button:SetFont(love.graphics.newFont(15))
            button:SetSize(50, 35)
            button.OnMouseEnter = function(object)
                object:SetImage("assets/img/inventory/buy_button2.png")
            end
            button.OnMouseExit = function(object)
                object:SetImage("assets/img/inventory/buy_button1.png")
            end
            button.Update = function(object)
                if Player.coins >= Hoes_lib_info[hove_lvl].price then
                    object:SetEnabled(true)
                else
                    object:SetEnabled(false)
                    object:SetImage("assets/img/inventory/buy_button3.png")

                end
            end
            button.OnClick = function(object)
                Player:AddCoins(-Hoes_lib_info[hove_lvl].price)
                Player:setHoe()
            end

            self.mods_panel:AddItem(panel)
        end
    end

end

function UI:updateInventory(inventory)
    if self.inventory ~= nil then
        self.inventory:Clear()
        for i, item in ipairs(inventory) do
            -- panel 
            local panel = loveframes.Create("list")
            panel:SetSize(300, 71)
            panel:EnableHorizontalStacking(true)
            panel:SetSpacing(20)
            panel:SetPadding(10)

            local image = loveframes.Create("image", panel)
            local image_name = "assets/img/inventory/crops/" .. item.crop_info.name .. ".png"
            image:SetImage(image_name)
            image:SetSize(50, 30)
            image:SetScale(2, 2)

            local text = loveframes.Create("text", panel)

            local crop_name = MyString.UpperCaseFirst(item.crop_info.name)

            local text_name = string.format("%s \nAmount: %d \nPrice: %d", crop_name, item.amount, item.crop_info.coins)
            text:SetText(text_name)
            text:SetSize(100, 0)
            text:SetFont(love.graphics.newFont(15))
            text:SetShadow(true)

            local button = loveframes.Create("imagebutton", panel)
            button:SetText("")
            button:SetImage("assets/img/inventory/sell_button1.png")
            button:SetFont(love.graphics.newFont(15))
            button:SetSize(50, 35)
            button.OnMouseEnter = function(object)
                object:SetImage("assets/img/inventory/sell_button2.png")
            end
            button.OnMouseExit = function(object)
                object:SetImage("assets/img/inventory/sell_button1.png")
            end
            button.OnClick = function(object)
                Player:SellCrop(item.crop_info)
            end

            self.inventory:AddItem(panel)
        end
    end

end

function UI:drawTitle(title)

    local text_titel = loveframes.Create("text")
    local text =
        (string.format("-----------------------------------\n%s \n------------------------------------", title))
    text_titel:SetText(text)
    text_titel:SetSize(100, 0)
    text_titel:SetFont(love.graphics.newFont(15))
    text_titel:SetShadow(true)
    self.mods_panel:AddItem(text_titel)
end
