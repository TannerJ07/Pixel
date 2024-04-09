local grid
local cellSize = 10
local screenWidth,screenHeight=love.graphics.getWidth(),love.graphics.getHeight()-150

local gridWidth = math.floor(screenWidth/cellSize)
local gridHeight = math.floor(screenHeight/cellSize)

local doMouse = 1
local mouseSize = 1

local element = "sand"
local catagory = "solid"
local largeFont = love.graphics.setNewFont(20)
local smallFont = love.graphics.setNewFont(12)
local selectorObjects
local elementObjects
function love.load()
    require "grid-manager"
    require "particle-rules"
    love.graphics.setDefaultFilter( "nearest" )

    grid = InitiateGrid(gridWidth,gridHeight)

    love.graphics.setFont(largeFont)
    selectorObjects = GetSelectorObjects()
    elementObjects = CreateElementTexts()
end

function love.update()
    grid = UpdateGrid(grid)
    local mousex = love.mouse.getX()
    local mousey = love.mouse.getY()

    if love.mouse.isDown(1) and doMouse == 1 then

        for i = 1,mouseSize do
            for j = 1,mouseSize do
                if 2*mousex>=(-2*i+mouseSize+3)*cellSize and mousex*2<(gridWidth*2-i*2+mouseSize-1)*cellSize and 2*mousey>=(-2*j+mouseSize+3)*cellSize and mousey*2<2*screenHeight+(-2*j+mouseSize-1)*cellSize then
                    grid[math.floor(mousex/cellSize-(mouseSize-1)/2)+i][math.floor(mousey/cellSize-(mouseSize-1)/2)+j]=element
                end
            end
        end
        if mousey > gridHeight*cellSize then
            if mousey > gridHeight*cellSize+50 then
                element = SelectElement(mousex,screenWidth,catagory,element)
            else
                catagory = SelectCategory(mousex,screenWidth,catagory)
            end
        end
        doMouse = 0
    else
        doMouse = 1
    end
    if love.mouse.isDown(2) then
        for i = 1,mouseSize do
            for j = 1,mouseSize do
                if 2*mousex>=(-2*i+mouseSize+3)*cellSize and 2*mousex<2*screenWidth+(-2*i+mouseSize-1)*cellSize and 2*mousey>=(-2*j+mouseSize+3)*cellSize and mousey*2<2*screenHeight+(-2*j+mouseSize-1)*cellSize then
                    grid[math.floor(mousex/cellSize-(mouseSize-1)/2)+i][math.floor(mousey/cellSize-(mouseSize-1)/2)+j]="air"
                end
            end
        end

    end
    
end

function love.keypressed(key)
    --[[local keyCodes = {"sand","water","fire","steam","border"}
    if keyCodes[tonumber(key)] then
        element = keyCodes[tonumber(key)]
    end]]
    if key == "=" then
        if love.keyboard.isDown("backspace") then
            mouseSize = mouseSize+5
        else
            mouseSize =mouseSize+1
        end
    end
    if key == "-" and mouseSize then
        if love.keyboard.isDown("backspace") then
            mouseSize = mouseSize-5
        else
            mouseSize =mouseSize-1
        end
        if mouseSize < 1 then
            mouseSize = 1
        end
    end
end

function love.draw()


    DrawGrid(grid,cellSize)
    DrawSelector(screenWidth,screenHeight,selectorObjects,elementObjects,catagory,element)
    love.graphics.setFont(smallFont)
    love.graphics.setColor(1,1,1)
    love.graphics.print(love.timer.getFPS(),50,50)
    love.graphics.print("Size: "..mouseSize,100,50)
    love.graphics.print("Element: "..element,150,50)
    love.graphics.rectangle("line",(math.floor(love.mouse.getX()/cellSize-(mouseSize-1)/2))*cellSize,(math.floor(love.mouse.getY()/cellSize-(mouseSize-1)/2))*cellSize,mouseSize*cellSize,mouseSize*cellSize)
end