# THIS IS NOT A DRAG AND DROP SCRIPT
This script is used as a tool to create and get data for player groups.
There are no jobs or anything included with these files.

## Exports:

### Client Side
```
-- Returns Client side job stage
exports["devyn-groups"]:GetJobStage()

-- Returns Clients current groupID
exports["devyn-groups"]:GetGroupID()

-- Returns if the Client is the group leader.
exports["devyn-groups"]:IsGroupLeader()
```

### Server Side
```
-- Returns group's leader src
exports["devyn-groups"]:GetGroupLeader(groupID)

-- Returns group's job status.
exports["devyn-groups"]:getJobStatus(groupID)

-- Sets a group job status.
exports["devyn-groups"]:setJobStatus(groupID, status)

-- Gets number of players in a group.
exports["devyn-groups"]:getGroupSize(groupID)

-- Returns player IDs inside a table.
exports["devyn-groups"]:getGroupMembers(groupID)

-- Creates a blip for everyone in a group.
exports["devyn-groups"]:CreateBlipForGroup(groupID, name, label, coords, sprite, color, scale, route)

-- Remove a blip for everyone in a group with the matching blip name.
exports["devyn-groups"]:RemoveBlipForGroup(groupID, name)
```
