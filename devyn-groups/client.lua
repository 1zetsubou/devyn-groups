local QBCore = exports['qb-core']:GetCoreObject()


function openGroupMenu()
    SendNUIMessage({ action = "open" })
    SetNuiFocus(true, true)
end


RegisterNetEvent("groups:updateJobStage", function(data)

end)

RegisterNetEvent("groups:UpdateGroupData", function(data)
    SendNUIMessage({ 
        action = "update",
        type = "update",
        data = data,
    })
end)

RegisterNetEvent("groups:JoinGroup", function(data)
    SendNUIMessage({ 
        action = "update",
        type = "join",
    })
end)

-- NUI Callbacks

RegisterNUICallback('close', function()
    SetNuiFocus(false, false)
end)

RegisterNUICallback('group-create', function(data, cb)
    local p = promise.new()
    QBCore.Functions.TriggerCallback("groups:requestCreateGroup", function(r)
        p:resolve(r)
    end)
    local d = Citizen.Await(p)
    cb(d)
end)


RegisterNUICallback('getActiveGroups', function(data, cb)
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:getActiveGroups", function(result)
        request:resolve(result)
    end)
    local data = Citizen.Await(request)
    cb(data)
end)

local requestCooldown = false
RegisterNUICallback('request-join', function(data, cb)
    if not requestCooldown then
        local request = promise.new()
        QBCore.Functions.TriggerCallback("groups:requestJoinGroup", function(result)
            request:resolve(result)
        end, data.groupID)
        local data = Citizen.Await(request)
        cb(data)
        requestCooldown = true
        Wait(5000)
        requestCooldown = false
    else 
        QBCore.Functions.Notify("You need to wait before requesting againn", "error")
    end
end)

RegisterNUICallback('view-requests', function(data, cb)
    local request = promise.new()
    QBCore.Functions.TriggerCallback("groups:getGroupRequests", function(result)
        request:resolve(result)
    end, data.groupID)
    local data = Citizen.Await(request)
    cb(data)
end)

RegisterNUICallback('request-accept', function(data)
    TriggerServerEvent("groups:acceptRequest", data.player, data.groupID)
end)

RegisterNUICallback('request-deny', function(data)
    TriggerServerEvent("groups:denyRequest", data.player, data.groupID)
end)

RegisterNUICallback('member-kick', function(data)
    TriggerServerEvent("groups:kickMember", data.player, data.groupID)
end)

RegisterNUICallback('group-leave', function()
    
end)

RegisterNUICallback('group-destroy', function()
    TriggerServerEvent("groups:destroyGroup")
end)


RegisterCommand('group', function()
    openGroupMenu()
end)
RegisterKeyMapping("group", "Open Group Menu", "keyboard", "")
