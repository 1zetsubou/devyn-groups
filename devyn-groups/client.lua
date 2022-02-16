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