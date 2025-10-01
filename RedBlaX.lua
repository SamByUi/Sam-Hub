local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
if not player then
    player = Players.PlayerAdded:Wait()
end

local function CreateUI()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "CoolMobileUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = player:WaitForChild("PlayerGui")
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.Position = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundColor3 = Color3.new(0.05, 0.05, 0.05)
    mainFrame.BackgroundTransparency = 0.15
    mainFrame.BorderSizePixel = 0
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 20)
    uiCorner.Parent = mainFrame
    
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.new(1, 0, 0)
    uiStroke.Thickness = 2
    uiStroke.Transparency = 0.3
    uiStroke.Parent = mainFrame

local backgroundParticles = Instance.new("Frame")
backgroundParticles.Name = "BackgroundParticles"
backgroundParticles.Size = UDim2.new(1, 0, 1, 0)
backgroundParticles.Position = UDim2.new(0, 0, 0, 0)
backgroundParticles.BackgroundTransparency = 1
backgroundParticles.Parent = mainFrame

for i = 1, 15 do
    local particle = Instance.new("Frame")
    particle.Name = "Particle" .. i
    particle.Size = UDim2.new(0, math.random(4, 12), 0, math.random(4, 12))
    particle.Position = UDim2.new(0, math.random(0, 500), 0, math.random(0, 800))
    particle.BackgroundColor3 = Color3.new(1, 0, 0)
    particle.BackgroundTransparency = 0.7
    particle.BorderSizePixel = 0
    particle.Parent = backgroundParticles
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
end

local menuBar = Instance.new("Frame")
menuBar.Name = "MenuBar"
menuBar.Size = UDim2.new(1, -40, 0, 60)
menuBar.Position = UDim2.new(0, 20, 0, 20)
menuBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
menuBar.BackgroundTransparency = 0.3
menuBar.BorderSizePixel = 0
menuBar.Parent = mainFrame

local menuCorner = Instance.new("UICorner")
menuCorner.CornerRadius = UDim.new(0, 15)
menuCorner.Parent = menuBar

local menuStroke = Instance.new("UIStroke")
menuStroke.Color = Color3.new(1, 0.2, 0.2)
menuStroke.Thickness = 1.5
menuStroke.Transparency = 0.2
menuStroke.Parent = menuBar

local menuGlow = Instance.new("ImageLabel")
menuGlow.Name = "MenuGlow"
menuGlow.Size = UDim2.new(1, 20, 1, 20)
menuGlow.Position = UDim2.new(0, -10, 0, -10)
menuGlow.BackgroundTransparency = 1
menuGlow.Image = "rbxassetid://8992231225"
menuGlow.ImageColor3 = Color3.new(1, 0, 0)
menuGlow.ImageTransparency = 0.8
menuGlow.ScaleType = Enum.ScaleType.Slice
menuGlow.SliceCenter = Rect.new(100, 100, 100, 100)
menuGlow.Parent = menuBar

local byText = Instance.new("TextLabel")
    byText.Name = "ByText"
    byText.Size = UDim2.new(0, 120, 0, 30)
    byText.Position = UDim2.new(0.5, -60, 0.9, 0)
    byText.BackgroundTransparency = 1
    byText.Text = "By Sam"
    byText.TextColor3 = Color3.new(1, 1, 1)
    byText.TextTransparency = 0.6
    byText.TextSize = 18
    byText.Font = Enum.Font.GothamSemibold
    byText.TextStrokeTransparency = 0.8
    byText.Parent = mainFrame
    
    local textGlow = Instance.new("ImageLabel")
    textGlow.Name = "TextGlow"
    textGlow.Size = UDim2.new(1, 20, 1, 20)
    textGlow.Position = UDim2.new(0, -10, 0, -10)
    textGlow.BackgroundTransparency = 1
    textGlow.Image = "rbxassetid://8992231225"
    textGlow.ImageColor3 = Color3.new(1, 0, 0)
    textGlow.ImageTransparency = 0.9
    textGlow.Parent = byText
    
    mainFrame.Parent = screenGui
    return screenGui, mainFrame, backgroundParticles, menuBar, byText
end

local function CreateAnimations(mainFrame, backgroundParticles, menuBar, byText)
    local pulseTween = TweenService:Create(
        menuBar,
        TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.5}
    )
    
    local glowTween = TweenService:Create(
        menuBar:FindFirstChild("MenuGlow"),
        TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true),
        {ImageTransparency = 0.6}
    )
    
    local textPulse = TweenService:Create(
        byText,
        TweenInfo.new(1.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {TextTransparency = 0.3}
    )
    
    local frameGlow = TweenService:Create(
        mainFrame:FindFirstChild("UIStroke"),
        TweenInfo.new(2, Enum.EasingStyle.Circular, Enum.EasingDirection.InOut, -1, true),
        {Transparency = 0.1}
    )
    
    pulseTween:Play()
    glowTween:Play()
    textPulse:Play()
    frameGlow:Play()
    
local particleConnections = {}
    for i, particle in ipairs(backgroundParticles:GetChildren()) do
        if particle:IsA("Frame") then
            local startPos = particle.Position
            local targetX = math.random(-50, 50)
            local targetY = math.random(-50, 50)
            
            local particleTween = TweenService:Create(
                particle,
                TweenInfo.new(math.random(3, 8), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {
                    Position = UDim2.new(
                        startPos.X.Scale, 
                        startPos.X.Offset + targetX,
                        startPos.Y.Scale, 
                        startPos.Y.Offset + targetY
                    ),
                    BackgroundTransparency = math.random(5, 9) / 10
                }
            )
            particleTween:Play()
            table.insert(particleConnections, particleTween)
        end
    end
    
    local rotationConnection
    rotationConnection = RunService.RenderStepped:Connect(function(deltaTime)
        local glow = menuBar:FindFirstChild("MenuGlow")
        if glow then
            glow.Rotation = (glow.Rotation + 10 * deltaTime) % 360
        end
        
        local textGlowEffect = byText:FindFirstChild("TextGlow")
        if textGlowEffect then
            textGlowEffect.Rotation = (textGlowEffect.Rotation - 15 * deltaTime) % 360
        end
    end)
    
    return {
        Pulse = pulseTween,
        Glow = glowTween,
        TextPulse = textPulse,
        FrameGlow = frameGlow,
        Rotation = rotationConnection,
        Particles = particleConnections
    }
end

local function SetupMobileOptimization(screenGui)
    local touchInput = UserInputService.TouchStarted:Connect(function(input)
        local menuBar = screenGui:FindFirstChild("MainFrame"):FindFirstChild("MenuBar")
        if menuBar then
            local clickTween = TweenService:Create(
                menuBar,
                TweenInfo.new(0.1, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, -35, 0, 55)}
            )
            local resetTween = TweenService:Create(
                menuBar,
                TweenInfo.new(0.2, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out),
                {Size = UDim2.new(1, -40, 0, 60)}
            )
            clickTween:Play()
            clickTween.Completed:Connect(function()
                resetTween:Play()
            end)
        end
    end)
    
    return touchInput
end

local function InitializeUI()
    local screenGui, mainFrame, backgroundParticles, menuBar, byText = CreateUI()
    local animations = CreateAnimations(mainFrame, backgroundParticles, menuBar, byText)
    local touchConnection = SetupMobileOptimization(screenGui)
    
    local uiVisible = true
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.H then
            uiVisible = not uiVisible
            mainFrame.Visible = uiVisible
        end
    end)
    
    return {
        GUI = screenGui,
        Animations = animations,
        Connections = {
            Touch = touchConnection,
            Rotation = animations.Rotation
        }
    }
end

local success, result = pcall(InitializeUI)
if not success then
    warn("UI初始化失败: " .. tostring(result))
end