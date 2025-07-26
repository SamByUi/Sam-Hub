local OrionLib = loadstring(game:HttpGet('https://raw.githubusercontent.com/shlexware/Orion/main/source'))()
local Window = OrionLib:MakeWindow({
    Name = "Sam Hub | 手机基础功能Plus",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "SamHubMobilePlus"
})

local Tab = Window:MakeTab({
    Name = "通用基础",
    Icon = "rbxassetid://7734053499",
    PremiumOnly = false
})

Tab:AddSlider({
    Name = "跳跃高度",
    Min = 50,
    Max = 250,
    Default = 50,
    Increment = 10,
    ValueName = "单位",
    Callback = function(val)
        pcall(function()
            local h = game.Players.LocalPlayer.Character.Humanoid
            h.JumpPower = val
        end)
    end
})

Tab:AddSlider({
    Name = "奔跑速度",
    Min = 16,
    Max = 200,
    Default = 16,
    Increment = 2,
    ValueName = "点",
    Callback = function(val)
        pcall(function()
            local h = game.Players.LocalPlayer.Character.Humanoid
            h.WalkSpeed = val
        end)
    end
})

Tab:AddToggle({
    Name = "无限跳跃",
    Default = false,
    Callback = function(Value)
        _G.InfJump = Value
        if Value then
            if not _G.InfJumped then
                _G.InfJumped = true
                game:GetService("UserInputService").JumpRequest:Connect(function()
                    if _G.InfJump then
                        pcall(function()
                            game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                        end)
                    end
                end)
            end
        end
    end
})

Tab:AddToggle({
    Name = "穿墙（Noclip）",
    Default = false,
    Callback = function(Value)
        _G.noclip = Value
        if Value then
            _G.noclipCon = game:GetService("RunService").Stepped:Connect(function()
                if _G.noclip then
                    for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide == true then
                           v.CanCollide = false
                        end
                    end
                end
            end)
        else
            if _G.noclipCon then
                _G.noclipCon:Disconnect()
                _G.noclipCon = nil
            end
            for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                if v:IsA("BasePart") then
                   v.CanCollide = true
                end
            end
        end
    end
})

Tab:AddButton({
    Name = "飞行模式 [按E切换](通用/推荐)",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/acsu123/HOHO_H/main/Fly.lua"))()
    end
})

Tab:AddButton({
    Name = "一键自杀（快速重生）", 
    Callback = function()
        game.Players.LocalPlayer.Character:BreakJoints()
    end
})

Tab:AddButton({
    Name = "恢复默认角色参数",
    Callback = function()
        local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        h.WalkSpeed = 16
        h.JumpPower = 50
    end
})

local AdvTab = Window:MakeTab({
    Name = "进阶功能",
    Icon = "rbxassetid://7733978848",
    PremiumOnly = false
})

AdvTab:AddToggle({
    Name = "自动连跳(Auto Bunny Hop)",
    Default = false,
    Callback = function(Value)
        _G.AHB = Value
        spawn(function()
            while _G.AHB do
                wait(0.35)
                pcall(function()
                    game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState("Jumping")
                end)
            end
        end)
    end
})

AdvTab:AddToggle({
    Name = "防摔落(Always No Fall Damage)",
    Default = false,
    Callback = function(Value)
        _G.Nofall = Value
        spawn(function()
            while _G.Nofall do
                wait(0.3)
                pcall(function()
                    local h = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if h then h:ChangeState(11) end
                end)
            end
        end)
    end
})

AdvTab:AddButton({
    Name = "人物变透明(隐身娱乐)",
    Callback = function()
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0.7
            end
        end
    end
})

AdvTab:AddButton({
    Name = "复原透明效果",
    Callback = function()
        for _,v in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Transparency = 0
            end
        end
    end
})

AdvTab:AddToggle({
    Name = "浮空（悬停空中）",
    Default = false,
    Callback = function(Value)
        _G.FloatSam = Value
        spawn(function()
            while _G.FloatSam do
                wait(0.1)
                local char = game.Players.LocalPlayer.Character
                if char and char:FindFirstChildOfClass("Humanoid") then
                    char.Humanoid.PlatformStand = true
                    char.HumanoidRootPart.Velocity = Vector3.new(0,4,0)
                end
            end
            local char = game.Players.LocalPlayer.Character
            if char and char:FindFirstChildOfClass("Humanoid") then
                char.Humanoid.PlatformStand = false
            end
        end)
    end
})

OrionLib:Init()
