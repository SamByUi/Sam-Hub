local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local function createDebugUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "DebugUI"
    screenGui.ResetOnSpawn = false

    local debugButton = Instance.new("TextButton")
    debugButton.Size = UDim2.new(0, 60, 0, 60)
    debugButton.Position = UDim2.new(0, 30, 0, 100)
    debugButton.AnchorPoint = Vector2.new(0.5, 0.5)
    debugButton.BackgroundColor3 = Color3.fromRGB(60, 160, 250)
    debugButton.Text = "⚙️"
    debugButton.Font = Enum.Font.GothamBold
    debugButton.TextSize = 36
    debugButton.TextColor3 = Color3.new(1,1,1)
    debugButton.AutoButtonColor = true
    debugButton.Parent = screenGui

    local dragging, dragStart, startPos
    debugButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = debugButton.Position
        end
    end)
    debugButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    debugButton.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local delta = input.Position - dragStart
            debugButton.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local debugFrame = Instance.new("Frame")
    debugFrame.Size = UDim2.new(0, 370, 0, 470)
    debugFrame.Position = UDim2.new(0.5, -185, 0.5, -235)
    debugFrame.BackgroundColor3 = Color3.fromRGB(245, 245, 255)
    debugFrame.Visible = false
    debugFrame.Active = true
    debugFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    debugFrame.Parent = screenGui
    debugFrame.BorderSizePixel = 0
    debugFrame.BackgroundTransparency = 0.12
    debugFrame.ClipsDescendants = true

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 36)
    title.BackgroundTransparency = 1
    title.Text = "调试工具"
    title.Font = Enum.Font.GothamBold
    title.TextSize = 28
    title.TextColor3 = Color3.fromRGB(35,55,112)
    title.Parent = debugFrame

    debugButton.MouseButton1Click:Connect(function()
        debugFrame.Visible = not debugFrame.Visible
    end)

    screenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

createDebugUI()

-- 基础信息显示
local function createBaseInfo(debugFrame)
    local info = {
        ["玩家人数"] = #Players:GetPlayers(),
        ["服务器Ping"] = math.random(40,90),
        ["服务器时间"] = os.date("%H:%M:%S")
    }

    local infoBoxes = {}
    local yIndex = 0
    for k,v in pairs(info) do
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 140, 0, 40)
        label.Position = UDim2.new(0, 16, 0, 52 + yIndex * 44)
        label.BackgroundTransparency = 1
        label.Text = k
        label.Font = Enum.Font.Gotham
        label.TextSize = 20
        label.TextColor3 = Color3.fromRGB(30,30,60)
        label.Parent = debugFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 130, 0, 32)
        box.Position = UDim2.new(0, 166, 0, 58 + yIndex * 44)
        box.BackgroundColor3 = Color3.fromRGB(235,235,255)
        box.Text = tostring(v)
        box.Font = Enum.Font.Gotham
        box.TextSize = 18
        box.TextColor3 = Color3.fromRGB(50,50,90)
        box.Parent = debugFrame
        box.ClearTextOnFocus = false
        infoBoxes[k] = box

        yIndex = yIndex + 1
    end

    RunService.RenderStepped:Connect(function()
        infoBoxes["玩家人数"].Text = tostring(#Players:GetPlayers())
        infoBoxes["服务器时间"].Text = os.date("%H:%M:%S")
        if not infoBoxes["服务器Ping"]:IsFocused() then
            infoBoxes["服务器Ping"].Text = tostring(math.random(50,80))
        end
    end)
end

-- 速度/跳跃数值调试功能
local function createValueAdjust(debugFrame)
    local speed = 16
    local jump = 50

    local function applyToChar()
        local char = LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.WalkSpeed = speed
                hum.JumpPower = jump
            end
        end
    end

    local function makeAdjustRow(name, default, min, max, yPos, onChange)
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 80, 0, 32)
        label.Position = UDim2.new(0, 16, 0, yPos)
        label.BackgroundTransparency = 1
        label.Text = name
        label.Font = Enum.Font.Gotham
        label.TextSize = 18
        label.TextColor3 = Color3.fromRGB(30,30,60)
        label.Parent = debugFrame

        local minus = Instance.new("TextButton")
        minus.Size = UDim2.new(0, 28, 0, 28)
        minus.Position = UDim2.new(0, 104, 0, yPos)
        minus.Text = "-"
        minus.Font = Enum.Font.GothamBold
        minus.TextSize = 24
        minus.BackgroundColor3 = Color3.fromRGB(220,200,200)
        minus.TextColor3 = Color3.fromRGB(70,40,40)
        minus.Parent = debugFrame

        local box = Instance.new("TextBox")
        box.Size = UDim2.new(0, 68, 0, 28)
        box.Position = UDim2.new(0, 136, 0, yPos)
        box.BackgroundColor3 = Color3.fromRGB(235,235,255)
        box.Text = tostring(default)
        box.Font = Enum.Font.Gotham
        box.TextSize = 18
        box.TextColor3 = Color3.fromRGB(50,50,90)
        box.Parent = debugFrame
        box.ClearTextOnFocus = false

        local plus = Instance.new("TextButton")
        plus.Size = UDim2.new(0, 28, 0, 28)
        plus.Position = UDim2.new(0, 208, 0, yPos)
        plus.Text = "+"
        plus.Font = Enum.Font.GothamBold
        plus.TextSize = 24
        plus.BackgroundColor3 = Color3.fromRGB(220,245,220)
        plus.TextColor3 = Color3.fromRGB(40,70,40)
        plus.Parent = debugFrame

        local value = default

        local function refresh()
            box.Text = tostring(math.floor(value))
            onChange(value)
        end

        minus.MouseButton1Click:Connect(function()
            value = math.max(min, value - 1)
            refresh()
        end)
        plus.MouseButton1Click:Connect(function()
            value = math.min(max, value + 1)
            refresh()
        end)
        box.FocusLost:Connect(function(enter)
            local num = tonumber(box.Text)
            if num then
                value = math.clamp(num, min, max)
                refresh()
            else
                box.Text = tostring(value)
            end
        end)
        refresh()
    end

    -- 调试板：速度与跳跃
    makeAdjustRow("速度", speed, 1, 120, 192, function(v)
        speed = v
        applyToChar()
    end)
    makeAdjustRow("跳跃", jump, 10, 300, 232, function(v)
        jump = v
        applyToChar()
    end)

    -- 重生时应用设置
    LocalPlayer.CharacterAdded:Connect(applyToChar)
    applyToChar()
end

-- Infinite Yield风格功能区（第三段1/2）

local flyEnabled = false
local flySpeed = 3
local noclipEnabled = false
local espEnabled = false
local flingEnabled = false

-- WalkFling（甩飞）功能
local function enableFling()
    local char = LocalPlayer.Character
    if char and char.PrimaryPart then
        flingEnabled = true
        local bp = Instance.new("BodyAngularVelocity")
        bp.MaxTorque = Vector3.new(1e7,1e7,1e7)
        bp.AngularVelocity = Vector3.new(0,9999,0)
        bp.Parent = char.PrimaryPart
        char.PrimaryPart.CanCollide = true
        wait(0.4)
        bp:Destroy()
        flingEnabled = false
    end
end

-- Fly（飞行）功能以及速度调节
local flyConnection
local function setFly(state)
    flyEnabled = state
    if flyEnabled then
        local char = LocalPlayer.Character
        if not char or not char.PrimaryPart then return end
        local root = char.PrimaryPart
        
        flyConnection = RunService.RenderStepped:Connect(function()
            local moveDir = LocalPlayer:GetMouse().Hit.LookVector
            root.Velocity = moveDir * flySpeed * 10 + Vector3.new(0,2,0)
        end)
    else
        if flyConnection then flyConnection:Disconnect() flyConnection = nil end
        local char = LocalPlayer.Character
        if char and char.PrimaryPart then
            char.PrimaryPart.Velocity = Vector3.new(0,0,0)
        end
    end
end

-- 飞行速度调节UI
local function makeFlySpeedBox(parent, yPos)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0,60,0,28)
    label.Position = UDim2.new(0,16,0,yPos)
    label.BackgroundTransparency = 1
    label.Text = "飞行速度"
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextColor3 = Color3.fromRGB(40,60,90)
    label.Parent = parent

    local minus = Instance.new("TextButton")
    minus.Size = UDim2.new(0,24,0,24)
    minus.Position = UDim2.new(0,80,0,yPos)
    minus.Text = "-"
    minus.Font = Enum.Font.GothamBold
    minus.TextSize = 18
    minus.BackgroundColor3 = Color3.fromRGB(220,200,200)
    minus.TextColor3 = Color3.fromRGB(70,40,40)
    minus.Parent = parent

    local box = Instance.new("TextBox")
    box.Size = UDim2.new(0,40,0,24)
    box.Position = UDim2.new(0,110,0,yPos)
    box.BackgroundColor3 = Color3.fromRGB(235,235,255)
    box.Text = tostring(flySpeed)
    box.Font = Enum.Font.Gotham
    box.TextSize = 16
    box.TextColor3 = Color3.fromRGB(50,50,90)
    box.Parent = parent
    box.ClearTextOnFocus = false

    local plus = Instance.new("TextButton")
    plus.Size = UDim2.new(0,24,0,24)
    plus.Position = UDim2.new(0,156,0,yPos)
    plus.Text = "+"
    plus.Font = Enum.Font.GothamBold
    plus.TextSize = 18
    plus.BackgroundColor3 = Color3.fromRGB(220,245,220)
    plus.TextColor3 = Color3.fromRGB(40,70,40)
    plus.Parent = parent

    local function refresh()
        box.Text = tostring(flySpeed)
    end

    minus.MouseButton1Click:Connect(function()
        flySpeed = math.max(1, flySpeed - 1)
        refresh()
    end)
    plus.MouseButton1Click:Connect(function()
        flySpeed = flySpeed + 1
        refresh()
    end)
    box.FocusLost:Connect(function()
        local num = tonumber(box.Text)
        if num then flySpeed = math.max(1, num) refresh() else box.Text = tostring(flySpeed) end
    end)
    refresh()
end

-- Noclip（穿墙）功能
local noclipConnection
local function setNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                for _,v in pairs(char:GetDescendants()) do
                    if v:IsA("BasePart") then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then noclipConnection:Disconnect() noclipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _,v in pairs(char:GetDescendants()) do
                if v:IsA("BasePart") then
                    v.CanCollide = true
                end
            end
        end
    end
end

-- ESP（玩家高亮）功能
local espConnections = {}
local function setESP(state)
    espEnabled = state
    if espEnabled then
        for _,plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
                local adorn = Instance.new("BillboardGui")
                adorn.Size = UDim2.new(0,100,0,20)
                adorn.Adornee = plr.Character.Head
                adorn.Name = "NameESP"
                adorn.AlwaysOnTop = true
                adorn.Parent = plr.Character.Head

                local txt = Instance.new("TextLabel", adorn)
                txt.Size = UDim2.new(1,0,1,0)
                txt.BackgroundTransparency = 1
                txt.Text = plr.Name
                txt.TextColor3 = Color3.fromRGB(255,80,65)
                txt.TextScaled = true
                espConnections[plr] = adorn
            end
        end
    else
        for plr, adorn in pairs(espConnections) do
            if adorn and adorn.Parent then adorn:Destroy() end
        end
        espConnections = {}
    end
end

-- ===== UI区块，用于添加到你的debugFrame =====
local function createCommandButtons(debugFrame)
    local y = 60

    -- WalkFling 按钮
    local flingBtn = Instance.new("TextButton")
    flingBtn.Size = UDim2.new(0,88,0,32)
    flingBtn.Position = UDim2.new(0,20,0,y)
    flingBtn.Text = "WalkFling"
    flingBtn.Font = Enum.Font.GothamBold
    flingBtn.TextSize = 15
    flingBtn.BackgroundColor3 = Color3.fromRGB(255,215,180)
    flingBtn.TextColor3 = Color3.fromRGB(60,32,32)
    flingBtn.Parent = debugFrame
    flingBtn.MouseButton1Click:Connect(function()
        enableFling()
    end)

    -- Fly 开关
    local flyToggle = Instance.new("TextButton")
    flyToggle.Size = UDim2.new(0,64,0,28)
    flyToggle.Position = UDim2.new(0,124,0,y)
    flyToggle.Text = "Fly[关]"
    flyToggle.Font = Enum.Font.GothamBold
    flyToggle.TextSize = 13
    flyToggle.BackgroundColor3 = Color3.fromRGB(200,245,255)
    flyToggle.TextColor3 = Color3.fromRGB(28,80,70)
    flyToggle.Parent = debugFrame
    flyToggle.MouseButton1Click:Connect(function()
        flyEnabled = not flyEnabled
        setFly(flyEnabled)
        flyToggle.Text = flyEnabled and "Fly[开]" or "Fly[关]"
    end)
    -- 飞行速度调节（调用之前的 makeFlySpeedBox 函数）
    makeFlySpeedBox(debugFrame, y+36)

    -- Noclip 开关
    local noclipToggle = Instance.new("TextButton")
    noclipToggle.Size = UDim2.new(0,80,0,28)
    noclipToggle.Position = UDim2.new(0,20,0,y+80)
    noclipToggle.Text = "Noclip[关]"
    noclipToggle.Font = Enum.Font.GothamBold
    noclipToggle.TextSize = 13
    noclipToggle.BackgroundColor3 = Color3.fromRGB(255,235,200)
    noclipToggle.TextColor3 = Color3.fromRGB(80,40,25)
    noclipToggle.Parent = debugFrame
    noclipToggle.MouseButton1Click:Connect(function()
        noclipEnabled = not noclipEnabled
        setNoclip(noclipEnabled)
        noclipToggle.Text = noclipEnabled and "Noclip[开]" or "Noclip[关]"
    end)

    -- ESP 开关
    local espToggle = Instance.new("TextButton")
    espToggle.Size = UDim2.new(0,80,0,28)
    espToggle.Position = UDim2.new(0,120,0,y+80)
    espToggle.Text = "ESP[关]"
    espToggle.Font = Enum.Font.GothamBold
    espToggle.TextSize = 13
    espToggle.BackgroundColor3 = Color3.fromRGB(220,200,255)
    espToggle.TextColor3 = Color3.fromRGB(60,40,120)
    espToggle.Parent = debugFrame
    espToggle.MouseButton1Click:Connect(function()
        espEnabled = not espEnabled
        setESP(espEnabled)
        espToggle.Text = espEnabled and "ESP[开]" or "ESP[关]"
    end)
end

-- 最后别忘了在创建完 debugFrame 后调用： createCommandButtons(debugFrame)
