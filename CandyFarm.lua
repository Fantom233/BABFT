if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local InsertService = game:GetService("InsertService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Houses = workspace:FindFirstChild("Houses")

if not Houses then
    StarterGui:SetCore("SendNotification", {
        Title = "Candy Farm",
        Text = "There is no Halloween event, or you may be on a server without the update.",
        Icon = "rbxassetid://7781250539",
        Duration = 4
    })
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

local ReGui = loadstring(game:HttpGet("https://raw.githubusercontent.com/depthso/Dear-ReGui/refs/heads/main/ReGui.lua"))()

ReGui:Init({
    Prefabs = InsertService:LoadLocalAsset("rbxassetid://" .. tostring(ReGui.PrefabsId))
})

local halloweenTheme = {
    TitleAlign = Enum.TextXAlignment.Left,
    TextDisabled = Color3.fromRGB(175, 175, 185),
    Text = Color3.fromRGB(245, 245, 250),
    TabText = Color3.fromRGB(220, 220, 230),
    TabTextActive = Color3.fromRGB(255, 255, 255),
    FrameBg = Color3.fromRGB(26, 22, 34),
    FrameBgTransparency = 0.15,
    FrameBgActive = Color3.fromRGB(52, 40, 68),
    FrameBgTransparencyActive = 0.15,
    CheckMark = Color3.fromRGB(255, 138, 48),
    SliderGrab = Color3.fromRGB(255, 138, 48),
    ButtonsBg = Color3.fromRGB(255, 115, 40),
    CollapsingHeaderBg = Color3.fromRGB(72, 40, 24),
    CollapsingHeaderText = Color3.fromRGB(255, 240, 225),
    RadioButtonHoveredBg = Color3.fromRGB(255, 138, 48),
    WindowBg = Color3.fromRGB(18, 15, 24),
    TitleBarBg = Color3.fromRGB(18, 15, 24),
    TitleBarBgActive = Color3.fromRGB(36, 30, 48),
    Border = Color3.fromRGB(72, 40, 24),
    ResizeGrab = Color3.fromRGB(72, 40, 24),
    RegionBgTransparency = 1,
    TabBg = Color3.fromRGB(255, 100, 40),
    TabBgActive = Color3.fromRGB(255, 140, 60),
}

local mainWindow = ReGui:TabsWindow({
    Title = "Candy Farm - Halloween 2025",
    Size = UDim2.fromOffset(440, 560),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    NoClose = true,
})

ReGui:DefineTheme("halloween", halloweenTheme)
mainWindow:SetTheme("halloween")

local farmTab = mainWindow:CreateTab({ Name = "Farm" })
local autoTab = mainWindow:CreateTab({ Name = "Auto Farm" })
local infoTab = mainWindow:CreateTab({ Name = "Info" })
local creditsTab = mainWindow:CreateTab({ Name = "Credits" })

local isScriptActive = true
local isFarming = false
local isHidingPopups = true
local isAntiAfkEnabled = true
local antiAfkConnection = nil
local housesAddedConnection = nil
local forcedPartConnections = {}
local totalHousesClaimed = 0
local elapsedSeconds = 0

local function formatElapsedTime(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

local function enableAntiAfk()
    if antiAfkConnection then
        return
    end
    antiAfkConnection = LocalPlayer.Idled:Connect(function()
        if isAntiAfkEnabled then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end
    end)
end

local function disableAntiAfk()
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
end

local function forceDoorIntoPlayer(doorPart, walkSpeed)
    if forcedPartConnections[doorPart] then
        return
    end
    forcedPartConnections[doorPart] = RunService.Heartbeat:Connect(function()
        if not isFarming or not doorPart or not doorPart.Parent then
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

housesAddedConnection = Houses.ChildAdded:Connect(function()
    if not isFarming then
        return
    end
    task.wait(0.3)
    performAutoFarm()
end)

local function setItemGainedScriptEnabled(isEnabled)
    local itemGainedGui = PlayerGui:FindFirstChild("ItemGained")
    if not itemGainedGui then
        return
    end
    local displayGainedItem = itemGainedGui:FindFirstChild("DisplayGainedItem")
    if not displayGainedItem then
        return
    end
    local itemLocalScript = displayGainedItem:FindFirstChild("LocalScript")
    if not itemLocalScript then
        return
    end
    itemLocalScript.Disabled = not isEnabled
end

task.spawn(function()
    while isScriptActive do
        if isHidingPopups then
            StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            setItemGainedScriptEnabled(false)
        else
            setItemGainedScriptEnabled(true)
        end
        task.wait(0.1)
    end
end)

local timeElapsedLabel
local totalHousesLabel
local fakeHousesLabel
local totalCandyLabel
local blueCandyLabel
local yellowCandyLabel
local purpleCandyLabel

task.spawn(function()
    while isScriptActive do
        if isFarming then
            elapsedSeconds = elapsedSeconds + 1
            if timeElapsedLabel then
                timeElapsedLabel.Text = "Time Elapsed: " .. formatElapsedTime(elapsedSeconds)
            end
            local currentBlue = getDataValue("CandyBlue")
            local currentYellow = getDataValue("CandyOrange")
            local currentPurple = getDataValue("CandyPurple")
            local blueGained = currentBlue - initialBlueCandy
            local yellowGained = currentYellow - initialYellowCandy
            local purpleGained = currentPurple - initialPurpleCandy
            local totalGained = blueGained + yellowGained + purpleGained
            local fakeHouses = totalHousesClaimed - totalGained
            if totalHousesLabel then
                totalHousesLabel.Text = string.format("Total Houses: %d", totalHousesClaimed)
            end
            if fakeHousesLabel then
                fakeHousesLabel.Text = string.format("Fake Houses: %d", fakeHouses)
            end
            if totalCandyLabel then
                totalCandyLabel.Text = string.format("Total Candy: %d", totalGained)
            end
            if blueCandyLabel then
                blueCandyLabel.Text = string.format("Blue Candy: %d", blueGained)
            end
            if yellowCandyLabel then
                yellowCandyLabel.Text = string.format("Yellow Candy: %d", yellowGained)
            end
            if purpleCandyLabel then
                purpleCandyLabel.Text = string.format("Purple Candy: %d", purpleGained)
            end
        end
        task.wait(1)
    end
end)

farmTab:Separator({ Text = "Candy Farm - This Server Only" })

farmTab:Checkbox({
    Label = "Anti-AFK",
    Value = true,
    Callback = function(_, value)
        isAntiAfkEnabled = value
        if value then
            enableAntiAfk()
        else
            disableAntiAfk()
        end
    end,
})

farmTab:Checkbox({
    Label = "Hide Reward Popups",
    Value = true,
    Callback = function(_, value)
        isHidingPopups = value
    end,
})

farmTab:Button({
    Text = "Start Candy Farm",
    Size = UDim2.new(1, 0, 0, 42),
    NoTheme = true,
    BackgroundColor3 = Color3.fromRGB(255, 115, 40),
    Callback = function(self)
        if not isFarming then
            isFarming = true
            self.Text = "Stop Candy Farm"
            self.BackgroundColor3 = Color3.fromRGB(235, 55, 55)
            performAutoFarm()
        else
            isFarming = false
            self.Text = "Start Candy Farm"
            self.BackgroundColor3 = Color3.fromRGB(255, 115, 40)
        end
    end,
})

farmTab:Separator({ Text = "Statistics" })

timeElapsedLabel = farmTab:Label({
    Text = "Time Elapsed: 00:00:00",
})

totalHousesLabel = farmTab:Label({
    Text = "Total Houses: 0",
})

fakeHousesLabel = farmTab:Label({
    Text = "Fake Houses: 0",
})

totalCandyLabel = farmTab:Label({
    Text = "Total Candy: 0",
})

blueCandyLabel = farmTab:Label({
    Text = "Blue Candy: 0",
})

yellowCandyLabel = farmTab:Label({
    Text = "Yellow Candy: 0",
})

purpleCandyLabel = farmTab:Label({
    Text = "Purple Candy: 0",
})

autoTab:Separator({ Text = "Candy Farm with Server Hop" })

autoTab:Button({
    Text = "Start Auto Farm",
    Size = UDim2.new(1, 0, 0, 42),
    NoTheme = true,
    BackgroundColor3 = Color3.fromRGB(255, 115, 40),
    Callback = function(self)
        self.Text = "Starting..."
        self.BackgroundColor3 = Color3.fromRGB(120, 200, 100)
        performAutoFarm()
        local loadSuccess = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/LoopCandyFarm.lua"))()
        end)
        if not loadSuccess then
            self.Text = "Failed to load. Retry."
            self.BackgroundColor3 = Color3.fromRGB(235, 55, 55)
            task.wait(2)
            self.Text = "Start Auto Farm"
            self.BackgroundColor3 = Color3.fromRGB(255, 115, 40)
            return
        end
        self.Text = "Started!"
        self.BackgroundColor3 = Color3.fromRGB(120, 200, 100)
    end,
})

autoTab:Separator({ Text = "Important Information" })

autoTab:Label({
    TextWrapped = true,
    RichText = true,
    Text = "This method claims houses and then changes to a different server. It is the most efficient way to farm candy, but <b>not all executors support it</b>. If you want to play BABFT while farming candy, use Method 1.\n\nOnce started, the only way to stop it is to <b>close Roblox</b>. The interface will not appear in the next server, <b>but it will continue to farm.</b>",
})

infoTab:Separator({ Text = "How to Use" })

infoTab:Label({
    TextWrapped = true,
    RichText = true,
    Text = "<b>DO NOT toggle 'Hide Reward Popups'</b> while auto farming. <b>Enable it only when there is no reward card on your screen.</b>",
})

infoTab:Label({
    TextWrapped = true,
    RichText = true,
    TextColor3 = Color3.fromRGB(255, 140, 60),
    Text = "<b>You can do other things at the same time as farming candy.</b>",
})

infoTab:Separator({ Text = "About This Script" })

infoTab:Label({
    TextWrapped = true,
    Text = "This script is free, keyless, and open source.",
})

creditsTab:Separator({ Text = "Author" })

creditsTab:Label({ Text = "Asu - @thereal_asu" })

creditsTab:Separator({ Text = "Library" })

creditsTab:Label({ Text = "Dear ReGui by depthso" })

creditsTab:Separator({ Text = "Actions" })

creditsTab:Button({
    Text = "Join Discord",
    Size = UDim2.fromScale(1, 0),
    NoTheme = true,
    BackgroundColor3 = Color3.fromRGB(255, 130, 40),
    Callback = function()
        setclipboard("https://discord.gg/eyUFHKV2cM")
        local httpRequest = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request
        if not httpRequest then
            return
        end
        pcall(function()
            httpRequest({
                Url = "http://127.0.0.1:6463/rpc?v=1",
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json",
                    Origin = "https://discord.com"
                },
                Body = HttpService:JSONEncode({
                    cmd = "INVITE_BROWSER",
                    nonce = HttpService:GenerateGUID(false),
                    args = { code = "eyUFHKV2cM" }
                })
            })
        end)
    end,
})

creditsTab:Button({
    Text = "Server Hop",
    Size = UDim2.fromScale(1, 0),
    NoTheme = true,
    BackgroundColor3 = Color3.fromRGB(255, 100, 40),
    Callback = function()
        task.wait(0.2)
        local httpRequest = (syn and syn.request) or (fluxus and fluxus.request) or (http and http.request) or http_request or request
        if not httpRequest then
            return
        end
        local currentJobId = game.JobId
        local currentPlaceId = game.PlaceId
        local response = httpRequest({
            Url = string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true", currentPlaceId)
        })
        if not response or not response.Body then
            return
        end
        local body = HttpService:JSONDecode(response.Body)
        if not body or not body.data then
            return
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
        if #availableServers == 0 then
            return
        end
        local queueFunction = queue_on_teleport or (syn and syn.queue_on_teleport) or (fluxus and fluxus.queue_on_teleport) or queueonteleport
        if queueFunction then
            queueFunction("loadstring(game:HttpGet('https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/CandyFarm.lua'))()")
        end
        TeleportService:TeleportToPlaceInstance(currentPlaceId, availableServers[math.random(1, #availableServers)], LocalPlayer)
    end,
})

creditsTab:Button({
    Text = "Unload Script",
    Size = UDim2.fromScale(1, 0),
    NoTheme = true,
    BackgroundColor3 = Color3.fromRGB(235, 55, 55),
    Callback = function()
        isScriptActive = false
        isFarming = false
        disableAntiAfk()
        if housesAddedConnection then
            housesAddedConnection:Disconnect()
            housesAddedConnection = nil
        end
        for part, connection in pairs(forcedPartConnections) do
            connection:Disconnect()
            forcedPartConnections[part] = nil
        end
        mainWindow:Remove()
    end,
})

enableAntiAfk()
