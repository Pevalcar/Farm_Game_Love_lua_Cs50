function love.load()
    Object = require "lib/classic"
    json = require "lib/json"
    require "src/Crop"
    require "src/Player"
    require "src/GardenCell"
    require "src/GardenGrid"
    require "src/CircularBar"

    Player = Player()
    -- load Json file
    file = assert(io.open("assets/data/crops.json", "r"))
    local constent = file:read("*a")
    file:close()
    Crops_lib_info = json.decode(constent)

    -- Create crops garden grid
    Garden_Grid = GardenGrid(6, 6)

end

function love.update(dt)
    Garden_Grid:update(dt)

end

function love.draw()
    Garden_Grid:draw()

    love.graphics.print("Player lvl harvest " .. Player.lvlOfHarvest, 100, 100)
    love.graphics.print("Player exp  " .. Player.xp .. "/" .. Player.nextlvl, 100, 110)
end

