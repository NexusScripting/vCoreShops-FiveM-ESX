if GetCurrentResourceName() ~= "vCore_Shops" then
    print("^1=================================================================")
    print("^1[vCore_Shops] FATAL ERROR: The folder name MUST be 'vCore_Shops'!")
    print("^1[vCore_Shops] Script stopped to prevent NUI errors.")
    print("^1=================================================================^0")
    return
end

ESX = exports["es_extended"]:getSharedObject()

ESX.RegisterServerCallback('mMarket:getPlayerName', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        cb(xPlayer.getName())
    else
        cb("Guest")
    end
end)

RegisterServerEvent('mMarket:checkout')
AddEventHandler('mMarket:checkout', function(cartItems)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local totalPrice = 0
    local canCarryAll = true

    if not xPlayer then return end

    for _, item in pairs(cartItems) do
        local dbItem = nil
        for _, confItem in pairs(Config.Items) do
            if confItem.name == item.name then
                dbItem = confItem
                break
            end
        end

        if dbItem then
            totalPrice = totalPrice + (dbItem.price * item.count)
            if not xPlayer.canCarryItem(item.name, item.count) then
                canCarryAll = false
            end
        end
    end

    if not canCarryAll then
        TriggerClientEvent('esx:showNotification', _source, 'Your pockets are too full!')
        return
    end

    if xPlayer.getMoney() >= totalPrice then
        xPlayer.removeMoney(totalPrice)
        
        for _, item in pairs(cartItems) do
            xPlayer.addInventoryItem(item.name, item.count)
        end
        
        TriggerClientEvent('esx:showNotification', _source, 'Purchase successful! You paid: $' .. totalPrice)
    else
        TriggerClientEvent('esx:showNotification', _source, 'Not enough cash! Required: $' .. totalPrice)
    end
end)