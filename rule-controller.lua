

local elementTable = {
    air = nil,
    sand = MoveSand,
    water = MoveWater,
    fire =  MoveFire,
    steam = MoveSteam,
    border = nil
}



function MoveParticle(smallGrid)
    return elementTable[smallGrid[2][2]](smallGrid)
end

function CheckNoRules(element)
    if elementTable[element] then
        return true
    end
end

function Immovable(grid)
    return grid
end

function EmptyGrid()
    return {{"*","*","*"},
            {"*","*","*"},
            {"*","*","*"}}
end