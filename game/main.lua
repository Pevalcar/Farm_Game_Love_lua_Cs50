function love.load()
    Object = require "lib/classic"
    json = require "lib/json"
    require "src/Crop"
    require "src/Player"
    require "src/GardenCell"
    require "src/GardenGrid"
    require "src/CircularBar"
    lume = require "lib/lume"
    require "src/inventories/hoes"

    Player = Player()
    -- load Json file    
    -- Create crops garden grid
    Garden_Grid = GardenGrid(6, 6)

    if love.filesystem.getInfo("save.txt") then
        load()
    end

    SpeedMultiplier = 0.5 + Player.Hoe.hoe_info.multiplier
end

function love.update(dt)
    Garden_Grid:update(dt)

end

function love.draw()

    Garden_Grid:draw()
    love.graphics.setColor(255, 255, 255)

    love.graphics.print("Player lvl harvest " .. Player.lvlOfHarvest, 100, 100)
    love.graphics.print("Player exp  " .. Player.xp .. "/" .. Player.nextLvl, 100, 110)
    love.graphics.print("Player coins  " .. Player.coins, 100, 120)
    love.graphics.print("SpeedMultiplier - " .. SpeedMultiplier * Player.lvlOfHarvest .. " sec hoe name " ..
                            Player.Hoe.hoe_info.name, 100, 130)
    love.graphics.print("Player hoe lvl " .. Player.Hoelvl, 100, 140)
    love.graphics.print("Player inventory", 100, 160)
    for i, crop in pairs(Player.inventory) do
        love.graphics.print(crop.crop_info.name .. " " .. crop.amount, 100, 170 + i * 20)
    end
    if Player.Hoe ~= nil then
        Player.Hoe:draw()
    end

end

function love.keypressed(key)
    if key == "f1" then
        save()
    elseif IS_DEBUG then
        if key == "f2" then
            love.event.quit("restart")
        elseif key == "f3" then
            Player:setHoe(Player.Hoelvl + 1)

        end
    end

end

function save()
    -- save data
    local data = {}
    -- data player save
    data.player = Player:save()

    -- data garden save
    data.garden = Garden_Grid:save()
    serialized = lume.serialize(data)
    love.filesystem.write("save.txt", serialized)
end

function load()
    -- load data
    file = love.filesystem.read("save.txt")
    local data = lume.deserialize(file)

    --- add player data 
    Player:load(data.player)
    -- add garden data
    Garden_Grid:load(data.garden)

end
