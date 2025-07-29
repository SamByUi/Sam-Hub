-- 兼容不同执行器的加载方式
local function LoadRayfield()
    local success, result = pcall(function()
        return loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/shlexware/Rayfield/main/source", true))()
    end)
    if not success then
        success, result = pcall(function()
            return loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()
        end)
    end
    if success then
        return result
    else
        warn("无法加载 Rayfield UI: " .. result)
        return nil
    end
end

local Rayfield = LoadRayfield()
if not Rayfield then
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "错误",
        Text = "Rayfield 加载失败，请检查网络或执行器设置",
        Duration = 10
    })
    return
end

-- 创建主窗口
local Window = Rayfield:CreateWindow({
    Name = "Sam Hub",
    LoadingTitle = "Sam Hub",
    LoadingSubtitle = "加载中...",
    ConfigurationSaving = {Enabled = false},
    Discord = {Enabled = false},
    KeySystem = false
})

local PlayerTab = Window:CreateTab("玩家", nil)
local ServerTab = Window:CreateTab("服务器", nil)

-- 玩家功能区 - 基础属性调节
PlayerTab:CreateSection("玩家功能控制")

-- 1. 跳跃高度调节
PlayerTab:CreateSlider({
    Name = "跳跃高度调节",
    Range = {1, 20},
    Increment = 1,
    Suffix = "倍",
    CurrentValue = 1,
    Callback = function(Value)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.JumpPower = 50 * Value
            Rayfield:Notify({Title = "跳跃设置", Content = "已设为 "..Value.." 倍", Type = "info"})
        end
    end
})

-- 2. 移动速度调节
PlayerTab:CreateSlider({
    Name = "移动速度调节",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "倍",
    CurrentValue = 1,
    Callback = function(Value)
        local LocalPlayer = game:GetService("Players").LocalPlayer
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16 * Value
            Rayfield:Notify({Title = "速度设置", Content = "已设为 "..Value.." 倍", Type = "info"})
        end
    end
})

-- 玩家功能区 - 动作控制
-- 3. 旋转控制
local isRotating = false
PlayerTab:CreateButton({
    Name = "旋转控制（顺时针）",
    Callback = function()
        isRotating = not isRotating
        local LocalPlayer = game:GetService("Players").LocalPlayer
        
        if isRotating then
            Rayfield:Notify({Title = "旋转控制", Content = "已开启", Type = "success"})
            task.spawn(function()
                while isRotating and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") do
                    local root = LocalPlayer.Character.HumanoidRootPart
                    root.CFrame *= CFrame.Angles(0, math.rad(50), 0)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({Title = "旋转控制", Content = "已停止", Type = "error"})
        end
    end
})

-- 4. 飞行控制
local isFlying = false
PlayerTab:CreateButton({
    Name = "飞行控制",
    Callback = function()
        isFlying = not isFlying
        local LocalPlayer = game:GetService("Players").LocalPlayer
        local UIS = game:GetService("UserInputService")
        
        if isFlying then
            Rayfield:Notify({Title = "飞行控制", Content = "已开启", Type = "success"})
            task.spawn(function()
                while isFlying and LocalPlayer.Character do
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    local root = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    if humanoid and root then
                        humanoid.PlatformStand = true
                        local moveDir = UIS:GetMovementVector()
                        root.Velocity = Vector3.new(
                            moveDir.X * 50,
                            (UIS:IsKeyDown(Enum.KeyCode.Space) and 50 or UIS:IsKeyDown(Enum.KeyCode.LeftControl) and -50 or 0),
                            moveDir.Y * 50
                        )
                    end
                    task.wait()
                end
                if LocalPlayer.Character then
                    local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                end
            end)
        else
            Rayfield:Notify({Title = "飞行控制", Content = "已关闭", Type = "error"})
        end
    end
})

-- 玩家功能区 - 状态与显示控制
-- 5. 血量修改
PlayerTab:CreateTextBox({
    Name = "血量修改",
    PlaceholderText = "输入血量值",
    Callback = function(Text)
        local health = tonumber(Text)
        if health and health > 0 then
            local LocalPlayer = game:GetService("Players").LocalPlayer
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = LocalPlayer.Character.Humanoid
                humanoid.MaxHealth = health
                humanoid.Health = health
                Rayfield:Notify({Title = "血量设置", Content = "已修改为 "..health, Type = "success"})
            end
        else
            Rayfield:Notify({Title = "错误", Content = "请输入有效数字", Type = "error"})
        end
    end
})

-- 6. ESP显示
local espEnabled = false
PlayerTab:CreateToggle({
    Name = "ESP显示",
    CurrentValue = false,
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            Rayfield:Notify({Title = "ESP", Content = "已开启", Type = "success"})
            task.spawn(function()
                while espEnabled do
                    local LocalPlayer = game:GetService("Players").LocalPlayer
                    for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local root = plr.Character.HumanoidRootPart
                            root.Transparency = 0.5
                        end
                    end
                    task.wait(0.1)
                end
                for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                    if plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                        plr.Character.HumanoidRootPart.Transparency = 0
                    end
                end
            end)
        else
            Rayfield:Notify({Title = "ESP", Content = "已关闭", Type = "error"})
        end
    end
})

-- 服务器功能区
ServerTab:CreateSection("服务器功能控制")

-- 1. 汉堡天空箱
local skyboxChanged = false
local originalSkybox = {}
ServerTab:CreateButton({
    Name = "切换汉堡天空箱",
    Callback = function()
        skyboxChanged = not skyboxChanged
        local Lighting = game:GetService("Lighting")
        
        if skyboxChanged then
            originalSkybox = {
                Brightness = Lighting.Brightness,
                ColorShift_Top = Lighting.ColorShift_Top,
                ColorShift_Bottom = Lighting.ColorShift_Bottom,
                SkyboxBk = Lighting.SkyboxBk,
                SkyboxDn = Lighting.SkyboxDn,
                SkyboxFt = Lighting.SkyboxFt,
                SkyboxLf = Lighting.SkyboxLf,
                SkyboxRt = Lighting.SkyboxRt,
                SkyboxUp = Lighting.SkyboxUp
            }
            local burgerId = "rbxassetid://130721971"
            Lighting.Brightness = 2
            Lighting.ColorShift_Top = Color3.new(1,1,1)
            Lighting.ColorShift_Bottom = Color3.new(1,1,1)
            Lighting.SkyboxBk = burgerId
            Lighting.SkyboxDn = burgerId
            Lighting.SkyboxFt = burgerId
            Lighting.SkyboxLf = burgerId
            Lighting.SkyboxRt = burgerId
            Lighting.SkyboxUp = burgerId
            Rayfield:Notify({Title = "天空箱", Content = "已切换为汉堡", Type = "success"})
        else
            for k, v in pairs(originalSkybox) do
                Lighting[k] = v
            end
            Rayfield:Notify({Title = "天空箱", Content = "已恢复默认", Type = "info"})
        end
    end
})

-- 2. 全局火焰
local fireEnabled = false
local fireInstances = {}
ServerTab:CreateButton({
    Name = "切换全局火焰",
    Callback = function()
        fireEnabled = not fireEnabled
        
        if fireEnabled then
            for _, part in ipairs(workspace:GetDescendants()) do
                if part:IsA("Part") or part:IsA("MeshPart") then
                    local fire = Instance.new("Fire")
                    fire.Heat = 5
                    fire.Size = 2
                    fire.Parent = part
                    table.insert(fireInstances, fire)
                end
            end
            Rayfield:Notify({Title = "全局火焰", Content = "已开启", Type = "success"})
        else
            for _, fire in ipairs(fireInstances) do
                if fire and fire.Parent then
                    fire:Destroy()
                end
            end
            fireInstances = {}
            Rayfield:Notify({Title = "全局火焰", Content = "已关闭", Type = "info"})
        end
    end
})

-- 3. 执行Infinite Yield
ServerTab:CreateButton({
    Name = "执行Infinite Yield",
    Callback = function()
        Rayfield:Notify({Title = "加载中", Content = "请稍候...", Type = "info"})
        task.spawn(function()
            local success, err = pcall(function()
                loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source", true))()
            end)
            if success then
                Rayfield:Notify({Title = "成功", Content = "Infinite Yield已加载", Type = "success"})
            else
                Rayfield:Notify({Title = "失败", Content = "加载错误: "..err, Type = "error"})
            end
        end)
    end
})

-- 加载完成提示
Rayfield:Notify({
    Title = "Sam Hub",
    Content = "所有功能已加载",
    Duration = 3,
    Type = "success"
})
