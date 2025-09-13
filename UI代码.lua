local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local speedLevel = 0
local jumpLevel = 0
local isFlying = false
local defaultSpeed = Humanoid.WalkSpeed
local defaultJump = Humanoid.JumpPower

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MobileHackUI"
ScreenGui.Parent = Player.PlayerGui
ScreenGui.IgnoreGuiInset = true

local Background = Instance.new("Frame")
Background.Name = "Background"
Background.Size = UDim2.new(1,0,1,0)
Background.BackgroundTransparency = 1
Background.Parent = ScreenGui

local Gradient = Instance.new("UIGradient")
Gradient.Color = ColorSequence.new(Color3.fromHex("#1A1E3B"), Color3.fromHex("#4A266A"))
Gradient.Rotation = 90
Gradient.Parent = Background

local ParticleFrame = Instance.new("Frame")
ParticleFrame.Name = "Particles"
ParticleFrame.Size = UDim2.new(1,0,1,0)
ParticleFrame.BackgroundTransparency = 1
ParticleFrame.Parent = Background

for i=1,20 do
    local Particle = Instance.new("ImageLabel")
    Particle.Name = "Particle"
    Particle.Size = UDim2.new(0, math.random(5,15), 0, math.random(5,15))
    Particle.Position = UDim2.new(math.random(0,100)/100,0,math.random(0,100)/100,0)
    Particle.BackgroundTransparency = 1
    Particle.Image = "rbxassetid://154966922"
    Particle.ImageColor3 = Color3.fromHex("#00FFFF"):Lerp(Color3.fromHex("#9900FF"), math.random(0,100)/100)
    Particle.ImageTransparency = 0.8 + math.random(0,20)/100
    Particle.Parent = ParticleFrame

    local TweenService = game:GetService("TweenService")
    local TweenInfo = TweenInfo.new(math.random(8,15), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
    local TweenGoal = {
        Position = UDim2.new(Particle.Position.X.Scale, 0, -0.1, 0),
        ImageTransparency = 1
    }
    TweenService:Create(Particle, TweenInfo, TweenGoal):Play()

    task.delay(math.random(8,15), function()
        while wait(math.random(8,15)) do
            Particle.Position = UDim2.new(math.random(0,100)/100,0,1.1,0)
            Particle.ImageTransparency = 0.8 + math.random(0,20)/100
        end
    end)
end

local MainPanel = Instance.new("Frame")
MainPanel.Name = "MainPanel"
MainPanel.Size = UDim2.new(0.85,0,0.6,0)
MainPanel.Position = UDim2.new(0.075,0,0.2,0)
MainPanel.BackgroundColor3 = Color3.new(0,0,0)
MainPanel.BackgroundTransparency = 0.2
MainPanel.CornerRadius = UDim.new(0,20)
MainPanel.Parent = ScreenGui

local Stroke = Instance.new("UIStroke")
Stroke.Thickness = 2
Stroke.Parent = MainPanel
local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Parent = Stroke

local strokeColorTween = game:GetService("TweenService"):Create(
    StrokeGradient,
    TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Color = ColorSequence.new(Color3.fromHex("#00FFFF"), Color3.fromHex("#9900FF"))}
)
strokeColorTween:Play()

local PlayerInfo = Instance.new("Frame")
PlayerInfo.Name = "PlayerInfo"
PlayerInfo.Size = UDim2.new(0.9,0,0.15,0)
PlayerInfo.Position = UDim2.new(0.05,0,0.02,0)
PlayerInfo.BackgroundTransparency = 1
PlayerInfo.Parent = MainPanel

local Avatar = Instance.new("ImageLabel")
Avatar.Name = "Avatar"
Avatar.Size = UDim2.new(0,40,0,40)
Avatar.Position = UDim2.new(0,0,0.5,0)
Avatar.AnchorPoint = Vector2.new(0,0.5)
Avatar.BackgroundTransparency = 1
Avatar.Image = Players:GetUserThumbnailAsync(Player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.CornerRadius = UDim.new(1,0)
Avatar.Parent = PlayerInfo

local AvatarGlow = Instance.new("UIGlow")
AvatarGlow.GlowColor = Color3.new(1,1,1)
AvatarGlow.Radius = 5
AvatarGlow.Parent = Avatar

local NameLabel = Instance.new("TextLabel")
NameLabel.Name = "NameLabel"
NameLabel.Size = UDim2.new(1, -50, 0.5, 0)
NameLabel.Position = UDim2.new(0,50,0,0)
NameLabel.BackgroundTransparency = 1
NameLabel.Text = Player.Name
NameLabel.TextColor3 = Color3.new(1,1,1)
NameLabel.TextScaled = true
NameLabel.Font = Enum.Font.GothamBold
NameLabel.Parent = PlayerInfo

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, -50, 0.5, 0)
StatusLabel.Position = UDim2.new(0,50,0.5,0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "就绪"
StatusLabel.TextColor3 = Color3.new(0.8,0.8,0.8)
StatusLabel.TextScaled = true
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = PlayerInfo

local function createButton(name, colorHex, yPos, clickFunc)
    local Button = Instance.new("TextButton")
    Button.Name = name
    Button.Size = UDim2.new(0.8,0,0.18,0)
    Button.Position = UDim2.new(0.1,0,yPos,0)
    Button.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    Button.BackgroundTransparency = 0.4
    Button.CornerRadius = UDim.new(0,12)
    Button.Text = name
    Button.TextColor3 = Color3.new(1,1,1)
    Button.TextScaled = true
    Button.Font = Enum.Font.GothamBold
    Button.Parent = MainPanel

    local ButtonGlow = Instance.new("UIGlow")
    ButtonGlow.GlowColor = Color3.fromHex(colorHex)
    ButtonGlow.Radius = 8
    ButtonGlow.Parent = Button

    local FlowBand = Instance.new("Frame")
    FlowBand.Name = "FlowBand"
    FlowBand.Size = UDim2.new(2,0,1,0)
    FlowBand.Position = UDim2.new(-1,0,0,0)
    FlowBand.BackgroundTransparency = 0.7
    FlowBand.BackgroundColor3 = Color3.fromHex(colorHex)
    FlowBand.Parent = Button

    local FlowGradient = Instance.new("UIGradient")
    FlowGradient.Color = ColorSequence.new(Color3.fromHex(colorHex), Color3.fromHex(colorHex):Lerp(Color3.new(1,1,1), 0.5))
    FlowGradient.Rotation = 90
    FlowGradient.Parent = FlowBand

    game:GetService("TweenService"):Create(
        FlowBand,
        TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
        {Position = UDim2.new(1,0,0,0)}
    ):Play()

    Button.MouseButton1Click:Connect(function()
        if UIS.TouchEnabled then
            game:GetService("HapticService"):GetMotor(Enum.UserInputType.Touch, Enum.VibrationMotor.LeftHand):Vibrate(0.1)
        end
        local tween = game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0.78,0,0.17,0)}
        )
        tween:Play()
        tween.Completed:Wait()
        game:GetService("TweenService"):Create(
            Button,
            TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut),
            {Size = UDim2.new(0.8,0,0.18,0)}
        ):Play()
        clickFunc(Button)
    end)

    return Button
end

local SpeedButton = createButton("速度", "#00FF99", 0.22, function(btn)
    speedLevel = (speedLevel + 1) % 3
    if speedLevel == 0 then
        Humanoid.WalkSpeed = defaultSpeed
        btn.BackgroundTransparency = 0.4
        btn.Text = "速度"
        StatusLabel.Text = "就绪"
    elseif speedLevel == 1 then
        Humanoid.WalkSpeed = defaultSpeed * 2
        btn.BackgroundTransparency = 0.3
        btn.Text = "速度 (2倍)"
        StatusLabel.Text = "高速模式1级"
    else
        Humanoid.WalkSpeed = defaultSpeed * 3
        btn.BackgroundTransparency = 0.3
        local Stripes = Instance.new("UIGradient")
        Stripes.Color = ColorSequence.new(Color3.fromHex("#00FF99"), Color3.fromHex("#00FF99"), Color3.new(0.2,0.2,0.2), Color3.new(0.2,0.2,0.2))
        Stripes.Offset = Vector2.new(0,0)
        Stripes.Rotation = 45
        Stripes.Parent = btn
        btn.Text = "速度 (3倍)"
        StatusLabel.Text = "高速模式2级"
    end
end)

local JumpButton = createButton("跳跃", "#FFFF00", 0.43, function(btn)
    jumpLevel = (jumpLevel + 1) % 3
    game:GetService("TweenService"):Create(
        btn,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.1,0,btn.Position.Y.Scale - 0.02,0)}
    ):Play()
    task.wait(0.2)
    game:GetService("TweenService"):Create(
        btn,
        TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
        {Position = UDim2.new(0.1,0,btn.Position.Y.Scale + 0.02,0)}
    ):Play()

    if jumpLevel == 0 then
        Humanoid.JumpPower = defaultJump
        btn.Text = "跳跃"
        StatusLabel.Text = "就绪"
    elseif jumpLevel == 1 then
        Humanoid.JumpPower = defaultJump * 1.5
        btn.Text = "跳跃 (1.5倍)"
        StatusLabel.Text = "高跳模式1级"
    else
        Humanoid.JumpPower = defaultJump * 2
        btn.Text = "跳跃 (2倍)"
        StatusLabel.Text = "高跳模式2级"
    end
end)

local FlyButton = createButton("飞行", "#0099FF", 0.64, function(btn)
    isFlying = not isFlying
    Humanoid.Fly = isFlying
    if isFlying then
        btn.BackgroundColor3 = Color3.fromHex("#0099FF"):Lerp(Color3.new(0.2,0.2,0.2), 0.5)
        btn.BackgroundTransparency = 0.5
        btn.Text = "飞行 (开启)"
        StatusLabel.Text = "飞行中"
        local glowTween = game:GetService("TweenService"):Create(
            btn.UIGlow,
            TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Radius = 12}
        )
        glowTween:Play()
    else
        btn.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
        btn.BackgroundTransparency = 0.4
        btn.Text = "飞行 (关闭)"
        StatusLabel.Text = "就绪"
        btn.UIGlow.Radius = 8
    end
end)

local ResetButton = createButton("重置", "#FF3333", 0.85, function(btn)
    for i=1,3 do
        btn.BackgroundTransparency = 0.2
        task.wait(0.1)
        btn.BackgroundTransparency = 0.6
        task.wait(0.1)
    end
    btn.BackgroundTransparency = 0.4

    speedLevel = 0
    jumpLevel = 0
    isFlying = false
    Humanoid.WalkSpeed = defaultSpeed
    Humanoid.JumpPower = defaultJump
    Humanoid.Fly = false

    SpeedButton.Text = "速度"
    SpeedButton.BackgroundTransparency = 0.4
    if SpeedButton:FindFirstChild("UIGradient") then SpeedButton.UIGradient:Destroy() end
    
    JumpButton.Text = "跳跃"
    FlyButton.Text = "飞行 (关闭)"
    FlyButton.BackgroundColor3 = Color3.new(0.2,0.2,0.2)
    FlyButton.BackgroundTransparency = 0.4
    FlyButton.UIGlow.Radius = 8

    StatusLabel.Text = "已重置"
end)

MainPanel.Position = UDim2.new(0.075,0,1.3,0)
MainPanel.BackgroundTransparency = 1
game:GetService("TweenService"):Create(
    MainPanel,
    TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    {Position = UDim2.new(0.075,0,0.2,0), BackgroundTransparency = 0.2}
):Play()

Player.CharacterAdded:Connect(function(newChar)
    Character = newChar
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
    defaultSpeed = Humanoid.WalkSpeed
    defaultJump = Humanoid.JumpPower
    ResetButton.MouseButton1Click:Fire()
end)