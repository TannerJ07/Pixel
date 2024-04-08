local types = {
    air = {
        liquid = true,
        gas = true
    },
    sand = {},
    water = {
        liquid = true
    },
    fire = {},
    steam = {
        liquid = true
    },
    border = {}
}

function MoveSand(smallGrid)
    local newGrid = EmptyGrid()
    local direction = 6-math.random(2)*2
    if types[smallGrid[5-direction][3]]["gas"] and types[smallGrid[2][3]]["liquid"] then
        newGrid[2][2] = smallGrid[5-direction][3]
        newGrid[2][3] = "sand"
    elseif types[smallGrid[2][3]]["liquid"] then
        newGrid[2][2] = smallGrid[2][3]
        newGrid[2][3] = "sand"
    elseif types[smallGrid[5-direction][3]]["liquid"] then
        newGrid[2][2] = smallGrid[5-direction][3]
        newGrid[5-direction][3] = "sand"
    end
    return newGrid
end

function MoveWater(smallGrid)
    local newGrid = EmptyGrid()
    for i =1,3 do
        for j = 1,3 do
            if smallGrid[i][j] == "fire" then
                newGrid[2][2] = "steam"
                return newGrid
            end
        end
    end
    if smallGrid[2][3] == "air" then
        newGrid[2][2] = "air"
        newGrid[2][3] = "water"
    else
        local direction = math.random(2)*2
        if smallGrid[5-direction][2] == "air" then
            newGrid[5-direction][2] = "water"
            newGrid[2][2] = "air"
        end
    end
    return newGrid
end

function MoveFire(smallGrid)
    local newGrid = EmptyGrid()
    if math.random() >= 0.04 then
        if smallGrid[2][1] == "air" and math.random()>=0.33 then
            newGrid[2][2] = "air"
            newGrid[2][1] = "fire"
        else
            local direction = math.random(2)*2
            if smallGrid[5-direction][2] == "air" then
                newGrid[5-direction][2] = "fire"
                newGrid[2][2] = "air"
            end

        end
    else
        newGrid[2][2] = "air"
    end
    return newGrid
end

function MoveSteam(smallGrid)
    local newGrid = EmptyGrid()
    if math.random() >= 0.02 then
        if smallGrid[2][1] == "air" and math.random()>=0.33 then
            newGrid[2][2] = "air"
            newGrid[2][1] = "steam"
        else
            local direction = math.random(2)*2
            if smallGrid[5-direction][2] == "air" then
                newGrid[5-direction][2] = "steam"
                newGrid[2][2] = "air"
            end

        end
    else
        newGrid[2][2] = "water"
    end
    return newGrid
end