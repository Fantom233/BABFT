if not game:IsLoaded() then
    game.Loaded:Wait()
end

if getgenv().CANDY_LOOP_ACTIVE == true then
    return
end

getgenv().CANDY_LOOP_ACTIVE = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer

local Houses = workspace:WaitForChild("Houses", 30)

if not Houses then
    return
end

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local currentHumanoid = currentCharacter:WaitForChild("Humanoid")
local currentRootPart = currentCharacter:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    currentCharacter = newCharacter
    currentHumanoid = newCharacter:WaitForChild("Humanoid")
    currentRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local function getDataValue(dataName)
    local playerData = LocalPlayer:FindFirstChild("Data")
    if not playerData then
        return 0
    end
    local dataValue = playerData:FindFirstChild(dataName)
    if not dataValue then
        return 0
    end
    return dataValue.Value
end

local initialBlueCandy = getDataValue("CandyBlue")
local initialYellowCandy = getDataValue("CandyOrange")
local initialPurpleCandy = getDataValue("CandyPurple")

local forcedPartConnections = {}
local totalHousesClaimed = 0

local function forceDoorIntoPlayer(doorPart, walkSpeed)
    if forcedPartConnections[doorPart] then
        return
    end
    forcedPartConnections[doorPart] = RunService.Heartbeat:Connect(function()
        if not doorPart or not doorPart.Parent then
            if forcedPartConnections[doorPart] then
                forcedPartConnections[doorPart]:Disconnect()
                forcedPartConnections[doorPart] = nil
            end
            return
        end
        doorPart.CFrame = currentRootPart.CFrame
        doorPart.Size = Vector3.new(10, 10, 10)
        doorPart.CanCollide = false
        doorPart.Transparency = 1
        if walkSpeed ~= 0 then
            currentHumanoid.WalkSpeed = walkSpeed
        end
    end)
end

local function performAutoFarm()
    local savedWalkSpeed = currentHumanoid.WalkSpeed
    local allDescendants = Houses:GetDescendants()
    for _, descendant in ipairs(allDescendants) do
        if descendant.Name == "DoorInnerTouch" and descendant:IsA("BasePart") then
            if not descendant:GetAttribute("Forced") then
                totalHousesClaimed = totalHousesClaimed + 1
                forceDoorIntoPlayer(descendant, savedWalkSpeed)
                descendant:SetAttribute("Forced", true)
            end
        end
    end
    for _, descendant in ipairs(allDescendants) do
        if descendant.Name == "GiantHand" then
            descendant:Destroy()
        end
    end
end

performAutoFarm()

StarterGui:SetCore("SendNotification", {
    Title = "Candy Farm",
    Text = string.format("Claiming %d houses...", totalHousesClaimed),
    Icon = "rbxassetid://7781284023",
    Duration = 4
})

task.wait(0.2)

if totalHousesClaimed ~= 0 then
    local timeoutSeconds = 10
    local startTime = tick()
    repeat
        task.wait()
    until getDataValue("CandyBlue") ~= initialBlueCandy
        or getDataValue("CandyOrange") ~= initialYellowCandy
        or getDataValue("CandyPurple") ~= initialPurpleCandy
        or (tick() - startTime) >= timeoutSeconds
    if (tick() - startTime) >= timeoutSeconds then
        StarterGui:SetCore("SendNotification", {
            Title = "Candy Farm",
            Text = "Something went wrong. Attempting server hop anyway...",
            Icon = "rbxassetid://7781288646",
            Duration = 3
        })
    end
end

task.wait(2)

StarterGui:SetCore("SendNotification", {
    Title = "Candy Farm",
    Text = "Server hopping...",
    Icon = "rbxassetid://7781288646",
    Duration = 3
})

local currentJobId = game.JobId
local currentPlaceId = game.PlaceId

local function getHttpRequest()
    return request or http_request or (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request)
end

local function getQueueOnTeleport()
    return queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
end

local function findAvailableServers()
    local httpRequest = getHttpRequest()
    if not httpRequest then
        return {}
    end
    local response = httpRequest({
        Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", currentPlaceId)
    })
    if not response or not response.Body then
        return {}
    end
    local body = HttpService:JSONDecode(response.Body)
    if not body or not body.data then
        return {}
    end
    local availableServers = {}
    for _, serverInfo in next, body.data do
        if type(serverInfo) ~= "table" then
            continue
        end
        local playing = tonumber(serverInfo.playing)
        local maxPlayers = tonumber(serverInfo.maxPlayers)
        if not playing or not maxPlayers then
            continue
        end
        if playing >= maxPlayers then
            continue
        end
        if serverInfo.id == currentJobId then
            continue
        end
        table.insert(availableServers, 1, serverInfo.id)
    end
    return availableServers
end

local function serverHop()
    local availableServers = findAvailableServers()
    if #availableServers == 0 then
        StarterGui:SetCore("SendNotification", {
            Title = "Candy Farm",
            Text = "No available servers found. Retrying in 5 seconds...",
            Icon = "rbxassetid://7781250539",
            Duration = 4
        })
        task.wait(5)
        serverHop()
        return
    end
    local queueFunction = getQueueOnTeleport()
    if queueFunction then
        queueFunction("loadstring(game:HttpGet('https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/LoopCandyFarm.lua'))()")
    end
    local teleportSuccess = pcall(function()
        TeleportService:TeleportToPlaceInstance(currentPlaceId, availableServers[math.random(1, #availableServers)], LocalPlayer)
    end)
    if not teleportSuccess then
        StarterGui:SetCore("SendNotification", {
            Title = "Candy Farm",
            Text = "Failed to teleport. Retrying in 5 seconds...",
            Icon = "rbxassetid://7781250539",
            Duration = 4
        })
        task.wait(5)
        serverHop()
    end
end

TeleportService.TeleportInitFailed:Connect(function(failedPlayer, errorMessage)
    if failedPlayer ~= LocalPlayer then
        return
    end
    StarterGui:SetCore("SendNotification", {
        Title = "Candy Farm",
        Text = "Server full or unavailable. Retrying in 5 seconds...",
        Icon = "rbxassetid://7781250539",
        Duration = 4
    })
    task.wait(5)
    serverHop()
end)

serverHop()
