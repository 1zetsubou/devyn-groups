local QBCore = exports['qb-core']:GetCoreObject()

RegisterCommand("group", function()
    openGroupMenu()
end)

function openGroupMenu()
    SendNUIMessage({
        action = "open",
        menu = "main"
    })
    SetNuiFocus(true, true)
end

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('request-group', function()
    local request = promise.new()
    QBCore.Function.TriggerCallback("groups:requestCreateGroup", function(result)
        request:resolve(result)
    end)
    Citizen.Await(request)
    
    if request then 

    else 

    end
end)

RegisterNUICallback('request-join', function()
    
end)