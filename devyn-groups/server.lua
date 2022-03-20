local QBCore = exports['qb-core']:GetCoreObject()

local GroupLimit = 4
local Groups = {}
local Players = {}
local Requests = {}


QBCore.Functions.CreateCallback("groups:requestCreateGroup", function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    if not Players[src] then 
        Players[src] = true
        Groups[#Groups+1] = {
            status="WAITING", 
            members={
                leader = src,
                helpers= {},
            }
        }
        cb({ groupID = #Groups, name = getPlayerName(src), id = src })
    else
        TriggerClientEvent("QBCore:Notify", src, "You are already in a group", "error")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("groups:getActiveGroups", function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    local temp = {}
    for k,v in pairs(Groups) do
        table.insert(temp, {name = getPlayerName(v["members"]["leader"]), id = k})
    end
    cb(temp)
end)

QBCore.Functions.CreateCallback("groups:getGroupRequests", function(source, cb, groupID)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)

    local temp = {}
    if Requests[groupID] then 
        for k,v in pairs(Requests[groupID]) do
            table.insert(temp, {name = getPlayerName(v), id = v})
        end
        cb(temp)
    else 
        cb(temp)
    end
end)

QBCore.Functions.CreateCallback("groups:requestJoinGroup", function(source, cb, groupID)
    local src = source
    if not Players[src] then
        if Groups[groupID] then 
            if #Groups[groupID]["members"] < GroupLimit then
                if Requests[groupID] == nil then 
                    Requests[groupID] = {}
                end
                table.insert(Requests[groupID], src)
                cb(true)
            else
                TriggerClientEvent("QBCore:Notify", src, "The group is full", "error")
            end
        else 
            TriggerClientEvent("QBCore:Notify", src, "That group doesn't exist", "error")
        end
        cb(true)
    else
        TriggerClientEvent("QBCore:Notify", src, "You already have a request pending", "error")
        cb(false)
    end
end)

RegisterNetEvent("groups:acceptRequest", function(player, groupID)
    local src = source
    if AddPlayerToGroup(player, groupID) then
        for k,v in pairs(Requests[groupID]) do
            if v == player then
                Requests[groupID][k] = nil
            end
        end
        TriggerClientEvent("QBCore:Notify", player, "Your group join request was accepted", "success")
        TriggerClientEvent("groups:JoinGroup", player, groupID)
    end
end)

RegisterNetEvent("groups:denyRequest", function(player, groupID)
    local src = source
    for k,v in pairs(Requests[groupID]) do
        if v == player then
            Requests[groupID][k] = nil
        end
    end
    TriggerClientEvent("QBCore:Notify", player, "Your group join request was denied", "error")
end)

RegisterNetEvent("groups:kickMember", function(player, groupID)
    RemovePlayerFromGroup(player, groupID)
    TriggerClientEvent("QBCore:Notify", player, "You were removed from the group", "error")
end)

QBCore.Functions.CreateCallback("groups:getGroupMembers", function(source, cb, groupID)
    local src = source
    local temp = {}
    local members = getGroupMembers(groupID)
    for i=1, #members do 
        temp[#temp+1] = {id = members[i], name = getPlayerName(members[i])}
    end
    cb(temp)
end)

RegisterServerEvent("groups:leaveGroup", function(groupID)
    local src = source
    RemovePlayerFromGroup(src, groupID)
end)

RegisterServerEvent("groups:destroyGroup", function()
    local src = source
    local g = findGroupByMember(src)
    
    if g > 0 then
        local m = getGroupMembers(g)
        removeGroupMembers(g)
        for i=1, #m do 
            TriggerClientEvent("groups:groupUpdate", m[i])
        end
        Groups[g] = nil
    else 
        print("Unable to destory group as it doesn't exist.")
    end
end)

function AddPlayerToGroup(player, groupID)
    if not Players[player] then 
        if Groups[groupID] then
            Players[player] = true
            local g = Groups[groupID]["members"]["helpers"]
            g[#g+1] = player
            UpdateGroupData(groupID)
            return true
        else
            print("Group doesn't exist")
        end
    else
        print("Player is already in a group")
    end
    return false
end

function RemovePlayerFromGroup(player, groupID)
    if Players[player] then 
        if Groups[groupID] then
            local g = Groups[groupID]["members"]["helpers"]
            for k,v in pairs(g) do 
                if v == player then
                    Groups[groupID]["members"]["helpers"][k] = nil
                    Players[player] = nil
                end
            end
            TriggerClientEvent("QBCore:Notify", player, "You have left the group", "primary")
            UpdateGroupData(groupID)
        end 
    end
end

function UpdateGroupData(groupID)
    local members = getGroupMembers(groupID)
    local temp = {}
    for i=1, #members do
        temp[#temp+1] = {id = members[i], name = getPlayerName(members[i])}
    end

    for i=1, #members do
        TriggerClientEvent("groups:UpdateGroupData", members[i], temp)
    end
end


function getPlayerName(src)
    local player = QBCore.Functions.GetPlayer(src)
    return player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname
end

function isGroupLeader(src)

end

function removeGroupMembers(groupID)
    local g = Groups[groupID]
    for i=1, #g["members"]["helpers"] do 
        Players[g["members"]["helpers"][i]] = nil
        Groups[groupID]["members"]["helpers"][i] = nil
    end
    Players[g["members"]["leader"]] = nil
end


function findGroupByMember(src)
    if Players[src] then 
        for group, data in pairs(Groups) do 
            local members = data["members"]
            if members["leader"] == src then 
                return group
            else
                for i=1, #members["helpers"] do 
                    if members["helpers"][i] == src then 
                        return group
                    end
                end
                return 0
            end
        end
    else
        return 0
    end
end

function getJobStatus(groupID)
    return Groups[groupID]["status"]
end
exports('getJobStatus', getJobStatus)

function setJobStatus(groupID, status)
    Groups[groupID]["status"] = status
end
exports('setJobStatus', setJobStatus)

function getGroupSize(groupID)
    return #Groups[groupID]["members"]["helpers"] + 1
end
exports('getGroupSize', getGroupSize)

function getGroupMembers(groupID)
    local temp = {}
    temp[#temp+1] = Groups[groupID]["members"]["leader"]
    for k,v in pairs(Groups[groupID]["members"]["helpers"]) do
        temp[#temp+1] = v
    end
    return temp    
end
exports('getGroupMembers', getGroupMembers)
