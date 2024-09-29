local files = love.filesystem.getDirectoryItems("assets")
local loaded = {}




function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("Clicker Game")
    
    currentPoints = 0
    pointsPerClick = 1
    for i,file in ipairs(files) do

        local fname = file:gsub(".png","")
        local newFile = love.graphics.newImage("assets/"..file)
        loaded[fname] = newFile
        
    end
end




-- function love.update(dt)
--     -- logic
-- end


a
function love.draw()

    
    -- love.graphics.setColor(0, 0, 0)
    -- love.graphics.print("Points: " .. currentPoints, 50, 50)
    
    love.graphics.draw(loaded["trash"], 0, 0)
    -- love.graphics.print("Points Per Click: " .. pointsPerClick, 50, 100)

    -- love.graphics.print("Upgrades", 600, 50)
    -- love.graphics.rectangle("line", 550, 100, 200, 400)
end

