if Framework == 'esx' then ESX = exports["es_extended"]:getSharedObject() else QBCore = exports['qb-core']:GetCoreObject() end

function logDiscord(title, message, color)
    local data = { username = "vhs-npcdrugsales",  avatar_url = "https://i.imgur.com/E2Z3mDO.png", embeds = { { ["color"] = color, ["title"] = title, ["description"] = message, ["footer"] = { ["text"] = "Installation Support - [ESX, QBCore, Qbox] -  https://discord.gg/CBSSMpmqrK" },} } } PerformHttpRequest(WebhookConfig.URL, function(err, text, headers) end, 'POST', json.encode(data), {['Content-Type'] = 'application/json'})
end

lib.callback.register('vhs-drugs:sellPed', function(source, Type)
    local src = source
    local sell = Sell[Type]
    local sellableItems = {}
    if not sell then print('Invalid Type') return end
    for item, data in pairs(sell.prices) do
        local itemCount = GetInventoryItem(src, item)
        if itemCount.count > 0 then
            local randomSellAmount = math.random(1, 3)
            local sellAmount = math.min(randomSellAmount, itemCount.count)
            table.insert(sellableItems, {name = item, price = data.price, sellAmount = sellAmount, playerCount = itemCount.count})
        end
    end
    if #sellableItems > 0 then
        if math.random(100) <= refuseSale then
            Notify('info', 'Sale refused. Try again.', '', src)
            if math.random(100) <= policeAlert then
                AlertPolice(src)
            end
            return
        end
        local selectedItem = sellableItems[math.random(#sellableItems)]
        RemoveItem(src, selectedItem.name, selectedItem.sellAmount)
        local totalPrice = selectedItem.price * selectedItem.sellAmount
        addBlack(src, totalPrice)
        Notify('info', 'Drugs Sold', "You sold " .. selectedItem.sellAmount .. " of " .. GetItemLabel(selectedItem.name) .. " for $" .. totalPrice, src)
        logDiscord('Drugs Sold', getName(src).. ' sold ' .. selectedItem.sellAmount .. " of " .. GetItemLabel(selectedItem.name) .. " for $" .. totalPrice, 3000)
    else
        Notify('info', 'Nothing to sell', '', src)
    end
end)

function AlertPolice(src)
    local playerPed = GetPlayerPed(src)
    local playerCoords = GetEntityCoords(playerPed)
    local policePlayers = getPolice() 
    for i = 1, #policePlayers do
        local playerId = policePlayers[i]
        Notify('info', 'Drug Sale Alert', "A suspicious activity has been reported!", playerId)
        TriggerClientEvent('vhs-drugs:policeBlip', playerId, playerCoords)
    end
end



