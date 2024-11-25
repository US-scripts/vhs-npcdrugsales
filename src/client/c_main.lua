if Framework == 'esx' then ESX = exports["es_extended"]:getSharedObject() else QBCore = exports['qb-core']:GetCoreObject() end

local interactedPeds = {}
isSelling = false

AddEventHandler('onResourceStart', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    sellBlips()
end)


if Framework == 'esx' then
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer, isNew, skin)
        ESX.PlayerData = xPlayer
        sellBlips()
    end)
end

if Config.Framework == 'qbcore' then
    local PlayerData = {}
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerData = QBCore.Functions.GetPlayerData()
        sellBlips()
    end)
end


for Type, sell in pairs(Sell) do
    local sphere = lib.zones.sphere({
        coords = sell.peds.loc, 
        radius = sell.peds.radius, 
        debug = false, 
        inside = function()
            
        end,
        onEnter = function()
            targetSell(Type, sell)
        end,
        onExit = function()
            removeTarget('vhs-drugs:sellingPeds'..Type)
        end
    })
end

function sellBlips()
    for k, v in pairs(Sell) do
        local location = v.peds.loc
        local radius = v.peds.radius
        local blipz = v.blips
        if blipz.useRadius then
            local radiusBlip = AddBlipForRadius(location.x, location.y, location.z, radius)
            SetBlipColour(radiusBlip, blipz.color)
            SetBlipAlpha(radiusBlip, 128)
        end
        if blipz.useBlip then
            local blip = AddBlipForCoord(location.x, location.y, location.z)
            SetBlipSprite(blip, blipz.sprite)
            SetBlipDisplay(blip, 4) 
            SetBlipScale(blip, blipz.scale)
            SetBlipColour(blip, blipz.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(blipz.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end

function isPedIgnored(entity)
    local modelHash = GetEntityModel(entity)
    for _, pedName in ipairs(ignorePedsList) do
        if GetHashKey(pedName) == modelHash then
            return true
        end
    end
    return false
end

function targetSell(Type, sell)
    local location = sell.peds.loc
    local radius = sell.peds.radius   
    local action = function(entity)
        if not entity then return false end
        local entityId = (type(entity) == "table" and entity.entity) or entity
        if not entityId then return end
        local player = PlayerPedId()
        if not interactedPeds[entityId] then
            SellItem(entityId, player, Type)
            interactedPeds[entityId] = true  
        end
    end
    local interact = function(entity, distance, coords, name, bone)
        local jName, jGrade, jLabel = getJob()
        for _, blacklistedJob in ipairs(blacklistedJobs) do
            if jName == blacklistedJob then
                return false
            end
        end

        if not entity then return false end
        local entityId = (type(entity) == "table" and entity.entity) or entity
        if not entityId then return false end
        local playerCoords = GetEntityCoords(PlayerPedId())
        local dist = #(playerCoords - location)
        if dist <= radius and not interactedPeds[entityId] and not isSelling then
            if not isPedIgnored(entityId) then 
                return true  
            else
                print("Interaction with this ped is not allowed.") 
                return false
            end
        else
            return false  
        end
    end
    if targetPeds then
        targetPeds('vhs-drugs:sellingPeds'..Type, event, icon, 'Sell', event, action, interact, job, gang, 1.5) 
    else
        print("targetPeds function is not defined")
    end
end

function SellItem(ped, player, Type)
    isSelling = true
    if DoesEntityExist(ped) then
        ClearPedTasksImmediately(ped)
        lib.requestAnimDict('misscarsteal4@actor', 500)
        TaskTurnPedToFaceEntity(ped, player, 1000)
        Citizen.Wait(1000)
        FreezeEntityPosition(ped, true)
        TaskStandStill(ped, 3000)
        TaskPlayAnim(player, 'misscarsteal4@actor', 'actor_berating_loop', 8.0, -8.0, -1, 50, 0, false, false, false)
        TaskPlayAnim(ped, "misscarsteal4@actor", "actor_berating_loop", 8.0, -8.0, 5000, 49, 0, false, false, false)
        Citizen.Wait(3000)
        lib.requestAnimDict("mp_ped_interaction", 10000)
        Citizen.Wait(1000)
        if DoesEntityExist(ped) then
            FreezeEntityPosition(ped, true)
            TaskStandStill(ped, 6000)
            TaskPlayAnim(player, "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, 5000, 49, 0, false, false, false)
            TaskPlayAnim(ped, "mp_ped_interaction", "handshake_guy_a", 8.0, -8.0, 5000, 49, 0, false, false, false)
            ProgressBar(5000, "Making Deal")
            ClearPedTasks(player)
            ClearPedTasks(ped)
            FreezeEntityPosition(ped, false)
        end
        lib.callback.await('vhs-drugs:sellPed', false, Type)
        isSelling = false
    else
        print("Ped does not exist!")
    end
end

RegisterNetEvent('vhs-drugs:policeBlip')
AddEventHandler('vhs-drugs:policeBlip', function(coords)
    if IsPlayerPolice() then
        local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
        SetBlipSprite(blip, 58) 
        SetBlipDisplay(blip, 4) 
        SetBlipScale(blip, 0.8)
        SetBlipColour(blip, 4) 
        SetBlipAsShortRange(blip, false) 
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Possible Drug Sale')
        EndTextCommandSetBlipName(blip)
        SetNewWaypoint(coords.x, coords.y)
        Citizen.SetTimeout(60000, function() 
            RemoveBlip(blip)
        end)
    end
end)

function IsPlayerPolice()
    local job = getJob(source)
    if job and (job.name == "police" or job == "police") then
        return true
    end
    return false
end
