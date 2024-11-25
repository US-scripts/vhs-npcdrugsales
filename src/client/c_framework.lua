
function getPlayerData()
    if setupConfig.Framework == 'esx' then
        return ESX.GetPlayerData()
    elseif setupConfig.Framework == 'qbcore' then
        return QBCore.Functions.GetPlayerData()
    else
        print("unsupported framework in ")
        return nil
    end
end

function getJob(source)
    if Framework == 'esx' then
        local playerData = ESX.GetPlayerData()
        if playerData then
            return playerData.job.name, playerData.job.grade, playerData.job.grade_label
        end
    elseif Framework == 'qbcore' then
        local playerData = QBCore.Functions.GetPlayerData()
        if playerData then
            return playerData.job.name, playerData.job.grade.level, playerData.job.grade.name
        end
    else
        print("Unsupported framework")
        return 'unemployed', 'unemployed', 0
    end
    return 'unemployed', 'unemployed', 0
end

function removeTarget(name)
    if Framework == 'esx' then
        exports.ox_target:removeGlobalPed(name)
    elseif Framework == 'qbcore' then
        exports['qb-target']:RemoveGlobalPed(name)
    end
end

function targetPeds(name, event, icon, label, item, action, interact, job, gang, distance)
    if GetResourceState('ox_target') == 'started' then
        exports.ox_target:addGlobalPed({
            { name = name, icon = icon, label = label, event = event, distance = distance, items = item, groups = job, 
                onSelect = function(data)
                    if action and type(action) == "function" then
                        action(data) 
                    end
                end,
                canInteract = function(entity, distance, coords, name, bone)
                    if type(interact) == "function" then
                        return interact(entity, distance, coords, name, bone)
                    end
                    return true 
                end
            }
        })
    elseif GetResourceState('qb-target') == 'started' then
        exports['qb-target']:AddGlobalPed({
            options = { 
              {  event = event,  icon = icon, label = label,  item = item, 
                action = function(entity)
                    if action and type(action) == "function" then
                        action(entity) 
                    end
                end,
                canInteract = function(entity, distance, data) 
                    if type(interact) == "function" then
                        return interact(entity, distance, data)
                    end
                    return true 
                end,
                job = job, 
              }
            },
            distance = 2.5, 
          })
    else
        print('Unsupported framework: ' .. tostring(Framework))
    end
end


