local Rayfield = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Rayfield/main/source"))()

local Window = Rayfield:CreateWindow({
    Name = "Sam Hub",
    LoadingTitle = "Sam Hub",
    LoadingSubtitle = "加载中...",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "SamHub",
        FileName = "SamHubConfig"
    },
    Discord = {Enabled = false},
    KeySystem = false
})

local PlayerTab = Window:CreateTab("玩家", nil)
local ServerTab = Window:CreateTab("服务器", nil)

PlayerTab:CreateSection("玩家功能控制")

PlayerTab:CreateSlider({
    Name = "跳跃高度调节",
    Range = {1, 20},
    Increment = 1,
    Suffix = "倍",
    CurrentValue = 1,
    Flag = "JumpHeight",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.JumpPower = 50 * Value
            Rayfield:Notify({
                Title = "跳跃设置",
                Content = "跳跃高度已设为 "..Value.." 倍",
                Type = "info"
            })
        end
    end
})

PlayerTab:CreateSlider({
    Name = "移动速度调节",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "倍",
    CurrentValue = 1,
    Flag = "MoveSpeed",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16 * Value
            Rayfield:Notify({
                Title = "速度设置",
                Content = "移动速度已设为 "..Value.." 倍",
                Type = "info"
            })
        end
    end
})

local isRotating = false
PlayerTab:CreateButton({
    Name = "旋转控制（顺时针）",
    Callback = function()
        isRotating = not isRotating
        local player = game.Players.LocalPlayer
        
        if isRotating then
            Rayfield:Notify({Title = "旋转控制", Content = "已开启顺时针旋转", Type = "success"})
            spawn(function()
                while isRotating and player.Character and player.Character:FindFirstChild("HumanoidRootPart") do
                    local root = player.Character.HumanoidRootPart
                    root.CFrame = root.CFrame * CFrame.Angles(0, math.rad(50), 0)
                    task.wait()
                end
            end)
        else
            Rayfield:Notify({Title = "旋转控制", Content = "已停止旋转", Type = "error"})
        end
    end
})

local isFlying = false
PlayerTab:CreateButton({
    Name = "飞行控制",
    Callback = function()
        isFlying = not isFlying
        local player = game.Players.LocalPlayer
        
        if isFlying then
            Rayfield:Notify({Title = "飞行控制", Content = "已开启飞行模式", Type = "success"})
            spawn(function()
                while isFlying and player.Character do
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    local root = player.Character:FindFirstChild("HumanoidRootPart")
                    if humanoid and root then
                        humanoid.PlatformStand = true
                        local moveDir = game:GetService("UserInputService"):GetMovementVector()
                        root.Velocity = Vector3.new(
                            moveDir.X * 50, 
                            (game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) and 50 or 
                            game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftControl) and -50 or 0), 
                            moveDir.Y * 50
                        )
                    end
                    task.wait()
                end
                if player.Character then
                    local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
                    if humanoid then
                        humanoid.PlatformStand = false
                    end
                end
            end)
        else
            Rayfield:Notify({Title = "飞行控制", Content = "已关闭飞行模式", Type = "error"})
        end
    end
})

PlayerTab:CreateTextBox({
    Name = "血量修改",
    PlaceholderText = "输入血量值（如100）",
    Callback = function(Text)
        local health = tonumber(Text)
        if health then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                local humanoid = player.Character.Humanoid
                humanoid.MaxHealth = health
                humanoid.Health = health
                Rayfield:Notify({
                    Title = "血量设置",
                    Content = "血量已修改为 "..health,
                    Type = "success"
                })
            end
        else
            Rayfield:Notify({Title = "输入错误", Content = "请输入有效的数字", Type = "error"})
        end
    end
})

local espEnabled = false
PlayerTab:CreateToggle({
    Name = "ESP显示",
    CurrentValue = false,
    Flag = "ESPEnabled",
    Callback = function(Value)
        espEnabled = Value
        if espEnabled then
            Rayfield:Notify({Title = "ESP设置", Content = "已开启玩家ESP", Type = "success"})
            spawn(function()
                while espEnabled do
                    for _, plr in ipairs(game.Players:GetPlayers()) do
                        if plr ~= game.Players.LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                            local root = plr.Character.HumanoidRootPart
                        end
                    end
                    task.wait(0.1)
                end
            end)
        else
            Rayfield:Notify({Title = "ESP设置", Content = "已关闭玩家ESP", Type = "error"})
        end
    end
})

ServerTab:CreateSection("服务器功能控制")

local skyboxChanged = false
local originalSkybox = {}
ServerTab:CreateButton({
    Name = "切换汉堡天空箱",
    Callback = function()
        skyboxChanged = not skyboxChanged
        local lighting = game:GetService("Lighting")
        
        if skyboxChanged then
            originalSkybox.Brightness = lighting.Brightness
            originalSkybox.ColorShift_Top = lighting.ColorShift_Top
            originalSkybox.ColorShift_Bottom = lighting.ColorShift_Bottom
            originalSkybox.SkyboxBk = lighting.SkyboxBk
            originalSkybox.SkyboxDn = lighting.SkyboxDn
            originalSkybox.SkyboxFt = lighting.SkyboxFt
            originalSkybox.SkyboxLf = lighting.SkyboxLf
            originalSkybox.SkyboxRt = lighting.SkyboxRt
            originalSkybox.SkyboxUp = lighting.SkyboxUp
            
            local burgerTextureId = "rbxassetid://130721971"
            
            lighting.Brightness = 2
            lighting.ColorShift_Top = Color3.new(1, 1, 1)
            lighting.ColorShift_Bottom = Color3.new(1, 1, 1)
            lighting.SkyboxBk = burgerTextureId
            lighting.SkyboxDn = burgerTextureId
            lighting.SkyboxFt = burgerTextureId
            lighting.SkyboxLf = burgerTextureId
            lighting.SkyboxRt = burgerTextureId
            lighting.SkyboxUp = burgerTextureId
            
            Rayfield:Notify({
                Title = "天空箱设置",
                Content = "已切换为汉堡天空箱",
                Type = "success"
            })
        else
            lighting.Brightness = originalSkybox.Brightness
            lighting.ColorShift_Top = originalSkybox.ColorShift_Top
            lighting.ColorShift_Bottom = originalSkybox.ColorShift_Bottom
            lighting.SkyboxBk = originalSkybox.SkyboxBk
            lighting.SkyboxDn = originalSkybox.SkyboxDn
            lighting.SkyboxFt = originalSkybox.SkyboxFt
            lighting.SkyboxLf = originalSkybox.SkyboxLf
            lighting.SkyboxRt = originalSkybox.SkyboxRt
            lighting.SkyboxUp = originalSkybox.SkyboxUp
            
            Rayfield:Notify({
                Title = "天空箱设置",
                Content = "已恢复原始天空箱",
                Type = "info"
            })
        end
    end
})

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
            
            Rayfield:Notify({
                Title = "全局火焰",
                Content = "已为所有部件添加火焰效果",
                Type = "success"
            })
        else
            for _, fire in ipairs(fireInstances) do
                if fire and fire.Parent then
                    fire:Destroy()
                end
            end
            fireInstances = {}
            
            Rayfield:Notify({
                Title = "全局火焰",
                Content = "已清除所有火焰效果",
                Type = "info"
            })
        end
    end
})

ServerTab:CreateButton({
    Name = "执行Infinite Yield",
    Callback = function()
        Rayfield:Notify({
            Title = "脚本执行",
            Content = "正在加载Infinite Yield...",
            Type = "info"
        })
        
        local success, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)
        
        if success then
            Rayfield:Notify({
                Title = "脚本执行",
                Content = "Infinite Yield加载成功",
                Type = "success"
            })
        else
            Rayfield:Notify({
                Title = "脚本错误",
                Content = "加载失败: " .. err,
                Type = "error"
            })
        end
    end
})

Rayfield:Notify({
    Title = "Sam Hub",
    Content = "所有功能区已加载完成",
    Duration = 3,
    Type = "success"
})
