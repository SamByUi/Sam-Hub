local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Rayfield/main/source'))()
local Window = Rayfield:CreateWindow({
    Name = "Sam Hub",
    LoadingTitle = "准备就绪",
    LoadingSubtitle = "欢迎使用",
})

local PlayerTab = Window:CreateTab("玩家功能")
local PlayerSection = PlayerTab:CreateSection("玩家调整")
local EnvTab = Window:CreateTab("环境和脚本")
local EnvSection = EnvTab:CreateSection("环境控制")

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local HRP = character:WaitForChild("HumanoidRootPart")
local defaultSpeed = humanoid.WalkSpeed
local defaultJump = humanoid.JumpPower

local speedSlider = PlayerSection:CreateSlider({
    Name = "速度",
    Range = {16, 100},
    Increment = 1,
    Current = defaultSpeed,
    Callback = function(val)
        humanoid.WalkSpeed = val
    end,
})

local jumpSlider = PlayerSection:CreateSlider({
    Name = "跳跃",
    Range = {50, 200},
    Increment = 10,
    Current = defaultJump,
    Callback = function(val)
        humanoid.JumpPower = val
    end,
})

local resetBtn = PlayerSection:CreateButton({
    Title = "还原",
    Callback = function()
        humanoid.WalkSpeed = defaultSpeed
        humanoid.JumpPower = defaultJump
    end,
})

local flying = false
local flyPart
local flyConnection

local function startFly()
    if flying then return end
    flying = true
    flyPart = Instance.new("Part", workspace)
    flyPart.Anchored = true
    flyPart.Transparency = 1
    flyPart.Position = HRP.Position + Vector3.new(0,3,0)
    flyConnection = game:GetService("RunService").Heartbeat:Connect(function(dt)
        if not flying then return end
        flyPart.Position = flyPart.Position + Vector3.new(0,0,1) * 50 * dt
        HRP.CFrame = CFrame.new(flyPart.Position)
    end)
end

local function stopFly()
    if flyConnection then flyConnection:Disconnect() end
    if flyPart then flyPart:Destroy() end
    flying = false
end

local flyBtn = PlayerSection:CreateButton({
    Title = "开启/关闭飞行",
    Callback = function()
        if not flying then startFly() else stopFly() end
    end,
})

local noclip = false
local function toggleNoclip()
    noclip = not noclip
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = not noclip
        end
    end
end

local noclipBtn = PlayerSection:CreateButton({
    Title = "穿墙（开启/关闭）",
    Callback = toggleNoclip,
})

local teleportSection = Window:CreateTab("瞬移")
local teleportX, teleportY, teleportZ = 0, 10, 0
local teleportBox = teleportSection:CreateBox({
    Title = "输入坐标X,Y,Z",
    PlaceholderText = "例如：0,10,0",
    Callback = function(text)
        local coords = string.split(text, ",")
        if #coords == 3 then
            teleportX = tonumber(coords[1]) or 0
            teleportY = tonumber(coords[2]) or 10
            teleportZ = tonumber(coords[3]) or 0
        end
    end,
})

local teleportBtn = teleportSection:CreateButton({
    Title = "瞬移到输入位置",
    Callback = function()
        HRP.CFrame = CFrame.new(teleportX, teleportY, teleportZ)
    end,
})

local randTeleportBtn = teleportSection:CreateButton({
    Title = "随机瞬移",
    Callback = function()
        local pos = Vector3.new(math.random(-500, 500), math.random(10, 300), math.random(-500, 500))
        HRP.CFrame = CFrame.new(pos)
    end,
})

local changeSkyBtn = EnvSection:CreateButton({
    Title = "切换到汉堡天空",
    Callback = function()
        local sky = Instance.new("Sky", game.Lighting)
        sky.SkyboxBk = "rbxassetid://255576144"
        sky.SkyboxFt = "rbxassetid://255576144"
        sky.SkyboxLf = "rbxassetid://255576144"
        sky.SkyboxRt = "rbxassetid://255576144"
        sky.SkyboxUp = "rbxassetid://255576144"
        sky.SkyboxDn = "rbxassetid://255576144"
    end,
})

local runInfiniteYieldBtn = EnvSection:CreateButton({
    Title = "运行 Infinite Yield",
    Callback = function()
        local infYieldUrl = 'https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/InfiniteYield.lua'
        pcall(function()
            loadstring(game:HttpGet(infYieldUrl))()
        end)
    end,
})
