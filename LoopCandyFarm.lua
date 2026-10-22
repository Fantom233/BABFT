if not game:IsLoaded() then
    game.Loaded:Wait()
end

if getgenv().CANDY_LOOP_ACTIVE == true then
    return
end

getgenv().CANDY_LOOP_ACTIVE = true

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Theme = {
    NotifBg = Color3.fromRGB(32, 26, 42),
    NotifBorder = Color3.fromRGB(58, 47, 78),
    Text = Color3.fromRGB(240, 238, 245),
    TextMuted = Color3.fromRGB(150, 145, 168),
    SeparatorLine = Color3.fromRGB(55, 45, 72),
    AccentPrimary = Color3.fromRGB(255, 125, 40),
    AccentSuccess = Color3.fromRGB(90, 200, 110),
    AccentDanger = Color3.fromRGB(230, 65, 65),
}

local function Tween(instance, duration, goals, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    local tween = TweenService:Create(instance, tweenInfo, goals)
    tween:Play()
    return tween
end

local NotificationGui = Instance.new("ScreenGui")
NotificationGui.Name = "CandyFarmLoopNotifications"
NotificationGui.ResetOnSpawn = false
NotificationGui.IgnoreGuiInset = true
NotificationGui.DisplayOrder = 999
NotificationGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotificationGui.Parent = PlayerGui

local NotificationContainer = Instance.new("Frame")
NotificationContainer.Name = "Container"
NotificationContainer.Size = UDim2.new(0, 340, 1, -20)
NotificationContainer.Position = UDim2.new(1, -355, 0, 10)
NotificationContainer.BackgroundTransparency = 1
NotificationContainer.Parent = NotificationGui

local NotificationLayout = Instance.new("UIListLayout")
NotificationLayout.Padding = UDim.new(0, 8)
NotificationLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotificationLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotificationLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotificationLayout.Parent = NotificationContainer

local notificationCounter = 0

local function ShowNotification(title, message, notificationType, duration)
    notificationCounter = notificationCounter + 1
    local currentOrder = notificationCounter
    local accentColor = Theme.AccentPrimary
    if notificationType == "success" then
        accentColor = Theme.AccentSuccess
    elseif notificationType == "error" then
        accentColor = Theme.AccentDanger
    end

    local notificationFrame = Instance.new("Frame")
    notificationFrame.Name = "Notification_" .. tostring(currentOrder)
    notificationFrame.Size = UDim2.new(1, 0, 0, 76)
    notificationFrame.Position = UDim2.new(1.5, 0, 0, 0)
    notificationFrame.BackgroundColor3 = Theme.NotifBg
    notificationFrame.BackgroundTransparency = 0.3
    notificationFrame.BorderSizePixel = 0
    notificationFrame.LayoutOrder = -currentOrder
    notificationFrame.Parent = NotificationContainer

    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 10)
    notificationCorner.Parent = notificationFrame

    local notificationStroke = Instance.new("UIStroke")
    notificationStroke.Color = Theme.NotifBorder
    notificationStroke.Thickness = 1
    notificationStroke.Transparency = 0.3
    notificationStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    notificationStroke.Parent = notificationFrame

    local accentBar = Instance.new("Frame")
    accentBar.Name = "Accent"
    accentBar.Size = UDim2.new(0, 4, 1, -14)
    accentBar.Position = UDim2.new(0, 6, 0, 7)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = notificationFrame

    local accentBarCorner = Instance.new("UICorner")
    accentBarCorner.CornerRadius = UDim.new(0, 2)
    accentBarCorner.Parent = accentBar

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Size = UDim2.new(1, -30, 0, 22)
    titleLabel.Position = UDim2.new(0, 18, 0, 10)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextColor3 = Theme.Text
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Text = title
    titleLabel.Parent = notificationFrame

    local messageLabel = Instance.new("TextLabel")
    messageLabel.Name = "Message"
    messageLabel.Size = UDim2.new(1, -30, 1, -46)
    messageLabel.Position = UDim2.new(0, 18, 0, 34)
    messageLabel.BackgroundTransparency = 1
    messageLabel.Font = Enum.Font.GothamMedium
    messageLabel.TextSize = 12
    messageLabel.TextColor3 = Theme.TextMuted
    messageLabel.TextXAlignment = Enum.TextXAlignment.Left
    messageLabel.TextYAlignment = Enum.TextYAlignment.Top
    messageLabel.TextWrapped = true
    messageLabel.Text = message
    messageLabel.Parent = notificationFrame

    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "ProgressTrack"
    progressTrack.Size = UDim2.new(1, -24, 0, 2)
    progressTrack.Position = UDim2.new(0, 12, 1, -6)
    progressTrack.BackgroundColor3 = Theme.SeparatorLine
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = notificationFrame

    local progressTrackCorner = Instance.new("UICorner")
    progressTrackCorner.CornerRadius = UDim.new(0, 1)
    progressTrackCorner.Parent = progressTrack

    local progressBar = Instance.new("Frame")
    progressBar.Name = "ProgressBar"
    progressBar.Size = UDim2.new(1, 0, 1, 0)
    progressBar.BackgroundColor3 = accentColor
    progressBar.BorderSizePixel = 0
    progressBar.Parent = progressTrack

    local progressBarCorner = Instance.new("UICorner")
    progressBarCorner.CornerRadius = UDim.new(0, 1)
    progressBarCorner.Parent = progressBar

    Tween(notificationFrame, 0.3, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    Tween(progressBar, duration, {
        Size = UDim2.new(0, 0, 1, 0),
    }, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    task.delay(duration, function()
        if not notificationFrame or not notificationFrame.Parent then
            return
        end
        Tween(notificationFrame, 0.25, {
            Position = UDim2.new(1.5, 0, 0, 0),
            BackgroundTransparency = 0.3,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        for _, descendant in pairs(notificationFrame:GetDescendants()) do
            if descendant:IsA("TextLabel") then
                Tween(descendant, 0.2, {
                    TextTransparency = 1,
                })
            end
        end
        task.delay(0.3, function()
            if notificationFrame and notificationFrame.Parent then
                notificationFrame:Destroy()
            end
        end)
    end)
end

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

local candyDataNames = {
    { key = "blue", dataName = "CandyBlue" },
    { key = "yellow", dataName = "CandyOrange" },
    { key = "purple", dataName = "CandyPurple" },
    { key = "pink", dataName = "CandyPink" },
    { key = "red", dataName = "CandyRed" },
}

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

local initialCandyValues = {}
for _, candyInfo in ipairs(candyDataNames) do
    initialCandyValues[candyInfo.key] = getDataValue(candyInfo.dataName)
end

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

ShowNotification(
    "Candy Farm",
    string.format("Claiming %d houses...", totalHousesClaimed),
    "info",
    4
)

task.wait(0.2)

if totalHousesClaimed ~= 0 then
    local timeoutSeconds = 10
    local startTime = tick()
    repeat
        task.wait()
        local anyCandyChanged = false
        for _, candyInfo in ipairs(candyDataNames) do
            if getDataValue(candyInfo.dataName) ~= initialCandyValues[candyInfo.key] then
                anyCandyChanged = true
                break
            end
        end
    until anyCandyChanged or (tick() - startTime) >= timeoutSeconds
    if (tick() - startTime) >= timeoutSeconds then
        ShowNotification(
            "Candy Farm",
            "Something went wrong. Attempting server hop anyway...",
            "error",
            4
        )
    end
end

task.wait(2)

ShowNotification("Candy Farm", "Server hopping...", "info", 4)

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
        Url = string.format(
            "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
            currentPlaceId
        )
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
        ShowNotification(
            "Candy Farm",
            "No available servers found. Retrying in 5 seconds...",
            "error",
            4
        )
        task.wait(5)
        serverHop()
        return
    end
    local queueFunction = getQueueOnTeleport()
    if queueFunction then
        queueFunction("loadstring(game:HttpGet('https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/LoopCandyFarm.lua'))()")
    end
    local teleportSuccess = pcall(function()
        TeleportService:TeleportToPlaceInstance(
            currentPlaceId,
            availableServers[math.random(1, #availableServers)],
            LocalPlayer
        )
    end)
    if not teleportSuccess then
        ShowNotification(
            "Candy Farm",
            "Failed to teleport. Retrying in 5 seconds...",
            "error",
            4
        )
        task.wait(5)
        serverHop()
    end
end

TeleportService.TeleportInitFailed:Connect(function(failedPlayer, errorMessage)
    if failedPlayer ~= LocalPlayer then
        return
    end
    ShowNotification(
        "Candy Farm",
        "Server full or unavailable. Retrying in 5 seconds...",
        "error",
        4
    )
    task.wait(5)
    serverHop()
end)

serverHop()
