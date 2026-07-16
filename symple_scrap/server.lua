local playerLevels = {}
local playerIdentifiers = {}
local playerPermissions = {}
local playerCooldowns = {}
local lastSearch = {}
local lootedProps = {}

local PERMISSION_DURATION = 30 * 60 * 1000
local SEARCH_RATE_LIMIT = 2000

local function isValidItem(itemName)
    local item = exports.ox_inventory:Items(itemName)
    return item ~= nil
end

local function getIdentifier(src)
    if playerIdentifiers[src] then return playerIdentifiers[src] end
    local ids = GetPlayerIdentifiers(src)
    for _, id in ipairs(ids or {}) do
        if id:sub(1, 8) == "license:" then
            playerIdentifiers[src] = id
            return id
        end
    end
    local fallback = (ids and ids[1]) or ("src:" .. src)
    playerIdentifiers[src] = fallback
    return fallback
end

local function getLevel(src)
    local data = playerLevels[src]
    if not data then
        data = { xp = 0, level = 1, loaded = false }
        playerLevels[src] = data
    end
    return data
end

local function loadLevel(src)
    local data = getLevel(src)
    if data.loaded then return end
    local identifier = getIdentifier(src)
    MySQL.single('SELECT xp, level FROM symple_scrap_levels WHERE identifier = ?', { identifier }, function(row)
        if row then
            data.xp = row.xp or 0
            data.level = row.level or 1
        end
        data.loaded = true
    end)
end

local function saveLevel(src)
    local data = playerLevels[src]
    if not data or not data.loaded then return end
    local identifier = playerIdentifiers[src] or getIdentifier(src)
    MySQL.insert(
        'INSERT INTO symple_scrap_levels (identifier, xp, level) VALUES (?, ?, ?) ' ..
        'ON DUPLICATE KEY UPDATE xp = VALUES(xp), level = VALUES(level)',
        { identifier, data.xp, data.level }
    )
end

RegisterNetEvent('scrapyard:server:playerReady', function()
    loadLevel(source)
end)

local function grantXp(src, amount)
    local data = getLevel(src)
    data.xp = data.xp + amount
    local leveled = false
    while data.level < Config.Leveling.maxLevel and data.xp >= data.level * Config.Leveling.xpPerLevel do
        data.xp = data.xp - data.level * Config.Leveling.xpPerLevel
        data.level = data.level + 1
        leveled = true
    end
    if data.level >= Config.Leveling.maxLevel then
        data.xp = 0
    end
    return leveled
end

local function yieldMultiplier(src)
    local data = getLevel(src)
    local bonus = (data.level - 1) * Config.Leveling.yieldPerLevel
    return 1 + bonus
end

local function generateLoot(propModel, mult)
    mult = mult or 1
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
                amount = math.max(1, math.floor(amount * mult + 0.5))
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

RegisterNetEvent('scrapyard:server:checkLevel', function()
    local src = source
    local data = getLevel(src)
    local mult = yieldMultiplier(src)
    local xpNeeded = data.level >= Config.Leveling.maxLevel and 0 or (data.level * Config.Leveling.xpPerLevel)
    TriggerClientEvent('scrapyard:client:showLevel', src, {
        level = data.level,
        xp = data.xp,
        xpNeeded = xpNeeded,
        maxLevel = Config.Leveling.maxLevel,
        bonusPct = math.floor((mult - 1) * 100 + 0.5)
    })
end)

RegisterNetEvent('scrapyard:server:requestPermission', function(scrapyardIndex)
    local src = source
    local currentTime = os.time() * 1000

    if playerCooldowns[src] and (currentTime - playerCooldowns[src]) < Config.BossSettings.cooldownTime then
        local remaining = math.ceil((Config.BossSettings.cooldownTime - (currentTime - playerCooldowns[src])) / 60000)
        TriggerClientEvent('scrapyard:client:permissionDenied', src, remaining)
        return
    end

    playerPermissions[src] = currentTime + PERMISSION_DURATION
    playerCooldowns[src] = currentTime

    TriggerClientEvent('scrapyard:client:permissionGranted', src, PERMISSION_DURATION)
end)

RegisterNetEvent('scrapyard:server:searchProp', function(netId)
    local src = source
    local currentTime = os.time() * 1000

    if not isPlayerInScrapyard(src) then
        return
    end

    if not playerPermissions[src] or currentTime >= playerPermissions[src] then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = Config.Translation.need_permission
        })
        return
    end

    if lastSearch[src] and (currentTime - lastSearch[src]) < SEARCH_RATE_LIMIT then
        return
    end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or not DoesEntityExist(entity) then
        return
    end

    if lootedProps[netId] and currentTime < lootedProps[netId] then
        TriggerClientEvent('ox_lib:notify', src, {
            type = 'error',
            description = Config.Translation.already_searched or "You have already searched this."
        })
        return
    end

    local propModel = GetEntityModel(entity)
    local rewards = generateLoot(propModel, yieldMultiplier(src))

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
        lootedProps[netId] = currentTime + (60 * 60 * 1000)
        lastSearch[src] = currentTime

        local leveled = grantXp(src, Config.Leveling.xpPerSearch)
        local data = getLevel(src)
        saveLevel(src)
        TriggerClientEvent('scrapyard:client:xp', src, data.xp, data.level)
        if leveled then
            TriggerClientEvent('scrapyard:client:levelUp', src, data.level)
        end

        if Config.VerboseFound then
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                description = Config.Translation.found .. " " .. table.concat(rewardMessages, ", ")
            })
        else
            local total = 0
            for _, amt in pairs(rewards) do total = total + amt end
            TriggerClientEvent('ox_lib:notify', src, {
                type = 'success',
                description = Config.Translation.found .. " " .. total .. " item(s)"
            })
        end
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

AddEventHandler('playerDropped', function()
    local src = source
    saveLevel(src)
    playerPermissions[src] = nil
    playerCooldowns[src] = nil
    lastSearch[src] = nil
    playerLevels[src] = nil
    playerIdentifiers[src] = nil
end)

AddEventHandler('onResourceStop', function(resourceName)
    if resourceName ~= GetCurrentResourceName() then return end
    for src, _ in pairs(playerLevels) do
        saveLevel(src)
    end
end)
