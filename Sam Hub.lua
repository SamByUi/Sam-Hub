-- Arceus X Neo 兼容加载
local function LoadRayfield()
    local success, result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source", true))()
    end)
    if not success then
        success, result = pcall(function()
            return loadstring(readfile("Rayfield.lua"))() -- 适配本地文件加载（Arceus支持）
        end)
    end
    return success and result or nil
end

local Rayfield = LoadRayfield()
if not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "加载失败",
        Text = "请确保Rayfield文件已缓存或网络正常",
        Duration = 8
    })
    return
end

-- 创建主窗口（完全适配移动界面）
local Window = Rayfield:CreateWindow({
    Name = "Sam Hub",
    LoadingTitle = "Sam Hub",
    LoadingSubtitle = "加载中...",
    ConfigurationSaving = {Enabled = false}, -- 关闭文件写入（Arceus限制）
    Discord = {Enabled = false},
    KeySystem = false,
    MobileOptions = { -- 移动适配参数
        ScreenPosition = UDim2.new(0.5, 0, 0.5, 0),
        ScreenSize = UDim2.new(0.8, 0, 0.8, 0)
    }
})

local PlayerTab = Window:CreateTab("玩家", "rbxassetid://10728857182") -- 图标适配
local ServerTab = Window:CreateTab("服务器", "rbxassetid://10728857182")

-- 玩家功能区（基础属性 - 适配触屏操作）
PlayerTab:CreateSection("基础属性")

-- 1. 跳跃高度调节
PlayerTab:CreateSlider({
    Name = "跳跃高度",
    Range = {1, 10}, -- 降低范围，适合触屏滑动
    Increment = 0.5,
    Suffix = "倍",
    CurrentValue = 1,
    Callback = function(Value)
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.JumpPower = 50 * Value
            Rayfield:Notify({Title = "设置", Content = "跳跃: "..Value.."倍", Type = "info"})
        end
    end
})

-- 2. 移动速度调节
PlayerTab:CreateSlider({
    Name = "移动速度",
    Range = {1, 8},
    Increment = 0.5,
    Suffix = "倍",
    CurrentValue = 1,
    Callback = function(Value)
        local plr = game.Players.LocalPlayer
        if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
            plr.Character.Humanoid.WalkSpeed = 16 * Value
            Rayfield:Notify({Title = "设置", Content = "速度: "..Value.."倍", Type = "info"})
        end
    end
})

-- 玩家功能区（动作与状态 - 简化逻辑）
PlayerTab:CreateSection("动作控制")

-- 3. 旋转控制
local isRotating = false
PlayerTab:CreateButton({
    Name = "旋转开关",
    Callback = function()
        isRotating = not isRotating
        local plr = game.Players.LocalPlayer
        
        if isRotating then
            Rayfield:Notify({Title = "旋转", Content = "已开启", Type = "success"})
            task.spawn(function()
                while isRotating and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") do
                    plr.Character.HumanoidRootPart.CFrame *= CFrame.Angles(0, math.rad(30), 0) -- 降低速度，避免卡顿
                    task.wait(0.05) -- 适配移动帧率
                end
            end)
        else
            Rayfield:Notify({Title = "旋转", Content = "已关闭", Type = "error"})
        end
    end
})

-- 4. 飞行控制（Arceus触屏适配）
local isFlying = false
PlayerTab:CreateButton({
    Name = "飞行开关",
    Callback = function()
        isFlying = not isFlying
        local plr = game.Players.LocalPlayer
        local UIS = game:GetService("UserInputService")
        
        if isFlying then
            Rayfield:Notify({Title = "飞行", Content = "已开启", Type = "success"})
            task.spawn(function()
                while isFlying and plr.Character do
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    local root = plr.Character:FindFirstChild("HumanoidRootPart")
                    if hum and root then
                        hum.PlatformStand = true
                        local dir = UIS:GetMovementVector()
                        root.Velocity = Vector3.new(dir.X*30, dir.Y*30, 0) -- 简化移动，适配触屏摇杆
                    end
                    task.wait(0.05)
                end
                if plr.Character then
                    local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                    if hum then hum.PlatformStand = false end
                end
            end)
        else
            Rayfield:Notify({Title = "飞行", Content = "已关闭", Type = "error"})
        end
    end
})

-- 5. 血量修改
PlayerTab:CreateTextBox({
    Name = "修改血量",
    PlaceholderText = "输入数值",
    Callback = function(Text)
        local hp = tonumber(Text)
        if hp and hp > 0 then
            local plr = game.Players.LocalPlayer
            if plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") then
                local hum = plr.Character.Humanoid
                hum.MaxHealth, hum.Health = hp, hp
                Rayfield:Notify({Title = "血量", Content = "已设置为 "..hp, Type = "success"})
            end
        else
            Rayfield:Notify({Title = "错误", Content = "请输入数字", Type = "error"})
        end
    end
})

-- 6. ESP显示（轻量化版本）
local espOn = false
PlayerTab:CreateToggle({
    Name = "ESP显示",
    CurrentValue = false,
    Callback = function(v)
        espOn = v
        if espOn then
            Rayfield:Notify({Title = "ESP", Content = "已开启", Type = "success"})
            task.spawn(function()
                while espOn do
                    for _, p in ipairs(game.Players:GetPlayers()) do
                        if p ~= game.Players.LocalPlayer and p.Character then
                            local h = p.Character:FindFirstChild("Head")
                            if h then h.Transparency = 0.7 end
                        end
                    end
                    task.wait(0.2) -- 降低刷新频率，减少卡顿
                end
                for _, p in ipairs(game.Players:GetPlayers()) do
                    if p.Character then
                        local h = p.Character:FindFirstChild("Head")
                        if h then h.Transparency = 0 end
                    end
                end
            end)
        else
            Rayfield:Notify({Title = "ESP", Content = "已关闭", Type = "error"})
        end
    end
})

-- 服务器功能区（优化性能）
ServerTab:CreateSection("服务器设置")

-- 1. 汉堡天空箱（简化实现）
local skyboxOn = false
local originalSky = {}
ServerTab:CreateButton({
    Name = "汉堡天空箱",
    Callback = function()
        skyboxOn = not skyboxOn
        local lighting = game:GetService("Lighting")
        
        if skyboxOn then
            originalSky = {
                B = lighting.Brightness,
                T = lighting.ColorShift_Top,
                Bt = lighting.ColorShift_Bottom,
                S = {lighting.SkyboxBk, lighting.SkyboxDn, lighting.SkyboxFt, lighting.SkyboxLf, lighting.SkyboxRt, lighting.SkyboxUp}
            }
            local tex = "rbxassetid://130721971"
            lighting.Brightness = 1.5
            lighting.ColorShift_Top = Color3.new(1,1,1)
            lighting.ColorShift_Bottom = Color3.new(1,1,1)
            lighting.SkyboxBk, lighting.SkyboxDn, lighting.SkyboxFt, lighting.SkyboxLf, lighting.SkyboxRt, lighting.SkyboxUp = tex, tex, tex, tex, tex, tex
            Rayfield:Notify({Title = "天空箱", Content = "已切换", Type = "success"})
        else
            lighting.Brightness = originalSky.B
            lighting.ColorShift_Top = originalSky.T
            lighting.ColorShift_Bottom = originalSky.Bt
            lighting.SkyboxBk, lighting.SkyboxDn, lighting.SkyboxFt, lighting.SkyboxLf, lighting.SkyboxRt, lighting.SkyboxUp = unpack(originalSky.S)
            Rayfield:Notify({Title = "天空箱", Content = "已恢复", Type = "info"})
        end
    end
})

-- 2. 全局火焰（限制范围，避免崩溃）
local fireOn = false
local fires = {}
ServerTab:CreateButton({
    Name = "全局火焰",
    Callback = function()
        fireOn = not fireOn
        
        if fireOn then
            for _, part in ipairs(workspace:GetDescendants()) do
                if (part:IsA("Part") or part:IsA("MeshPart")) and #fires < 50 then -- 限制数量
                    local f = Instance.new("Fire")
                    f.Heat = 3
                    f.Size = 1
                    f.Parent = part
                    table.insert(fires, f)
                end
            end
            Rayfield:Notify({Title = "火焰", Content = "已开启", Type = "success"})
        else
            for _, f in ipairs(fires) do
                if f then f:Destroy() end
            end
            fires = {}
            Rayfield:Notify({Title = "火焰", Content = "已关闭", Type = "info"})
        end
    end
})

-- 3. 执行Infinite Yield（适配Arceus网络）
ServerTab:CreateButton({
    Name = "加载Infinite Yield",
    Callback = function()
        Rayfield:Notify({Title = "加载中", Content = "请稍候...", Type = "info"})
        task.spawn(function()
            local success = pcall(function()
                loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
            end)
            if success then
                Rayfield:Notify({Title = "成功", Content = "已加载", Type = "success"})
            else
                Rayfield:Notify({Title = "失败", Content = "请重试", Type = "error"})
            end
        end)
    end
})

Rayfield:Notify({
    Title = "完成",
    Content = "所有功能已加载",
    Duration = 3,
    Type = "success"
})
