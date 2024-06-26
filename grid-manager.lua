function InitiateGrid(width,height)
    local grid = {}
    for i = 1,width do
        grid[i] = {}
        for j = 1,height do
            if i == 1 or i == width or j == 1 or j == height then
                grid[i][j] = "border"
            else
                grid[i][j] = "air"
            end
        end
    end
    return grid
end

function UpdateGrid(grid)
    local newGrid = {}
    local smallGrid
    for i = 1,#grid do
        newGrid[i] = {}
        for j = 1,#grid[1] do
            newGrid[i][j] = grid[i][j]
        end
    end
    local i,j
    for collumn = 2,#grid-1 do
        i=collumn
        for row = 2,#grid[1]-1 do
            --j = #grid[1]-row -- bottom to top
            j=row -- top to bottom
            if CheckNoRules(grid[i][j]) and grid[i][j]==newGrid[i][j] then
                smallGrid = {{newGrid[i-1][j-1],newGrid[i-1][j],newGrid[i-1][j+1]},
                            {newGrid[i][j-1],newGrid[i][j],newGrid[i][j+1]},
                            {newGrid[i+1][j-1],newGrid[i+1][j],newGrid[i+1][j+1]}}
                smallGrid = MoveParticle(smallGrid)
                for x = 1,3 do
                    for y = 1,3 do
                        if smallGrid[x][y] ~= "*" then
                            newGrid[i+x-2][j+y-2] = smallGrid[x][y]
                        end
                    end
                end
            end
        end
    end

    return newGrid

end

function  DrawGrid(grid,cellSize)
    for i = 1,#grid do
        for j = 1,#grid[1] do
            love.graphics.setColor(GetColor(grid[i][j]))
            love.graphics.rectangle("fill",(i-1)*cellSize,(j-1)*cellSize,cellSize,cellSize)
        end
    end
end

function GetSelectorObjects()
    local textObjects = {}
    local categories = GetCategories()
    local font = love.graphics.getFont()
    for i,v in ipairs(categories) do
        textObjects[i] = love.graphics.newText(font,v:upper())
    end
    return textObjects
end

function CreateElementTexts()
    local textObjexts = {}
    local elements = GetElements()
    local font = love.graphics.getFont()
    for i,v in ipairs(elements) do
        textObjexts[v] = love.graphics.newText(font,v:upper())
    end
    return textObjexts
end

function DrawSelector(screenWidth,screenHeight,textObjects,elementObjects,category,element)
    local recWidth,recHeight = screenWidth/#textObjects-10,50
    local categories = GetCategories()
    local elementCategories = GetElementCategory(category)
    local width,height
    local elements = GetElements()
    for i,v in ipairs(textObjects) do
        width  = v:getWidth()
        height = v:getHeight()
        if categories[i] == category then
            love.graphics.setColor(math.sqrt(GetDisplayColor(categories[i])[1]),math.sqrt(GetDisplayColor(categories[i])[2]),math.sqrt(GetDisplayColor(categories[i])[3]),0.3)
            love.graphics.rectangle("fill",(i-1)/#textObjects*screenWidth+5,screenHeight+10,recWidth,recHeight,2)
        end
        love.graphics.setColor(GetDisplayColor(categories[i]))
        love.graphics.rectangle("line",(i-1)/#textObjects*screenWidth+5,screenHeight+10,recWidth,recHeight,2)
        love.graphics.draw(v,(i-1)/#textObjects*screenWidth+(recWidth-width)/2,screenHeight+(recHeight-height)/2+10)
    end
    recWidth,recHeight = 100,50
    local v
    for i,k in ipairs(elementCategories) do
        v = elementObjects[k]
        width  = v:getWidth()
        height = v:getHeight()
        if k == element then
            love.graphics.setColor(math.sqrt(GetDisplayColor(k)[1]),math.sqrt(GetDisplayColor(k)[2]),math.sqrt(GetDisplayColor(k)[3]),0.3)
            love.graphics.rectangle("fill",(i-1)*(recWidth+10)+screenWidth/2-(recWidth+10)/2*#elementCategories,screenHeight+80,recWidth,recHeight,10)
        end
        love.graphics.setColor(GetDisplayColor(k))
        love.graphics.rectangle("line",(i-1)*(recWidth+10)+screenWidth/2-(recWidth+10)/2*#elementCategories,screenHeight+80,recWidth,recHeight,10)
        love.graphics.draw(v,(i-1)*(recWidth+10)+screenWidth/2-(recWidth+10)/2*#elementCategories+(recWidth-width)/2,screenHeight+(recHeight-height)/2+80)
    end
end

function SelectCategory(mousex,screenWidth,category)
    local categories = GetCategories()
    local newCategory = math.floor((mousex-2)/screenWidth*#categories+1)
    if newCategory >= 1 and newCategory <= #categories then
        return categories[newCategory]
    end
    return category
end

function SelectElement(mousex,screenWidth,category,element)
    local elementCategories = GetElementCategory(category)
    local recWidth = 100
    local newElement=math.floor((mousex-screenWidth/2+(recWidth+10)/2*#elementCategories)/(recWidth+10)+1)
    if newElement>=1 and newElement<=#elementCategories then
        return elementCategories[newElement]
    end
    return element
end