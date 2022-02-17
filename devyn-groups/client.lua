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

RegisterNUICallback('group-create', function()
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:requestCreateGroup", function(result)
        request:resolve(result)
    end)

    local data = Citizen.Await(request)

    if data then
        SendNUIMessage({
            action = "group-create",
            groupID =  data.groupID,
            name =  data.name,
        })
    else 
        print("no")
    end
end)

RegisterNUICallback('request-group', function()
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:requestCreateGroup", function(result)
        request:resolve(result)
    end)
    local data = Citizen.Await(request)
    
    if data then 

    else 

    end
end)

RegisterNUICallback('getActiveGroups', function(data, cb)
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:getActiveGroups", function(result)
        request:resolve(result)
    end)
    local data = Citizen.Await(request)
    cb(data)
end)

RegisterNUICallback('request-join', function(data, cb)
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:requestJoinGroup", function(result)
        request:resolve(result)
    end, data.groupID)
    local data = Citizen.Await(request)
    cb(data)
end)

RegisterNUICallback('view-requests', function(data, cb)
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:getGroupRequests", function(result)
        request:resolve(result)
    end, data.groupID)
    local data = Citizen.Await(request)
    cb(data)
end)
