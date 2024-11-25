
function getPolice()
    local policePlayers = {}
    if Framework == 'esx' then
        local players = ESX.GetExtendedPlayers('job', policejob)
        for i = 1, #players do
            table.insert(policePlayers, players[i].source)  
        end
    elseif Framework == 'qbcore' then
        local players = QBCore.Functions.GetPlayers()
        for i = 1, #players do
            local player = QBCore.Functions.GetPlayer(players[i])
            if player and player.PlayerData.job.name == policejob then
                table.insert(policePlayers, player.PlayerData.source) 
            end
        end
    end
    return policePlayers
end

function GetPlayerData(source)
    if Framework == 'esx' then 
        return 
        ESX.GetPlayerFromId(source)
    elseif Framework == 'qbcore' then 
        return QBCore.Functions.GetPlayer(source)
    end 
end   

function addBlack(source, amount)
    if Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            xPlayer.addAccountMoney('black_money', amount, "Drugs Sold")
        end
    elseif Framework == 'qbcore' then
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
            local info = { worth = amount }
            xPlayer.Functions.AddItem('markedbills', 1, false, info)
        end
    else
        print("Unsupported framework: " .. Framework)
    end
end

function getName(source)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        return xPlayer.getName()

    elseif Framework == 'qbcore' then 
        local player = QBCore.Functions.GetPlayer(source)
        if player then
            return player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname
        end
    end 
end

function GetInventoryItem(source, item)
    if Framework == 'esx' then
        local Player = ESX.GetPlayerFromId(source)
        if Player then
            local esxItem = Player.getInventoryItem(item)
            if esxItem and esxItem.count > 0 then
                return { count = esxItem.count, label = esxItem.label }
            end
        end
    elseif GetResourceState('ox_inventory') == 'started' then
        local OxItem = exports.ox_inventory:GetItem(source, item)
        return { count = OxItem.count, label = OxItem.label }
    elseif Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(source)
        if Player then
            local qItem = exports['qb-inventory']:GetItemByName(source, item)
            if qItem and qItem.amount then
                return { count = qItem.amount, label = qItem.label }
            end
        end
    end
    return nil
end

function GetItemLabel(item)
    if Framework == 'esx' then
        return ESX.GetItemLabel(item)
    elseif Framework == 'qbcore' then
        if QBCore and QBCore.Shared and QBCore.Shared.Items[item] then
            return QBCore.Shared.Items[item].label
        else
            return item  
        end
    else
        print("Unsupported framework.")
        return item  
    end
end

function RemoveItem(source, item, amount)
    if Framework == 'esx' then 
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then        
            if xPlayer.getInventoryItem(item).count >= amount then
                xPlayer.removeInventoryItem(item, amount)
                return true
            else
                print("Player does not have enough of the item.")
                return false
            end
        else 
            print("Player not found.")
            return false
        end 
    elseif Framework == 'qbcore' then 
        local xPlayer = QBCore.Functions.GetPlayer(source)
        if xPlayer then
                xPlayer.Functions.RemoveItem(item, amount)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items[item], 'remove', amount)
                return true
            else
            print("Player not found.")
            return false
        end 
    else 
        print("Set your framework!")
        return false
    end 
end


