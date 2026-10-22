if not game:IsLoaded() then
    game.Loaded:Wait()
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local Theme = {
    WindowBg = Color3.fromRGB(22, 18, 28),
    TitleBarBg = Color3.fromRGB(32, 26, 42),
    ContentBg = Color3.fromRGB(22, 18, 28),
    TabActiveBg = Color3.fromRGB(255, 125, 40),
    TabInactiveBg = Color3.fromRGB(42, 34, 55),
    TabHoverBg = Color3.fromRGB(62, 52, 78),
    TabTextActive = Color3.fromRGB(255, 255, 255),
    TabTextInactive = Color3.fromRGB(190, 185, 205),
    Text = Color3.fromRGB(240, 238, 245),
    TextMuted = Color3.fromRGB(150, 145, 168),
    SeparatorLine = Color3.fromRGB(55, 45, 72),
    ButtonPrimary = Color3.fromRGB(255, 125, 40),
    ButtonDanger = Color3.fromRGB(230, 65, 65),
    ButtonSuccess = Color3.fromRGB(90, 200, 110),
    ButtonNeutral = Color3.fromRGB(72, 58, 95),
    CheckOn = Color3.fromRGB(255, 125, 40),
    CheckOff = Color3.fromRGB(48, 40, 62),
    CheckBorder = Color3.fromRGB(70, 58, 90),
    Border = Color3.fromRGB(58, 47, 78),
    ScrollThumb = Color3.fromRGB(255, 125, 40),
    NotifBg = Color3.fromRGB(32, 26, 42),
    NotifBorder = Color3.fromRGB(58, 47, 78),
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
NotificationGui.Name = "CandyFarmNotifications"
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
    local accentColor = Theme.ButtonPrimary
    if notificationType == "success" then
        accentColor = Theme.ButtonSuccess
    elseif notificationType == "error" then
        accentColor = Theme.ButtonDanger
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
            elseif descendant:IsA("Frame") then
                if descendant.Name == "Accent" or descendant.Name == "ProgressBar" then
                    Tween(descendant, 0.2, {
                        BackgroundTransparency = 1,
                    })
                end
            end
        end
        task.delay(0.3, function()
            if notificationFrame and notificationFrame.Parent then
                notificationFrame:Destroy()
            end
        end)
    end)
end

local Houses = workspace:FindFirstChild("Houses")

if not Houses then
    ShowNotification(
        "Candy Farm",
        "There is no Halloween event running, or this server does not have the update.",
        "error",
        6
    )
    return
end

local candyDataNames = {
    { key = "blue", dataName = "CandyBlue", label = "Blue Candy" },
    { key = "yellow", dataName = "CandyOrange", label = "Yellow Candy" },
    { key = "purple", dataName = "CandyPurple", label = "Purple Candy" },
    { key = "pink", dataName = "CandyPink", label = "Pink Candy" },
    { key = "red", dataName = "CandyRed", label = "Red Candy" },
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

local currentCharacter = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local currentHumanoid = currentCharacter:WaitForChild("Humanoid")
local currentRootPart = currentCharacter:WaitForChild("HumanoidRootPart")

LocalPlayer.CharacterAdded:Connect(function(newCharacter)
    currentCharacter = newCharacter
    currentHumanoid = newCharacter:WaitForChild("Humanoid")
    currentRootPart = newCharacter:WaitForChild("HumanoidRootPart")
end)

local isScriptActive = true
local isFarming = false
local isHidingPopups = true
local isAntiAfkEnabled = true
local hasAutoFarmStarted = false
local isClosing = false
local antiAfkConnection = nil
local housesAddedConnection = nil
local forcedPartConnections = {}
local totalHousesClaimed = 0
local elapsedSeconds = 0

local function updateAntiAfk()
    if isAntiAfkEnabled then
        if not antiAfkConnection then
            antiAfkConnection = LocalPlayer.Idled:Connect(function()
                if isAntiAfkEnabled then
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                end
            end)
        end
    else
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
    end
end

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

local MainGui = Instance.new("ScreenGui")
MainGui.Name = "CandyFarmGUI"
MainGui.ResetOnSpawn = false
MainGui.IgnoreGuiInset = true
MainGui.DisplayOrder = 100
MainGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
MainGui.Parent = PlayerGui

local WindowWidth = 480
local WindowHeight = 680

local Window = Instance.new("Frame")
Window.Name = "Window"
Window.Size = UDim2.fromOffset(WindowWidth, WindowHeight)
Window.BackgroundColor3 = Theme.WindowBg
Window.BorderSizePixel = 0
Window.Active = true
Window.Parent = MainGui

local WindowCorner = Instance.new("UICorner")
WindowCorner.CornerRadius = UDim.new(0, 12)
WindowCorner.Parent = Window

local WindowStroke = Instance.new("UIStroke")
WindowStroke.Color = Theme.Border
WindowStroke.Thickness = 1
WindowStroke.Transparency = 0.3
WindowStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
WindowStroke.Parent = Window

local viewportSize = workspace.CurrentCamera.ViewportSize
Window.Position = UDim2.new(
    0,
    math.floor((viewportSize.X - WindowWidth) / 2),
    0,
    math.floor((viewportSize.Y - WindowHeight) / 2)
)

local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 50)
TitleBar.BackgroundColor3 = Theme.TitleBarBg
TitleBar.BorderSizePixel = 0
TitleBar.Parent = Window

local TitleBarCorner = Instance.new("UICorner")
TitleBarCorner.CornerRadius = UDim.new(0, 12)
TitleBarCorner.Parent = TitleBar

local AccentStripe = Instance.new("Frame")
AccentStripe.Name = "AccentStripe"
AccentStripe.Size = UDim2.new(1, -32, 0, 3)
AccentStripe.Position = UDim2.new(0, 16, 1, -1)
AccentStripe.BackgroundColor3 = Theme.ButtonPrimary
AccentStripe.BorderSizePixel = 0
AccentStripe.Parent = TitleBar

local AccentStripeCorner = Instance.new("UICorner")
AccentStripeCorner.CornerRadius = UDim.new(0, 2)
AccentStripeCorner.Parent = AccentStripe

local TitleText = Instance.new("TextLabel")
TitleText.Name = "Title"
TitleText.Size = UDim2.new(1, -80, 0, 24)
TitleText.Position = UDim2.new(0, 20, 0, 8)
TitleText.BackgroundTransparency = 1
TitleText.Font = Enum.Font.GothamBold
TitleText.TextSize = 18
TitleText.TextColor3 = Theme.Text
TitleText.TextXAlignment = Enum.TextXAlignment.Left
TitleText.Text = "Candy Farm"
TitleText.Parent = TitleBar

local SubtitleText = Instance.new("TextLabel")
SubtitleText.Name = "Subtitle"
SubtitleText.Size = UDim2.new(1, -80, 0, 14)
SubtitleText.Position = UDim2.new(0, 20, 0, 28)
SubtitleText.BackgroundTransparency = 1
SubtitleText.Font = Enum.Font.GothamMedium
SubtitleText.TextSize = 10
SubtitleText.TextColor3 = Theme.TextMuted
SubtitleText.TextXAlignment = Enum.TextXAlignment.Left
SubtitleText.Text = "Halloween 2025 Edition"
SubtitleText.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Name = "CloseButton"
CloseButton.Size = UDim2.fromOffset(30, 30)
CloseButton.Position = UDim2.new(1, -40, 0, 10)
CloseButton.BackgroundColor3 = Theme.ButtonDanger
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.Font = Enum.Font.GothamBold
CloseButton.TextSize = 14
CloseButton.TextColor3 = Theme.Text
CloseButton.AutoButtonColor = false
CloseButton.Parent = TitleBar

local CloseButtonCorner = Instance.new("UICorner")
CloseButtonCorner.CornerRadius = UDim.new(0, 6)
CloseButtonCorner.Parent = CloseButton

CloseButton.MouseEnter:Connect(function()
    Tween(CloseButton, 0.15, {
        BackgroundColor3 = Color3.fromRGB(250, 85, 85),
    })
end)

CloseButton.MouseLeave:Connect(function()
    Tween(CloseButton, 0.15, {
        BackgroundColor3 = Theme.ButtonDanger,
    })
end)

local isDragging = false
local dragStartMouse = nil
local dragStartPosition = nil

TitleBar.InputBegan:Connect(function(input)
    if input.Target == CloseButton then
        return
    end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStartMouse = Vector2.new(input.Position.X, input.Position.Y)
        dragStartPosition = Window.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if not isDragging then
        return
    end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end
    if not Window or not Window.Parent then
        isDragging = false
        return
    end
    local currentMouse = Vector2.new(input.Position.X, input.Position.Y)
    local delta = currentMouse - dragStartMouse
    Window.Position = UDim2.new(
        dragStartPosition.X.Scale,
        dragStartPosition.X.Offset + delta.X,
        dragStartPosition.Y.Scale,
        dragStartPosition.Y.Offset + delta.Y
    )
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

local TabBar = Instance.new("Frame")
TabBar.Name = "TabBar"
TabBar.Size = UDim2.new(1, -20, 0, 38)
TabBar.Position = UDim2.new(0, 10, 0, 64)
TabBar.BackgroundTransparency = 1
TabBar.Parent = Window

local TabBarLayout = Instance.new("UIListLayout")
TabBarLayout.FillDirection = Enum.FillDirection.Horizontal
TabBarLayout.Padding = UDim.new(0, 4)
TabBarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TabBarLayout.Parent = TabBar

local ContentArea = Instance.new("Frame")
ContentArea.Name = "Content"
ContentArea.Size = UDim2.new(1, -20, 1, -122)
ContentArea.Position = UDim2.new(0, 10, 0, 110)
ContentArea.BackgroundColor3 = Theme.ContentBg
ContentArea.BorderSizePixel = 0
ContentArea.Parent = Window

local ContentAreaCorner = Instance.new("UICorner")
ContentAreaCorner.CornerRadius = UDim.new(0, 8)
ContentAreaCorner.Parent = ContentArea

local ContentAreaStroke = Instance.new("UIStroke")
ContentAreaStroke.Color = Theme.Border
ContentAreaStroke.Thickness = 1
ContentAreaStroke.Transparency = 0.5
ContentAreaStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ContentAreaStroke.Parent = ContentArea

local tabs = {}
local activeTabName = nil

local function switchTab(tabName)
    if activeTabName == tabName then
        return
    end
    for name, tabInfo in pairs(tabs) do
        if name == tabName then
            tabInfo.Button.BackgroundColor3 = Theme.TabActiveBg
            tabInfo.TextLabel.TextColor3 = Theme.TabTextActive
            tabInfo.Content.Visible = true
        else
            tabInfo.Button.BackgroundColor3 = Theme.TabInactiveBg
            tabInfo.TextLabel.TextColor3 = Theme.TabTextInactive
            tabInfo.Content.Visible = false
        end
    end
    activeTabName = tabName
end

local function createTab(tabKey, displayName)
    local tabButton = Instance.new("TextButton")
    tabButton.Name = tabKey .. "TabButton"
    tabButton.Size = UDim2.new(0.25, -3, 1, 0)
    tabButton.BackgroundColor3 = Theme.TabInactiveBg
    tabButton.BorderSizePixel = 0
    tabButton.Text = ""
    tabButton.AutoButtonColor = false
    tabButton.Parent = TabBar

    local tabButtonCorner = Instance.new("UICorner")
    tabButtonCorner.CornerRadius = UDim.new(0, 8)
    tabButtonCorner.Parent = tabButton

    local tabTextLabel = Instance.new("TextLabel")
    tabTextLabel.Name = "TextLabel"
    tabTextLabel.Size = UDim2.new(1, 0, 1, 0)
    tabTextLabel.BackgroundTransparency = 1
    tabTextLabel.Font = Enum.Font.GothamBold
    tabTextLabel.TextSize = 13
    tabTextLabel.TextColor3 = Theme.TabTextInactive
    tabTextLabel.Text = displayName
    tabTextLabel.Parent = tabButton

    local tabContent = Instance.new("ScrollingFrame")
    tabContent.Name = tabKey .. "TabContent"
    tabContent.Size = UDim2.new(1, -16, 1, -16)
    tabContent.Position = UDim2.new(0, 8, 0, 8)
    tabContent.BackgroundTransparency = 1
    tabContent.BorderSizePixel = 0
    tabContent.ScrollBarThickness = 4
    tabContent.ScrollBarImageColor3 = Theme.ScrollThumb
    tabContent.ScrollBarImageTransparency = 0.3
    tabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    tabContent.ScrollingDirection = Enum.ScrollingDirection.Y
    tabContent.Visible = false
    tabContent.Parent = ContentArea

    local tabListLayout = Instance.new("UIListLayout")
    tabListLayout.Padding = UDim.new(0, 8)
    tabListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabListLayout.Parent = tabContent

    tabs[tabKey] = {
        Button = tabButton,
        TextLabel = tabTextLabel,
        Content = tabContent,
        Layout = tabListLayout,
    }

    tabButton.MouseEnter:Connect(function()
        if activeTabName ~= tabKey then
            Tween(tabButton, 0.15, {
                BackgroundColor3 = Theme.TabHoverBg,
            })
        end
    end)

    tabButton.MouseLeave:Connect(function()
        if activeTabName ~= tabKey then
            Tween(tabButton, 0.15, {
                BackgroundColor3 = Theme.TabInactiveBg,
            })
        end
    end)

    tabButton.MouseButton1Click:Connect(function()
        switchTab(tabKey)
    end)

    return tabs[tabKey]
end

local function createLabel(tab, text, layoutOrder, colorOverride, wrapped)
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, 0, 0, wrapped and 0 or 22)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 13
    label.TextColor3 = colorOverride or Theme.Text
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextYAlignment = Enum.TextYAlignment.Top
    label.TextWrapped = wrapped or false
    label.Text = text
    label.LayoutOrder = layoutOrder
    if wrapped then
        label.AutomaticSize = Enum.AutomaticSize.Y
    end
    label.Parent = tab.Content
    return label
end

local function createSeparator(tab, text, layoutOrder)
    local separator = Instance.new("Frame")
    separator.Name = "Separator"
    separator.Size = UDim2.new(1, 0, 0, 30)
    separator.BackgroundTransparency = 1
    separator.LayoutOrder = layoutOrder
    separator.Parent = tab.Content

    local separatorText = Instance.new("TextLabel")
    separatorText.Name = "Text"
    separatorText.Size = UDim2.new(1, 0, 0, 20)
    separatorText.BackgroundTransparency = 1
    separatorText.Font = Enum.Font.GothamBold
    separatorText.TextSize = 11
    separatorText.TextColor3 = Theme.TextMuted
    separatorText.TextXAlignment = Enum.TextXAlignment.Left
    separatorText.Text = string.upper(text)
    separatorText.Parent = separator

    local separatorLine = Instance.new("Frame")
    separatorLine.Name = "Line"
    separatorLine.Size = UDim2.new(1, 0, 0, 1)
    separatorLine.Position = UDim2.new(0, 0, 0, 26)
    separatorLine.BackgroundColor3 = Theme.SeparatorLine
    separatorLine.BackgroundTransparency = 0.3
    separatorLine.BorderSizePixel = 0
    separatorLine.Parent = separator

    return separator
end

local function createButton(tab, text, layoutOrder, initialColor, callback)
    local baseColor = initialColor
    local isHovering = false

    local button = Instance.new("TextButton")
    button.Name = "Button"
    button.Size = UDim2.new(1, 0, 0, 40)
    button.BackgroundColor3 = baseColor
    button.BorderSizePixel = 0
    button.Text = text
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.TextColor3 = Theme.Text
    button.AutoButtonColor = false
    button.LayoutOrder = layoutOrder
    button.Parent = tab.Content

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 8)
    buttonCorner.Parent = button

    local buttonApi = {
        Instance = button,
        SetText = function(newText)
            button.Text = newText
        end,
        SetColor = function(newColor)
            baseColor = newColor
            if isHovering then
                button.BackgroundColor3 = newColor:Lerp(Color3.new(1, 1, 1), 0.15)
            else
                button.BackgroundColor3 = newColor
            end
        end,
    }

    button.MouseEnter:Connect(function()
        isHovering = true
        Tween(button, 0.15, {
            BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.15),
        })
    end)

    button.MouseLeave:Connect(function()
        isHovering = false
        Tween(button, 0.15, {
            BackgroundColor3 = baseColor,
        })
    end)

    button.MouseButton1Down:Connect(function()
        Tween(button, 0.1, {
            BackgroundColor3 = baseColor:Lerp(Color3.new(0, 0, 0), 0.2),
        })
    end)

    button.MouseButton1Up:Connect(function()
        if isHovering then
            Tween(button, 0.15, {
                BackgroundColor3 = baseColor:Lerp(Color3.new(1, 1, 1), 0.15),
            })
        else
            Tween(button, 0.15, {
                BackgroundColor3 = baseColor,
            })
        end
    end)

    button.MouseButton1Click:Connect(function()
        if callback then
            callback(buttonApi)
        end
    end)

    return buttonApi
end

local function createCheckbox(tab, text, initialValue, layoutOrder, callback)
    local currentValue = initialValue

    local checkboxButton = Instance.new("TextButton")
    checkboxButton.Name = "Checkbox"
    checkboxButton.Size = UDim2.new(1, 0, 0, 30)
    checkboxButton.BackgroundTransparency = 1
    checkboxButton.Text = ""
    checkboxButton.AutoButtonColor = false
    checkboxButton.LayoutOrder = layoutOrder
    checkboxButton.Parent = tab.Content

    local checkboxBox = Instance.new("Frame")
    checkboxBox.Name = "Box"
    checkboxBox.Size = UDim2.fromOffset(22, 22)
    checkboxBox.Position = UDim2.new(0, 4, 0.5, -11)
    checkboxBox.BackgroundColor3 = initialValue and Theme.CheckOn or Theme.CheckOff
    checkboxBox.BorderSizePixel = 0
    checkboxBox.Parent = checkboxButton

    local checkboxBoxCorner = Instance.new("UICorner")
    checkboxBoxCorner.CornerRadius = UDim.new(0, 5)
    checkboxBoxCorner.Parent = checkboxBox

    local checkboxBoxStroke = Instance.new("UIStroke")
    checkboxBoxStroke.Color = Theme.CheckBorder
    checkboxBoxStroke.Thickness = 1
    checkboxBoxStroke.Transparency = 0.3
    checkboxBoxStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    checkboxBoxStroke.Parent = checkboxBox

    local checkmark = Instance.new("TextLabel")
    checkmark.Name = "Checkmark"
    checkmark.Size = UDim2.new(1, 0, 1, 0)
    checkmark.BackgroundTransparency = 1
    checkmark.Font = Enum.Font.GothamBold
    checkmark.TextSize = 16
    checkmark.TextColor3 = Color3.fromRGB(255, 255, 255)
    checkmark.Text = "X"
    checkmark.TextTransparency = initialValue and 0 or 1
    checkmark.Parent = checkboxBox

    local checkboxLabel = Instance.new("TextLabel")
    checkboxLabel.Name = "Label"
    checkboxLabel.Size = UDim2.new(1, -40, 1, 0)
    checkboxLabel.Position = UDim2.new(0, 34, 0, 0)
    checkboxLabel.BackgroundTransparency = 1
    checkboxLabel.Font = Enum.Font.GothamMedium
    checkboxLabel.TextSize = 13
    checkboxLabel.TextColor3 = Theme.Text
    checkboxLabel.TextXAlignment = Enum.TextXAlignment.Left
    checkboxLabel.Text = text
    checkboxLabel.Parent = checkboxButton

    local function updateVisual(newState)
        currentValue = newState
        if newState then
            Tween(checkboxBox, 0.2, {
                BackgroundColor3 = Theme.CheckOn,
            })
            Tween(checkmark, 0.15, {
                TextTransparency = 0,
            })
        else
            Tween(checkboxBox, 0.2, {
                BackgroundColor3 = Theme.CheckOff,
            })
            Tween(checkmark, 0.15, {
                TextTransparency = 1,
            })
        end
    end

    checkboxButton.MouseButton1Click:Connect(function()
        updateVisual(not currentValue)
        if callback then
            callback(currentValue)
        end
    end)

    return {
        SetValue = function(value)
            updateVisual(value)
        end,
        GetValue = function()
            return currentValue
        end,
    }
end

local FarmTab = createTab("Farm", "Farm")

createSeparator(FarmTab, "Candy Farm - This Server", 1)

createCheckbox(FarmTab, "Anti-AFK", true, 2, function(value)
    isAntiAfkEnabled = value
    updateAntiAfk()
end)

createCheckbox(FarmTab, "Hide Reward Popups", true, 3, function(value)
    isHidingPopups = value
end)

local farmButton = createButton(FarmTab, "Start Candy Farm", 4, Theme.ButtonPrimary, function(buttonApi)
    if not isFarming then
        isFarming = true
        buttonApi.SetText("Stop Candy Farm")
        buttonApi.SetColor(Theme.ButtonDanger)
        performAutoFarm()
        ShowNotification("Candy Farm", "Candy farm started for this server.", "success", 3)
    else
        isFarming = false
        buttonApi.SetText("Start Candy Farm")
        buttonApi.SetColor(Theme.ButtonPrimary)
        for doorPart, connection in pairs(forcedPartConnections) do
            if connection then
                connection:Disconnect()
            end
            forcedPartConnections[doorPart] = nil
        end
        ShowNotification("Candy Farm", "Candy farm stopped.", "info", 3)
    end
end)

createSeparator(FarmTab, "Statistics", 5)

local timeElapsedLabel = createLabel(FarmTab, "Time Elapsed: 00:00:00", 6)
local totalHousesLabel = createLabel(FarmTab, "Total Houses: 0", 7)
local fakeHousesLabel = createLabel(FarmTab, "Fake Houses: 0", 8)
local totalCandyLabel = createLabel(FarmTab, "Total Candy: 0", 9)

local candyLabels = {}
local candyLabelOrder = 10
for _, candyInfo in ipairs(candyDataNames) do
    candyLabels[candyInfo.key] = createLabel(
        FarmTab,
        string.format("%s: 0", candyInfo.label),
        candyLabelOrder
    )
    candyLabelOrder = candyLabelOrder + 1
end

housesAddedConnection = Houses.ChildAdded:Connect(function()
    if not isFarming then
        return
    end
    task.wait(0.3)
    performAutoFarm()
end)

local function formatElapsedTime(totalSeconds)
    local hours = math.floor(totalSeconds / 3600)
    local minutes = math.floor((totalSeconds % 3600) / 60)
    local seconds = totalSeconds % 60
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

task.spawn(function()
    while isScriptActive do
        if isHidingPopups then
            pcall(function()
                StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, true)
            end)
            setItemGainedScriptEnabled(false)
        else
            setItemGainedScriptEnabled(true)
        end
        task.wait(0.1)
    end
end)

task.spawn(function()
    while isScriptActive do
        if isFarming then
            elapsedSeconds = elapsedSeconds + 1
            if timeElapsedLabel then
                timeElapsedLabel.Text = "Time Elapsed: " .. formatElapsedTime(elapsedSeconds)
            end
            local totalGained = 0
            for _, candyInfo in ipairs(candyDataNames) do
                local currentValue = getDataValue(candyInfo.dataName)
                local gainedAmount = currentValue - initialCandyValues[candyInfo.key]
                totalGained = totalGained + gainedAmount
                local candyLabel = candyLabels[candyInfo.key]
                if candyLabel then
                    candyLabel.Text = string.format("%s: %d", candyInfo.label, gainedAmount)
                end
            end
            local fakeHouseCount = totalHousesClaimed - totalGained
            if totalHousesLabel then
                totalHousesLabel.Text = string.format("Total Houses: %d", totalHousesClaimed)
            end
            if fakeHousesLabel then
                fakeHousesLabel.Text = string.format("Fake Houses: %d", fakeHouseCount)
            end
            if totalCandyLabel then
                totalCandyLabel.Text = string.format("Total Candy: %d", totalGained)
            end
        end
        task.wait(1)
    end
end)

local AutoTab = createTab("AutoFarm", "Auto Farm")

createSeparator(AutoTab, "Candy Farm with Server Hop", 1)

local autoFarmButton = createButton(AutoTab, "Start Auto Farm", 2, Theme.ButtonPrimary, function(buttonApi)
    if hasAutoFarmStarted then
        ShowNotification("Auto Farm", "Auto farm is already running.", "info", 2)
        return
    end
    buttonApi.SetText("Starting...")
    buttonApi.SetColor(Theme.ButtonNeutral)
    isFarming = true
    performAutoFarm()
    local loadSuccess = pcall(function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/Fantom233/BABFT/refs/heads/main/LoopCandyFarm.lua"))()
    end)
    if not loadSuccess then
        isFarming = false
        buttonApi.SetText("Failed to load")
        buttonApi.SetColor(Theme.ButtonDanger)
        task.wait(2)
        buttonApi.SetText("Start Auto Farm")
        buttonApi.SetColor(Theme.ButtonPrimary)
        ShowNotification("Auto Farm", "Failed to start auto farm. Please try again.", "error", 4)
        return
    end
    hasAutoFarmStarted = true
    buttonApi.SetText("Started!")
    buttonApi.SetColor(Theme.ButtonSuccess)
    ShowNotification("Auto Farm", "Auto farm is starting. Sit tight.", "success", 4)
end)

createSeparator(AutoTab, "Important", 3)

createLabel(
    AutoTab,
    "This method claims houses and then hops to a different server. It is the most efficient way to farm candy, but not all executors support it. If you want to play BABFT while farming candy, use the Farm tab.",
    4,
    Theme.TextMuted,
    true
)

createLabel(
    AutoTab,
    "Once started, the only way to stop it is to close Roblox. The interface will not appear in the next server, but the farming will continue.",
    5,
    Theme.ButtonPrimary,
    true
)

local InfoTab = createTab("Info", "Info")

createSeparator(InfoTab, "How to Use", 1)

createLabel(
    InfoTab,
    "Do not toggle 'Hide Reward Popups' while auto farming. Enable it only when there is no reward card on your screen.",
    2,
    Theme.Text,
    true
)

createLabel(
    InfoTab,
    "You can do other things at the same time as farming candy.",
    3,
    Theme.ButtonPrimary,
    true
)

createSeparator(InfoTab, "Candy Types", 4)

createLabel(InfoTab, "Blue Candy - shrinks the player permanently until death.", 5, Theme.TextMuted, true)
createLabel(InfoTab, "Yellow (Orange) Candy - 30% speed boost for 3 minutes.", 6, Theme.TextMuted, true)
createLabel(InfoTab, "Purple Candy - 900% jump boost for 3 minutes.", 7, Theme.TextMuted, true)
createLabel(InfoTab, "Pink Candy - combines Yellow and Purple effects for 3 minutes.", 8, Theme.TextMuted, true)
createLabel(InfoTab, "Red Candy - enlarges the player permanently until death (no longer obtainable).", 9, Theme.TextMuted, true)

createSeparator(InfoTab, "About This Script", 10)

createLabel(InfoTab, "This script is free, keyless, and open source.", 11, Theme.Text, true)

local CreditsTab = createTab("Credits", "Credits")

createSeparator(CreditsTab, "Author", 1)

createLabel(CreditsTab, "Asu", 2, Theme.Text, true)

createSeparator(CreditsTab, "Note", 3)

createLabel(
    CreditsTab,
    "If you enjoy this script, share it with your friends. Thanks for using it.",
    4,
    Theme.TextMuted,
    true
)

switchTab("Farm")

updateAntiAfk()

CloseButton.MouseButton1Click:Connect(function()
    if isClosing then
        return
    end
    isClosing = true
    isScriptActive = false
    isFarming = false
    if antiAfkConnection then
        antiAfkConnection:Disconnect()
        antiAfkConnection = nil
    end
    if housesAddedConnection then
        housesAddedConnection:Disconnect()
        housesAddedConnection = nil
    end
    for doorPart, connection in pairs(forcedPartConnections) do
        if connection then
            connection:Disconnect()
        end
        forcedPartConnections[doorPart] = nil
    end
    setItemGainedScriptEnabled(true)
    MainGui:Destroy()
    NotificationGui:Destroy()
end)

task.delay(0.5, function()
    if not isScriptActive then
        return
    end
    ShowNotification("Candy Farm", "Script loaded successfully. Ready to farm.", "success", 4)
end)
