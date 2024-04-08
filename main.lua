local grid
local cellSize = 10
local screenWidth,screenHeight=love.graphics.getWidth(),love.graphics.getHeight()

local gridWidth = math.floor(screenWidth/cellSize)
local gridHeight = math.floor(screenHeight/cellSize)

local doMouse = 1
local mouseSize = 1

local element = "sand"

function love.load()
    require "grid-manager"
    require "particle-rules"

    grid = InitiateGrid(gridWidth,gridHeight,cellSize)
end

function love.update()
    grid = UpdateGrid(grid)
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()

    if love.mouse.isDown(1) and doMouse == 1 then

        for i = 1,mouseSize do
            for j = 1,mouseSize do
                if 2*mousex>=(-2*i+mouseSize+3)*cellSize and 2*mousex<2*screenWidth+(-2*i+mouseSize-1)*cellSize and 2*mousey>=(-2*j+mouseSize+3)*cellSize and 2*mousey<2*screenHeight+(-2*j+mouseSize-1)*cellSize then
                    grid[math.floor(mousex/cellSize-(mouseSize-1)/2)+i][math.floor(mousey/cellSize-(mouseSize-1)/2)+j]=element
                end
            end
        end
        doMouse = 0
    else
        doMouse = 1
    end
    if love.mouse.isDown(2) then
        for i = 1,mouseSize do
            for j = 1,mouseSize do
                if 2*mousex>=(-2*i+mouseSize+3)*cellSize and 2*mousex<2*screenWidth+(-2*i+mouseSize-1)*cellSize and 2*mousey>=(-2*j+mouseSize+3)*cellSize and 2*mousey<2*screenHeight+(-2*j+mouseSize-1)*cellSize then
                    grid[math.floor(mousex/cellSize-(mouseSize-1)/2)+i][math.floor(mousey/cellSize-(mouseSize-1)/2)+j]="air"
                end
            end
        end

    end
end

function love.keypressed(key)
    local keyCodes = {"sand","water","fire","steam","border"}
    if keyCodes[tonumber(key)] then
        element = keyCodes[tonumber(key)]
    end
    if key == "=" then
        mouseSize = mouseSize+1
    end
    if key == "-" and mouseSize ~= 1 then
        mouseSize = mouseSize-1
    end
end

function love.draw()


    DrawGrid(grid,cellSize,elementColors)
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS(),50,50)
    love.graphics.print("Size: "..mouseSize,100,50)
    love.graphics.print("Element: "..element,150,50)
    love.graphics.rectangle("line",(math.floor(love.mouse.getX()/cellSize-(mouseSize-1)/2))*cellSize,(math.floor(love.mouse.getY()/cellSize-(mouseSize-1)/2))*cellSize,mouseSize*cellSize,mouseSize*cellSize)
end