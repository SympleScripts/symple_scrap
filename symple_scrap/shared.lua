
function GetDistance(pos1, pos2)
    return #(pos1 - pos2)
end


function IsSearchableProp(modelName)
    for _, propName in ipairs(Config.SearchableProps) do
        if modelName == propName then
            return true
        end
    end
    return false
end

function FormatTime(seconds)
    local minutes = math.floor(seconds / 60)
    local remainingSeconds = seconds % 60
    
    if minutes > 0 then
        return string.format("%dm %ds", minutes, remainingSeconds)
    else
        return string.format("%ds", remainingSeconds)
    end
end