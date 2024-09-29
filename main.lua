local files = love.filesystem.getDirectoryItems("assets")
local loaded = {}

local scalingFactor = 0.2
local isBouncing = false
local bounceTime = 0
local bounceDuration = 0.2

local data = {
    currency = 0,
    currencyPerClick = 1,
    currencyPerSecond = 0,
    upgrades = {
        u1 = {
            name = "Beach Cleaner",
            desc = "People to help clean up",
            level = 1,
            cost = 10,
            scalingCost = 1.2,
            color = "1,1,1"
        },
        u2 = {
            name = "Trash Diver",
            desc = "People who dive into the trash.",
            level = 1,
            cost = 200,
            scalingCost = 1.5,
            color = "1,1,1"
        }
    }
}

function love.load()
    love.window.setMode(800, 600)
    love.window.setTitle("EcoClicker Game")
    love.graphics.setFont(love.graphics.newFont(24))
    loaded["backgroundleft"] = love.graphics.newImage("assets/backgroundleft.png")  -- Load the new image

    for i, file in ipairs(files) do
        local fname = file:gsub("%.png", "")
        local newFile = love.graphics.newImage("assets/" .. file)
        loaded[fname] = newFile
    end
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local trashWidth, trashHeight = loaded["trash"]:getDimensions()

        if x >= 25 and x <= 25 + trashWidth * scalingFactor and y >= 250 and y <= 250 + trashHeight * scalingFactor then
            data.currency = data.currency + data.currencyPerClick
            isBouncing = true
            bounceTime = 0
        end

        local alignY = 100
        for key, upgrade in pairs(data.upgrades) do
            local upgradeAreaY = alignY
            
            if x >= 610 and x <= 790 and y >= upgradeAreaY and y <= upgradeAreaY + 50 then
                if data.currency >= upgrade.cost then
                    data.currency = data.currency - upgrade.cost
                    upgrade.level = upgrade.level + 1
                    upgrade.cost = math.ceil(upgrade.cost * upgrade.scalingCost)
                end
            end
            
            alignY = alignY + 60
        end
    end
end

function love.update(dt)
    data.currency = data.currency + (data.currencyPerSecond * dt)

    if isBouncing then
        bounceTime = bounceTime + dt
        local scale = 0.1 + 0.1 * math.sin((bounceTime / bounceDuration) * (math.pi))
        if bounceTime >= bounceDuration then
            scale = 0.2
            isBouncing = false
        end
        scalingFactor = scale
    else
        scalingFactor = 0.2
    end
end

function love.draw()
    love.graphics.setColor(1, 1, 1)  -- Reset color to white to draw the image without tinting
    love.graphics.draw(loaded["backgroundleft"], 0, 0, 0, 250 / loaded["backgroundleft"]:getWidth(), 600 / loaded["backgroundleft"]:getHeight())  -- Scale to fit the left column area
    
    love.graphics.setColor(0.1, 0.5, 0.8)
    love.graphics.rectangle("fill", 0, 0, 250, 600)

    love.graphics.setColor(0.3, 0.3, 0.3)
    love.graphics.rectangle("fill", 600, 0, 200, 600)

    love.graphics.draw(loaded["trash"], 25, 200, 0, scalingFactor * 1.5, scalingFactor * 1.5)

    love.graphics.setColor(0, 1, 0)
    love.graphics.setFont(love.graphics.newFont(40))
    love.graphics.print("Money: " .. math.floor(data.currency), 20, 20)

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(14))
    love.graphics.print("GLOBE Protocols", 50, 550)
    
    local alignY = 100
    
    for key, upgrade in pairs(data.upgrades) do
        love.graphics.setColor(1, 1, 1)
        love.graphics.rectangle("fill", 610, alignY, 180, 50)
        love.graphics.setColor(0, 0, 0)
        love.graphics.setFont(love.graphics.newFont(10))
        love.graphics.print(upgrade.name .. " (Level " .. upgrade.level .. "): " .. upgrade.cost, 620, alignY + 10)
        love.graphics.print(upgrade.desc, 620, alignY + 30)
        alignY = alignY + 60
    end
end
