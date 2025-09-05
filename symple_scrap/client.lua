local playerLoaded = false
local inScrapyard = false
local currentScrapyard = nil
local hasPermission = false
local permissionExpiry = 0
local searchDisabledUntil = 0
local bossNPCs = {}
local playerCooldowns = {}
local searchedProps = {}

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    playerLoaded = true
end)

local function isInScrapyard()
    local playerCoords = GetEntityCoords(PlayerPedId())
    
    for i, scrapyard in ipairs(Config.ScrapyardLocations) do
        local distance = #(playerCoords - scrapyard.coords)
        if distance <= scrapyard.radius then
            return true, i
        end
    end
    return false, nil
end

local function talkToBoss(data)
    local currentTime = GetGameTimer()
    local scrapyardIndex = data.scrapyardIndex
    local cooldownKey = "scrapyard_" .. scrapyardIndex
    
    if playerCooldowns[cooldownKey] and (currentTime - playerCooldowns[cooldownKey]) < Config.BossSettings.cooldownTime then
        local remainingTime = math.ceil((Config.BossSettings.cooldownTime - (currentTime - playerCooldowns[cooldownKey])) / 60000) -- Convert to minutes
        lib.notify({
            type = 'error',
            description = string.format(Config.Translation.cooldown_active, remainingTime .. " minutes")
        })
        return
    end
    
    if hasPermission and currentTime < permissionExpiry then
        lib.notify({
            type = 'inform',
            description = Config.Translation.permission_active
        })
        return
    end
    
    lib.notify({
        type = 'success',
        description = Config.Translation.boss_greeting
    })
    
    Wait(2000) 
    
    lib.notify({
        type = 'success',
        description = Config.Translation.permission_granted
    })
    
    hasPermission = true
    permissionExpiry = currentTime + (30 * 60 * 1000) -- 30 minutes for testing
    
    playerCooldowns[cooldownKey] = currentTime
    
    searchedProps = {}

    searchDisabledUntil = 0
end

local function searchProp(data)
    local entity = data.entity
    if not entity or not DoesEntityExist(entity) then return end

    if searchedProps[entity] then
        lib.notify({
            type = 'error',
            description = Config.Translation.already_searched or "You have already searched this."
        })
        return
    end

    local currentTime = GetGameTimer()
    
    if searchDisabledUntil > 0 and currentTime < searchDisabledUntil then
        local remainingMinutes = math.ceil((searchDisabledUntil - currentTime) / 60000)
        lib.notify({
            type = 'error',
            description = string.format(Config.Translation.search_disabled, remainingMinutes)
        })
        return
    end
    
    if not hasPermission or currentTime >= permissionExpiry then
        lib.notify({
            type = 'error',
            description = Config.Translation.need_permission
        })
        return
    end

    local propModel = GetEntityModel(entity)
    local modelName = GetEntityArchetypeName(entity)

    local playerPed = PlayerPedId()
    RequestAnimDict(Config.SearchSettings.animDict)
    while not HasAnimDictLoaded(Config.SearchSettings.animDict) do
        Wait(10)
    end
    
    TaskPlayAnim(playerPed, Config.SearchSettings.animDict, Config.SearchSettings.animName, 8.0, -8.0, -1, 1, 0, false, false, false)

    local progress = lib.progressCircle({
        duration = Config.SearchSettings.duration,
        label = Config.Translation.progress,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true,
        },
    })

    ClearPedTasks(playerPed)

    if progress then
        lib.notify({
            type = 'inform',
            description = Config.Translation.skillcheck
        })
        
        local skillCheckSuccess = lib.skillCheck(Config.SearchSettings.skillCheck.difficulty, Config.SearchSettings.skillCheck.keys)
        
        if skillCheckSuccess then
            TriggerServerEvent('scrapyard:server:searchProp', ObjToNet(entity), modelName)
            searchedProps[entity] = true
        else
            lib.notify({
                type = 'error',
                description = Config.Translation.skillcheck_failed
            })
        end
    end
end

local function canSearchProp(entity, distance, data)
    if not inScrapyard then
        return false 
    end
    
    local currentTime = GetGameTimer()
    
    if searchDisabledUntil > 0 and currentTime < searchDisabledUntil then
        return false
    end
    
    if not hasPermission or currentTime >= permissionExpiry then
        return false
    end
    
    local modelName = GetEntityArchetypeName(entity)
    
    for _, propName in ipairs(Config.SearchableProps) do
        if modelName == propName then
            return true
        end
    end
    
    local lowerModelName = modelName:lower()
    if string.find(lowerModelName, "car") or 
       string.find(lowerModelName, "rub") or 
       string.find(lowerModelName, "wreck") or 
       string.find(lowerModelName, "scrap") or 
       string.find(lowerModelName, "barrel") or 
       string.find(lowerModelName, "dumpster") then
        
        return true
    end
    
    return false
end

Citizen.CreateThread(function()
    while not playerLoaded do
        Wait(100)
    end
    
    local maxAttempts = 30
    local attempts = 0
    
    while attempts < maxAttempts do
        if exports.ox_target then
            break
        else
            attempts = attempts + 1
            Wait(1000)
        end
    end

    if not exports.ox_target then
        print('^1[symple_scrap] ox_target was not ready after ' .. maxAttempts .. ' seconds. Target functionality will be disabled.')
        return
    end
    
    RequestModel(Config.BossSettings.model)
    while not HasModelLoaded(Config.BossSettings.model) do
        Wait(100)
    end
    
    for i, bossLocation in ipairs(Config.BossSettings.locations) do
        local npc = CreatePed(4, Config.BossSettings.model, bossLocation.coords.x, bossLocation.coords.y, bossLocation.coords.z, bossLocation.heading, false, true)
        SetEntityInvincible(npc, true)
        SetBlockingOfNonTemporaryEvents(npc, true)
        FreezeEntityPosition(npc, true)
        bossNPCs[i] = npc
    end
    
    for i, bossLocation in ipairs(Config.BossSettings.locations) do
        exports.ox_target:addLocalEntity(bossNPCs[i], {
            {
                name = 'scrapyard:boss_' .. i,
                label = Config.Translation.talk_to_boss,
                icon = 'fa-solid fa-user-tie',
                onSelect = function()
                    talkToBoss({scrapyardIndex = bossLocation.scrapyardIndex})
                end,
                distance = 3.0
            }
        })
    end

    exports.ox_target:addGlobalObject({
        {
            name = 'scrapyard:search',
            label = Config.Translation.Search,
            icon = 'fa-solid fa-magnifying-glass',
            onSelect = searchProp,
            canInteract = canSearchProp,
            distance = Config.SearchSettings.interactionDistance
        }
    })
end)

Citizen.CreateThread(function()
    while true do
        if playerLoaded then
            local wasInScrapyard = inScrapyard
            local wasCurrentScrapyard = currentScrapyard
            
            inScrapyard, currentScrapyard = isInScrapyard()
            
            if inScrapyard and not wasInScrapyard then
                local scrapyardName = Config.ScrapyardLocations[currentScrapyard].name
                if math.random(1, 100) <= 2 then -- 2% chance
                    lib.notify({
                        type = 'inform',
                        description = string.format(Config.Translation.entered_scrapyard, scrapyardName)
                    })
                end
            end
            
            if not inScrapyard and wasInScrapyard then
                if math.random(1, 100) <= 2 then -- 2% chance
                    lib.notify({
                        type = 'inform', 
                        description = Config.Translation.left_scrapyard
                    })
                end
            end
        end
        
        Wait(2000) -- Check every 2 seconds
    end
end)

Citizen.CreateThread(function()
    while true do
        local currentTime = GetGameTimer()
        
        if hasPermission and currentTime >= permissionExpiry then
            hasPermission = false
            searchDisabledUntil = currentTime + (30 * 60 * 1000) -- 30 minutes
            
            lib.notify({
                type = 'error',
                description = Config.Translation.time_up_cooldown or "Your time is up! You can come back in 30 minutes."
            })
        end
        
        Wait(60000) 
    end
end)
