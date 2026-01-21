if GetCurrentResourceName() ~= "vCore_Shops" then
    print("^1=================================================================")
    print("^1[vCore_Shops] FATAL ERROR: The folder name MUST be 'vCore_Shops'!")
    print("^1[vCore_Shops] Current name: " .. GetCurrentResourceName())
    print("^1[vCore_Shops] Please rename the folder.")
    print("^1=================================================================^0")
    return
end

ESX = exports["es_extended"]:getSharedObject()
local isShopOpen = false

function OpenShop(shopType)
    if isShopOpen then return end
    
    local shopConfig = Config.ShopTypes[shopType]
    
    ESX.TriggerServerCallback('mMarket:getPlayerName', function(playerName)
        SetNuiFocus(true, true)
        
        SendNUIMessage({
            action = 'openShop',
            items = Config.Items,
            currency = Config.Currency,
            username = playerName,
            shopLabel = shopConfig.label,
            allowedCategories = shopConfig.categories
        })
        
        isShopOpen = true
    end)
end

RegisterNUICallback('close', function(data, cb)
    SetNuiFocus(false, false)
    isShopOpen = false
    cb('ok')
end)

RegisterNUICallback('checkout', function(data, cb)
    TriggerServerEvent('mMarket:checkout', data.cart)
    cb('ok')
end)

Citizen.CreateThread(function()
    while true do
        local sleep = 1500 
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)

        for k, locData in pairs(Config.ShopLocations) do
            local dist = #(coords - locData.pos)
            
            if dist < 20.0 then
                sleep = 0
                DrawMarker(21, locData.pos.x, locData.pos.y, locData.pos.z + 0.3, 0,0,0, 0,180.0,0, 0.6, 0.6, 0.6, 46, 213, 115, 150, false, true, 2, false, nil, nil, false)
                
                if dist < 1.5 then
                    local label = Config.ShopTypes[locData.type].label
                    ESX.ShowHelpNotification("Press ~INPUT_CONTEXT~ to open ~g~" .. label .. "~s~")
                    
                    if IsControlJustReleased(0, 38) then
                        OpenShop(locData.type)
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(100) 
    for _, locData in pairs(Config.ShopLocations) do
        local configType = Config.ShopTypes[locData.type]
        if configType then
            local blip = AddBlipForCoord(locData.pos)
            SetBlipSprite(blip, configType.blip.sprite)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, configType.blip.scale)
            SetBlipColour(blip, configType.blip.color)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(configType.label)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

RegisterCommand('fixui', function()
    SetNuiFocus(false, false)
    isShopOpen = false
    SendNUIMessage({ action = 'closeShop' })
end)