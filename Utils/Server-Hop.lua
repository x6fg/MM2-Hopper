-- Script with separate unused server storage
local Placef
    print("Loading IDs from files... (EXPERMINENTAL VERSION)")
    local success, result = pcall(function()
        return HttpService:JSONDecode(readfile(jsonFileName))
    end)
    if success and type(result) == "table" then
        AllIDs = result
        print("Loaded IDs successfully:", AllIDs)
    else
        AllIDs = {actualHour}
        print("No existing ID file found or failed to load, creating new file with current hour:", actualHour)
        writefile(jsonFileName, HttpService:JSONEncode(AllIDs))
    end

    local successUnused, resultUnused = pcall(function()
        return HttpService:JSONDecode(readfile(unusedFileName))
    end)
    if successUnused and type(resultUnused) == "table" then
        UnusedIDs = resultUnused
        print("Loaded unused IDs successfully:", UnusedIDs)
    else
        UnusedIDs = {}
        print("No existing unused server file found or failed to load, creating new file.")
        writefile(unusedFileName, HttpService:JSONEncode(UnusedIDs))
    end
end

-- Save IDs to files
local function saveIDs()
    writefile(jsonFileName, HttpService:JSONEncode(AllIDs))
    writefile(unusedFileName, HttpService:JSONEncode(UnusedIDs))
end

-- Clear the files if the hour has changed
local function clearFileIfHourChanged()
    if tonumber(actualHour) ~= tonumber(AllIDs[1]) then
        pcall(function()
            delfile(jsonFileName)
            delfile(unusedFileName)
        end)
        AllIDs = {actualHour}
        UnusedIDs = {}
        saveIDs()
    end
end

local function fetchServers(cursor)
    local url = 'https://games.roblox.com/v1/games/' .. PlaceID .. '/servers/Public?sortOrder=Desc&excludeFullGames=true&limit=100'
    
    if cursor then
        url = url .. '&cursor=' .. cursor
    end
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet(url))
    end)
    
    if not success then
        return nil
    end
    
    return result
end

local function tryTeleport(ID)
    print("Attempting to teleport to server ID:", ID)
    table.insert(AllIDs, ID)
    saveIDs()
    TeleportService:TeleportToPlaceInstance(PlaceID, ID, Players.LocalPlayer)
end

-- Attempt to use an unused server
local function tryUnusedServers()
    while #UnusedIDs > 0 do
        local ID = table.remove(UnusedIDs, 1)
        print("Trying unused server ID:", ID)
        saveIDs()
        tryTeleport(ID)
        task.wait(4)
    end
end

-- Main function to find and teleport to a suitable server
local function TPReturner()
    local Site = fetchServers(foundAnything)
    
    if not Site then
        return
    end
    
    if Site.nextPageCursor then
        foundAnything = Site.nextPageCursor
        print("Next page cursor set to:", foundAnything)
    end

    clearFileIfHourChanged()

    for _, server in ipairs(Site.data) do
        local ID = tostring(server.id)
        print("Checking server ID:", ID, "Players:", server.playing, "/", server.maxPlayers)
        
        if tonumber(server.maxPlayers) > tonumber(server.playing) then
            if not table.find(AllIDs, ID) then
                print("Suitable server found:", ID)
                tryTeleport(ID)
                task.wait(4)
            else
                print("Server ID already used, adding to unused servers:", ID)
                table.insert(UnusedIDs, ID)
                saveIDs()
            end
        end
    end
end

-- Main teleport loop
local function Teleport()
    while wait() do
        -- Attempt to use unused servers first
        if #UnusedIDs > 0 then
            print("Trying unused servers...")
            tryUnusedServers()
        else
            print("No unused servers left, fetching new servers...")
            pcall(TPReturner)
        end
    end
end

loadIDs()
Teleport()
