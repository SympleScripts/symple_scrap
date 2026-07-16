local playerLoaded = false
local inScrapyard = false
local currentScrapyard = nil
local hasPermission = false
local permissionExpiry = 0
local searchDisabledUntil = 0
local bossNPCs = {}
local searchedProps = {}

CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end
    playerLoaded = true
    TriggerServerEvent('scrapyard:server:playerReady')
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
    local scrapyardIndex = data.scrapyardIndex
    TriggerServerEvent('scrapyard:server:requestPermission', scrapyardIndex)
end

RegisterNetEvent('scrapyard:client:permissionGranted', function(duration)
    hasPermission = true
    permissionExpiry = GetGameTimer() + duration
    searchedProps = {}
    searchDisabledUntil = 0
    lib.notify({
        type = 'success',
        description = Config.Translation.permission_granted
    })
end)

RegisterNetEvent('scrapyard:client:permissionDenied', function(remainingMinutes)
    lib.notify({
        type = 'error',
        description = string.format(Config.Translation.cooldown_active, remainingMinutes .. " minutes")
    })
end)

RegisterNetEvent('scrapyard:client:xp', function(xp, level)
    LocalPlayerXp = xp
    LocalPlayerLevel = level
end)

RegisterNetEvent('scrapyard:client:levelUp', function(level)
    lib.notify({
        type = 'success',
        description = string.format(Config.Translation.level_up or "Level up! You are now level %d", level)
    })
end)

local function checkLevel()
    TriggerServerEvent('scrapyard:server:checkLevel')
end

RegisterNetEvent('scrapyard:client:showLevel', function(info)
    local xpLine
    if info.level >= info.maxLevel then
        xpLine = "**XP:** MAX LEVEL"
    else
        xpLine = string.format("**XP:** %d / %d", info.xp, info.xpNeeded)
    end
    lib.alertDialog({
        header = Config.Translation.level_header or "Scrapper Progress",
        content = string.format(
            "**Level:** %d / %d  \n%s  \n**Yield bonus:** +%d%%",
            info.level, info.maxLevel, xpLine, info.bonusPct
        ),
        centered = true,
        cancel = false
    })
end)

local function searchProp(data)
    local entity = data.entity
    if not entity or not DoesEntityExist(entity) then return end

    local netId = ObjToNet(entity)

    if searchedProps[netId] then
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
            TriggerServerEvent('scrapyard:server:searchProp', netId)
            searchedProps[netId] = true

            if Config.SearchFX and Config.SearchFX.sound and Config.SearchFX.sound ~= '' then
                PlaySoundFrontend(-1, Config.SearchFX.sound, Config.SearchFX.soundSet or 'HUD_FRONTEND_DEFAULT_SOUNDSET', false)
            end
            if Config.SearchFX and Config.SearchFX.particle and Config.SearchFX.particle ~= '' then
                local ped = PlayerPedId()
                local coords = GetEntityCoords(ped)
                UseParticleFxAssetNextCall('scr_apartment_mover')
                StartParticleFxNonLoopedAtCoord(Config.SearchFX.particle, coords.x, coords.y, coords.z + 1.0, 0.0, 0.0, 0.0, 1.0, false, false, false)
            end
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

    if not entity or entity == 0 or not DoesEntityExist(entity) then
        return false
    end

    local modelName = GetEntityArchetypeName(entity)

    if IsSearchableProp(modelName) then
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
            },
            {
                name = 'scrapyard:progress_' .. i,
                label = Config.Translation.check_progress or "Check Progress",
                icon = 'fa-solid fa-chart-line',
                onSelect = function()
                    checkLevel()
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
                if math.random(1, 100) <= 2 then
                    lib.notify({
                        type = 'inform',
                        description = string.format(Config.Translation.entered_scrapyard, scrapyardName)
                    })
                end
            end

            if not inScrapyard and wasInScrapyard then
                if math.random(1, 100) <= 2 then
                    lib.notify({
                        type = 'inform',
                        description = Config.Translation.left_scrapyard
                    })
                end
            end
        end

        Wait(2000)
    end
end)

Citizen.CreateThread(function()
    while true do
        local currentTime = GetGameTimer()
        local text = nil

        if hasPermission and currentTime >= permissionExpiry then
            hasPermission = false
            searchDisabledUntil = currentTime + (30 * 60 * 1000)
            lib.notify({
                type = 'error',
                description = Config.Translation.time_up_cooldown or "Your time is up! You can come back in 30 minutes."
            })
        end

        if inScrapyard then
            if hasPermission and currentTime < permissionExpiry then
                local left = math.ceil((permissionExpiry - currentTime) / 1000)
                text = string.format("Scrapping - %d:%02d left", math.floor(left / 60), left % 60)
            elseif searchDisabledUntil > 0 and currentTime < searchDisabledUntil then
                local left = math.ceil((searchDisabledUntil - currentTime) / 1000)
                text = string.format("Cooldown - %d:%02d until boss", math.floor(left / 60), left % 60)
            end
        end

        if text then
            lib.showTextUI(text, {
                position = 'top-right',
                icon = 'fas fa-recycle',
                style = {
                    borderRadius = '8px'
                }
            })
        else
            lib.hideTextUI()
        end

        Wait(1000)
    end
end)

