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
    NotifBg = Color3.fromRGB(34, 20, 46),
    NotifBorder = Color3.fromRGB(70, 45, 95),
    Text = Color3.fromRGB(245, 240, 230),
    TextMuted = Color3.fromRGB(170, 155, 185),
    SeparatorLine = Color3.fromRGB(70, 45, 95),
    AccentPrimary = Color3.fromRGB(255, 122, 30),
    AccentSuccess = Color3.fromRGB(120, 200, 90),
    AccentDanger = Color3.fromRGB(220, 50, 50),
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
    local titleEmoji = "👻"

    if notificationType == "success" then
        accentColor = Theme.AccentSuccess
        titleEmoji = "🎃"
    elseif notificationType == "error" then
        accentColor = Theme.AccentDanger
        titleEmoji = "💀"
    end

    local holder = Instance.new("Frame")
    holder.Name = "NotificationHolder_" .. tostring(currentOrder)
    holder.Size = UDim2.new(1, 0, 0, 76)
    holder.BackgroundTransparency = 1
    holder.BorderSizePixel = 0
    holder.LayoutOrder = -currentOrder
    holder.Parent = NotificationContainer

    local card = Instance.new("Frame")
    card.Name = "Card"
    card.Size = UDim2.new(1, 0, 1, 0)
    card.Position = UDim2.new(1.5, 0, 0, 0)
    card.BackgroundColor3 = Theme.NotifBg
    card.BackgroundTransparency = 0.3
    card.BorderSizePixel = 0
    card.Parent = holder

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 10)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Theme.NotifBorder
    cardStroke.Thickness = 1
    cardStroke.Transparency = 0.3
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Name = "Accent"
    accentBar.Size = UDim2.new(0, 4, 1, -14)
    accentBar.Position = UDim2.new(0, 6, 0, 7)
    accentBar.BackgroundColor3 = accentColor
    accentBar.BorderSizePixel = 0
    accentBar.Parent = card

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
    titleLabel.Text = titleEmoji .. " " .. title
    titleLabel.Parent = card

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
    messageLabel.Parent = card

    local progressTrack = Instance.new("Frame")
    progressTrack.Name = "ProgressTrack"
    progressTrack.Size = UDim2.new(1, -24, 0, 2)
    progressTrack.Position = UDim2.new(0, 12, 1, -6)
    progressTrack.BackgroundColor3 = Theme.SeparatorLine
    progressTrack.BorderSizePixel = 0
    progressTrack.Parent = card

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

    Tween(card, 0.3, {
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 0,
    }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

    Tween(progressBar, duration, {
        Size = UDim2.new(0, 0, 1, 0),
    }, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    task.delay(duration, function()
        if not holder or not holder.Parent then
            return
        end

        Tween(card, 0.25, {
            Position = UDim2.new(1.5, 0, 0, 0),
            BackgroundTransparency = 0.3,
        }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

        Tween(accentBar, 0.2, {
            BackgroundTransparency = 1,
        })

        Tween(cardStroke, 0.2, {
            Transparency = 1,
        })

        Tween(titleLabel, 0.2, {
            TextTransparency = 1,
        })

        Tween(messageLabel, 0.2, {
            TextTransparency = 1,
        })

        Tween(progressTrack, 0.2, {
            BackgroundTransparency = 1,
        })

        Tween(progressBar, 0.2, {
            BackgroundTransparency = 1,
        })

        task.delay(0.3, function()
            if holder and holder.Parent then
                holder:Destroy()
            end
        end)
    end)
end

local Houses = workspace:WaitForChild("Houses", 30)

if not Houses then
    getgenv().CANDY_LOOP_ACTIVE = false
    ShowNotification(
        "Candy Farm",
        "There is no Halloween event running, or this server does not have the update.",
        "error",
        6
    )
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

        if not currentHumanoid or not currentRootPart then
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
    if not currentHumanoid or not currentRootPart then
        return
    end

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
    local startTime = os.clock()
    local anyCandyChanged = false

    repeat
        task.wait()

        for _, candyInfo in ipairs(candyDataNames) do
            if getDataValue(candyInfo.dataName) ~= initialCandyValues[candyInfo.key] then
                anyCandyChanged = true
                break
            end
        end
    until anyCandyChanged or (os.clock() - startTime) >= timeoutSeconds

    if not anyCandyChanged then
        ShowNotification(
            "Candy Farm",
            "Candy was not collected in time. Server hopping anyway.",
            "error",
            4
        )
    end
end

task.wait(2)

ShowNotification("Candy Farm", "Server hopping...", "info", 4)

local function getHttpRequest()
    if request then
        return request
    end

    if http_request then
        return http_request
    end

    if syn and syn.request then
        return syn.request
    end

    if http and http.request then
        return http.request
    end

    if fluxus and fluxus.request then
        return fluxus.request
    end

    return nil
end

local function getQueueOnTeleport()
    if queue_on_teleport then
        return queue_on_teleport
    end

    if syn and syn.queue_on_teleport then
        return syn.queue_on_teleport
    end

    if fluxus and fluxus.queue_on_teleport then
        return fluxus.queue_on_teleport
    end

    if queueonteleport then
        return queueonteleport
    end

    return nil
end

local function findAvailableServers()
    local httpRequest = getHttpRequest()

    if not httpRequest then
        return {}
    end

    local currentJobId = game.JobId
    local currentPlaceId = game.PlaceId

    local requestUrl = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Desc&limit=100&excludeFullGames=true",
        currentPlaceId
    )

    local requestSucceeded, response = pcall(function()
        return httpRequest({
            Url = requestUrl,
            Method = "GET",
        })
    end)

    if not requestSucceeded or type(response) ~= "table" then
        return {}
    end

    if not response.Body then
        return {}
    end

    local decodeSucceeded, decodedBody = pcall(function()
        return HttpService:JSONDecode(response.Body)
    end)

    if not decodeSucceeded or type(decodedBody) ~= "table" then
        return {}
    end

    if type(decodedBody.data) ~= "table" then
        return {}
    end

    local availableServers = {}

    for _, serverInfo in ipairs(decodedBody.data) do
        if type(serverInfo) == "table" then
            local serverId = serverInfo.id
            local playing = tonumber(serverInfo.playing)
            local maxPlayers = tonumber(serverInfo.maxPlayers)

            if serverId and playing and maxPlayers then
                if playing < maxPlayers and serverId ~= currentJobId then
                    table.insert(availableServers, serverId)
                end
            end
        end
    end

    return availableServers
end

local isHopping = false
local isRetryScheduled = false
local attemptServerHop

local function scheduleHopRetry(delaySeconds)
    if isRetryScheduled then
        return
    end

    isRetryScheduled = true

    task.delay(delaySeconds, function()
        isRetryScheduled = false
        isHopping = false
        attemptServerHop()
    end)
end

attemptServerHop = function()
    if isHopping then
        return
    end

    isHopping = true

    local availableServers = findAvailableServers()

    if #availableServers == 0 then
        ShowNotification(
            "Candy Farm",
            "No available servers found. Retrying in 5 seconds...",
            "error",
            4
        )
        scheduleHopRetry(5)
        return
    end

    local queueFunction = getQueueOnTeleport()

    if queueFunction then
        queueFunction("loadstring(game:HttpGet('https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/LoopCandyFarm.lua'))()")
    end

    local chosenServer = availableServers[math.random(1, #availableServers)]

    local teleportSuccess = pcall(function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, chosenServer, LocalPlayer)
    end)

    if not teleportSuccess then
        ShowNotification(
            "Candy Farm",
            "Failed to teleport. Retrying in 5 seconds...",
            "error",
            4
        )
        scheduleHopRetry(5)
    end
end

TeleportService.TeleportInitFailed:Connect(function(failedPlayer, teleportResult, errorMessage)
    if failedPlayer ~= LocalPlayer then
        return
    end

    ShowNotification(
        "Candy Farm",
        "Server full or unavailable. Retrying in 5 seconds...",
        "error",
        4
    )
    scheduleHopRetry(5)
end)

attemptServerHop()
