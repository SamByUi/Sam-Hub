if not game:IsLoaded() then game.Loaded:Wait() end
local player = game.Players.LocalPlayer
local plrGui = player:FindFirstChildOfClass("PlayerGui") or player:WaitForChild("PlayerGui")
local ui = Instance.new("ScreenGui")
ui.Name = "MobileExecutorUI"
ui.Parent = plrGui
ui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ui.IgnoreGuiInset = true

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.8, 0, 0.7, 0)
mainFrame.Position = UDim2.new(0.1, 0, 0.15, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Active = true
mainFrame.Visible = true
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame
mainFrame.Parent = ui

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.Parent = mainFrame
local titleLabel = Instance.new("TextLabel")
titleLabel.Text = "工具菜单"
titleLabel.Size = UDim2.new(1, -80, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextScaled = true
titleLabel.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Text = "×"
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -40, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.TextScaled = true
closeBtn.Parent = titleBar
local cornerClose = Instance.new("UICorner")
cornerClose.CornerRadius = UDim.new(0, 8)
cornerClose.Parent = closeBtn

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Text = "−"
minimizeBtn.Size = UDim2.new(0, 40, 0, 40)
minimizeBtn.Position = UDim2.new(1, -80, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.TextScaled = true
minimizeBtn.Parent = titleBar
local cornerMin = Instance.new("UICorner")
cornerMin.CornerRadius = UDim.new(0, 8)
cornerMin.Parent = minimizeBtn

local dragStart, startPos
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and dragStart then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragStart = nil
    end
end)

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0.3, 0, 1, -40)
leftPanel.Position = UDim2.new(0, 0, 0, 40)
leftPanel.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
leftPanel.Parent = mainFrame

local plrName = Instance.new("TextLabel")
plrName.Text = player.Name
plrName.Size = UDim2.new(1, 0, 0, 30)
plrName.Position = UDim2.new(0, 0, 0, 10)
plrName.BackgroundTransparency = 1
plrName.TextColor3 = Color3.new(1, 1, 1)
plrName.Parent = leftPanel

local plrUserId = Instance.new("TextLabel")
plrUserId.Text = "ID: " .. player.UserId
plrUserId.Size = UDim2.new(1, 0, 0, 30)
plrUserId.Position = UDim2.new(0, 0, 0, 50)
plrUserId.BackgroundTransparency = 1
plrUserId.TextColor3 = Color3.new(0.8, 0.8, 0.8)
plrUserId.Parent = leftPanel

local rightPanel = Instance.new("Frame")
rightPanel.Size = UDim2.new(0.7, 0, 1, -40)
rightPanel.Position = UDim2.new(0.3, 0, 0, 40)
rightPanel.BackgroundTransparency = 1
rightPanel.Parent = mainFrame

local tpBox = Instance.new("TextBox")
tpBox.PlaceholderText = "输入用户名"
tpBox.Size = UDim2.new(0.6, 0, 0, 30)
tpBox.Position = UDim2.new(0.1, 0, 0, 20)
tpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpBox.TextColor3 = Color3.new(1, 1, 1)
tpBox.BorderSizePixel = 0
local cornerTp = Instance.new("UICorner")
cornerTp.Parent = tpBox
tpBox.Parent = rightPanel

local tpBtn = Instance.new("TextButton")
tpBtn.Text = "传送到玩家"
tpBtn.Size = UDim2.new(0.2, 0, 0, 30)
tpBtn.Position = UDim2.new(0.75, 0, 0, 20)
tpBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.BorderSizePixel = 0
local cornerTpBtn = Instance.new("UICorner")
cornerTpBtn.Parent = tpBtn
tpBtn.Parent = rightPanel

tpBtn.MouseButton1Click:Connect(function()
    local target = game.Players:FindFirstChild(tpBox.Text)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame
    end
end)

local hitboxBox = Instance.new("TextBox")
hitboxBox.PlaceholderText = "输入大小(0恢复)"
hitboxBox.Size = UDim2.new(0.6, 0, 0, 30)
hitboxBox.Position = UDim2.new(0.1, 0, 0, 70)
hitboxBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxBox.TextColor3 = Color3.new(1, 1, 1)
hitboxBox.BorderSizePixel = 0
local cornerHb = Instance.new("UICorner")
cornerHb.Parent = hitboxBox
hitboxBox.Parent = rightPanel

local hitboxBtn = Instance.new("TextButton")
hitboxBtn.Text = "修改Hitbox"
hitboxBtn.Size = UDim2.new(0.2, 0, 0, 30)
hitboxBtn.Position = UDim2.new(0.75, 0, 0, 70)
hitboxBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
hitboxBtn.TextColor3 = Color3.new(1, 1, 1)
hitboxBtn.BorderSizePixel = 0
local cornerHbBtn = Instance.new("UICorner")
cornerHbBtn.Parent = hitboxBtn
hitboxBtn.Parent = rightPanel

hitboxBtn.MouseButton1Click:Connect(function()
    local size = tonumber(hitboxBox.Text) or 0
    local char = player.Character
    if char then
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                if size == 0 then
                    part.Size = part.Size / (part.Size.X / (part.Size.X * 0.5))
                else
                    part.Size = Vector3.new(size, size, size)
                end
            end
        end
    end
end)

local espState = false
local espBtn = Instance.new("TextButton")
espBtn.Text = "ESP (关闭)"
espBtn.Size = UDim2.new(0.8, 0, 0, 30)
espBtn.Position = UDim2.new(0.1, 0, 0, 120)
espBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.BorderSizePixel = 0
local cornerEsp = Instance.new("UICorner")
cornerEsp.Parent = espBtn
espBtn.Parent = rightPanel

local espBoxes = {}
espBtn.MouseButton1Click:Connect(function()
    espState = not espState
    espBtn.Text = "ESP (" .. (espState and "开启" or "关闭") .. ")"
    if espState then
        for _, plr in ipairs(game.Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = plr.Character:FindFirstChild("HumanoidRootPart") or plr.Character:WaitForChild("HumanoidRootPart")
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = Color3.new(1, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = workspace.CurrentCamera
                espBoxes[plr] = box
            end
        end
        game.Players.PlayerAdded:Connect(function(plr)
            plr.CharacterAdded:Connect(function(char)
                local hrp = char:WaitForChild("HumanoidRootPart")
                local box = Instance.new("BoxHandleAdornment")
                box.Adornee = hrp
                box.Size = Vector3.new(4, 6, 2)
                box.Color3 = Color3.new(1, 0, 0)
                box.AlwaysOnTop = true
                box.ZIndex = 5
                box.Parent = workspace.CurrentCamera
                espBoxes[plr] = box
            end)
        end)
        game.Players.PlayerRemoving:Connect(function(plr)
            if espBoxes[plr] then
                espBoxes[plr]:Destroy()
                espBoxes[plr] = nil
            end
        end)
    else
        for _, box in pairs(espBoxes) do
            box:Destroy()
        end
        espBoxes = {}
    end
end)

local infYieldBtn = Instance.new("TextButton")
infYieldBtn.Text = "Infinite Yield"
infYieldBtn.Size = UDim2.new(0.8, 0, 0, 30)
infYieldBtn.Position = UDim2.new(0.1, 0, 0, 170)
infYieldBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
infYieldBtn.TextColor3 = Color3.new(1, 1, 1)
infYieldBtn.BorderSizePixel = 0
local cornerInf = Instance.new("UICorner")
cornerInf.Parent = infYieldBtn
infYieldBtn.Parent = rightPanel

infYieldBtn.MouseButton1Click:Connect(function()
    loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
end)

local floatFrame = Instance.new("Frame")
floatFrame.Size = UDim2.new(0, 50, 0, 50)
floatFrame.Position = UDim2.new(0.8, 0, 0.5, 0)
floatFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
floatFrame.BorderSizePixel = 0
floatFrame.Visible = false
local cornerFloat = Instance.new("UICorner")
cornerFloat.CornerRadius = UDim.new(1, 0)
cornerFloat.Parent = floatFrame
floatFrame.Parent = ui

local sLabel = Instance.new("TextLabel")
sLabel.Text = "S"
sLabel.Size = UDim2.new(1, 0, 1, 0)
sLabel.BackgroundTransparency = 1
sLabel.TextColor3 = Color3.new(1, 1, 1)
sLabel.TextScaled = true
sLabel.Parent = floatFrame

closeBtn.MouseButton1Click:Connect(function()
    ui:Destroy()
end)

local isMinimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    mainFrame.Visible = not isMinimized
    floatFrame.Visible = isMinimized
end)

local floatDragStart, floatStartPos
floatFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        floatDragStart = input.Position
        floatStartPos = floatFrame.Position
    end
end)
floatFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and floatDragStart then
        local delta = input.Position - floatDragStart
        floatFrame.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
    end
end)
floatFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        floatDragStart = nil
    end
end)

floatFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch and input.UserInputState == Enum.UserInputState.End then
        isMinimized = false
        mainFrame.Visible = true
        floatFrame.Visible = false
    end
end)
