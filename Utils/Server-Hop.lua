--fixed i think
local PlaceID = getgenv().placeId
local AllIDs = {}
local foundAnything = ""
local actualHour = os.date("!*t").hour
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game.Players
local jsonFileName = "testing-utility.json"
local lastRequestTime = 0 -- Track last request time to handle rate limit

-- Load existing IDs or create a new file
local function loadIDs()
    print("Loading IDs from file...")
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
end

-- Save IDs to file
local function saveIDs()
    writefile(jsonFileName, HttpService:JSONEncode(AllIDs))
end

-- Clear the file if the hour has changed
local function clearFileIfHourChanged()
    if tonumber(actualHour) ~= tonumber(AllIDs[1]) then
        pcall(function()
            delfile(jsonFileName)
        end)
        AllIDs = {actualHour}
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
    game:GetService("TeleportService"):TeleportCancel()
    TeleportService:TeleportToPlaceInstance(PlaceID, ID, Players.LocalPlayer)
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

    local serverFound = false
    for _, server in ipairs(Site.data) do
        local ID = tostring(server.id)
        print("Checking server ID:", ID, "Players:", server.playing, "/", server.maxPlayers)
        
        if tonumber(server.maxPlayers) > tonumber(server.playing) and not table.find(AllIDs, ID) then
            print("Suitable server found:", ID)
            tryTeleport(ID)
            serverFound = true
            break
        end
    end
end

-- Main teleport loop
local function Teleport()
    while wait() do
        pcall(TPReturner)
    end
end

loadIDs()
Teleport()
