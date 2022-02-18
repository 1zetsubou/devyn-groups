local QBCore = exports['qb-core']:GetCoreObject()

local GroupLimit = 4
local Groups = {}
local Players = {}
local Requests = {}

local GroupTemp = {
    {
        status = "WAITING",
        members = {
            leader = 1,
            helpers = {3, 17, 50},
        }
    }
}

local RequestsTemp = {
    groupID = {
        player,
        player,
        player,
    }
}

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
    for k,v in pairs(Requests[groupID]) do
        table.insert(temp, {name = getPlayerName(v), id = v})
    end
    cb(temp)
end)

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
        cb({groupID = #Groups, name = player.PlayerData.charinfo.firstname})
    else
        print("src already in a group")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("groups:requestJoinGroup", function(source, cb, groupID)
    local src = source
    if not Players[src] and not Requests[groupID] then
        if Groups[groupID] then 
            if #Groups[groupID]["members"] < GroupLimit then
                if Requests[groupID] == nil then 
                    Requests[groupID] = {}
                end
                table.insert(Requests[groupID], src)
                cb(true)
            else
                print("group full")
            end
        else 
            print("group doesn't exist")
        end
        cb(true)
    else
        print("In Group or Request Pending")
        cb(false)
    end
end)

function getPlayerName(src)
    local player = QBCore.Functions.GetPlayer(src)
    return player.PlayerData.charinfo.firstname.." "..player.PlayerData.charinfo.lastname
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
    temp[#temp+1] = Groups[groupID]["leader"]
    for k,v in pairs(Groups[groupID]["members"]["helpers"]) do
        temp[#temp+1] = v
    end
    return temp    
end
exports('getGroupMembers', getGroupMembers)