local QBCore = exports['qb-core']:GetCoreObject()

local GroupLimit = 4
local Groups = {}
local Players = {}

QBCore.Functions.CreateCallback("groups:getActiveGroups", function(source, cb)
    local src = source
    local player = QBCore.Functions.GetPlayer(src)
    cb(Groups)
end)

QBCore.Functions.CreateCallback("groups:requestCreateGroup", function(source, cb)
    local src = source
    if not Players[src] then 
        Players[src] = true
        Groups[#Groups+1] = {members={"leader" = src}, status="WAITING"}
        cb(true)
    else
        print("src already in a group")
        cb(false)
    end
end)

QBCore.Functions.CreateCallback("groups:requestJoinGroup", function(source, cb, groupID)
    local src = source
    if not Players[src] then
        if Groups[groupID] then 
            if #Groups[groupID]["members"] < GroupLimit then
                Groups[groupID]["members"].member = src
                Players[src] = true
            else
                print("group full")
            end
        else 
            print("group doesn't exist")
        end
        cb(true)
    else
        print("src already in a group")
        cb(false)
    end
end)
