-- Scrapyard Material Collection System - Server Side
local function isValidItem(itemName)
    local item = exports.ox_inventory:Items(itemName)
    return item ~= nil
end

local function generateLoot(propModel)
    local category = Config.PropCategories[propModel] or "wreckage"
    local lootTable = Config.LootTables[category]
    local rewards = {}
    
    if not lootTable then
        return rewards
    end
    
    for rarity, items in pairs(lootTable) do
        for _, itemData in ipairs(items) do
            local roll = math.random(1, 100)
            if roll <= itemData.chance then
                local amount = math.random(itemData.min, itemData.max)
                if not rewards[itemData.item] then
                    rewards[itemData.item] = 0
                end
                rewards[itemData.item] = rewards[itemData.item] + amount
            end
        end
    end
    
    return rewards
end

local function isPlayerInScrapyard(src)
    local playerCoords = GetEntityCoords(GetPlayerPed(src))
    
    for _, scrapyard in ipairs(Config.ScrapyardLocations) do
        local distance = #(vector3(playerCoords.x, playerCoords.y, playerCoords.z) - scrapyard.coords)
        if distance <= scrapyard.radius then
            return true
        end
    end
    return false
end

RegisterNetEvent('scrapyard:server:searchProp', function(netId, propModel)
    local src = source
    
    if not isPlayerInScrapyard(src) then
        return
    end
    
    local rewards = generateLoot(propModel)
    
    if next(rewards) == nil then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'inform',
            description = Config.Translation.nothing
        })
        return
    end
    
    local rewardMessages = {}
    local failedItems = {}
    
    for itemName, amount in pairs(rewards) do
        if amount > 0 then
            if not isValidItem(itemName) then
                table.insert(failedItems, itemName)
            else
                local canCarry = exports.ox_inventory:CanCarryItem(src, itemName, amount)
                if canCarry then
                    local success = exports.ox_inventory:AddItem(src, itemName, amount)
                    if success then
                        table.insert(rewardMessages, amount .. "x " .. itemName)
                    else
                        table.insert(failedItems, itemName)
                    end
                else
                    table.insert(failedItems, itemName)
                end
            end
        end
    end
    
    if #rewardMessages > 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'success',
            description = Config.Translation.found .. " " .. table.concat(rewardMessages, ", ")
        })
    end
    
    if #failedItems > 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = Config.Translation.inventory_full
        })
    end
    
    if #rewardMessages == 0 and #failedItems == 0 then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'inform',
            description = Config.Translation.nothing
        })
    end
end)
