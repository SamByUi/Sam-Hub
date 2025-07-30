local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "SamHub",
    LoadingTitle = "SamHub加载中...",
    LoadingSubtitle = "By 你的名字",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

local PlayerTab = Window:CreateTab("玩家区", 4483362458)

PlayerTab:CreateInput({
    Name = "移动速度（WalkSpeed）",
    PlaceholderText = "输入数值（例：50）",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local v = tonumber(text)
        if v then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = v
            Rayfield:Notify({Title="速度已设置",Content="当前速度为："..v,Duration=2})
        end
    end,
})

PlayerTab:CreateInput({
    Name = "跳跃高度（JumpPower）",
    PlaceholderText = "输入数值（例：100）",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local v = tonumber(text)
        if v then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = v
            Rayfield:Notify({Title="跳跃力已设置",Content="当前跳跃力为："..v,Duration=2})
        end
    end,
})

local playerList = {}
local function refreshPlayerList()
    playerList = {}
    for _, v in ipairs(game.Players:GetPlayers()) do
        if v ~= game.Players.LocalPlayer then
            table.insert(playerList, v.Name)
        end
    end
end
refreshPlayerList()
local selectedPlayer = nil

PlayerTab:CreateDropdown({
    Name = "选择玩家进行传送",
    Options = playerList,
    CurrentOption = playerList[1] or "",
    Callback = function(op)
        selectedPlayer = op
    end,
})

PlayerTab:CreateButton({
    Name = "刷新在线玩家列表",
    Callback = function()
        refreshPlayerList()
        Rayfield:Notify({Title="已刷新", Content="可在下拉框选择最新玩家.", Duration=2})
    end,
})

PlayerTab:CreateButton({
    Name = "传送到该玩家",
    Callback = function()
        if selectedPlayer and #selectedPlayer > 0 then
            local target = game.Players:FindFirstChild(selectedPlayer)
            if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
                game.Players.LocalPlayer.Character:MoveTo(target.Character.HumanoidRootPart.Position + Vector3.new(0,3,0))
                Rayfield:Notify({Title="传送成功", Content="你已传送到 "..selectedPlayer, Duration=2})
            end
        else
            Rayfield:Notify({Title="错误", Content="请先选择目标玩家", Duration=2})
        end
    end,
})

PlayerTab:CreateButton({
    Name = "Fly飞行模式",
    Callback = function()
        loadstring(game:HttpGet('https://pastebin.com/raw/6z7yB6ek'))()
    end,
})

PlayerTab:CreateButton({
    Name = "载具飞行模式",
    Callback = function()
        loadstring(game:HttpGet('https://raw.githubusercontent.com/compwnter/Roblox-Vehicle-Fly/main/main.lua'))()
    end,
})

PlayerTab:CreateButton({
    Name = "重新加入服务器（Rejoin）",
    Callback = function()
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game.Players.LocalPlayer)
    end,
})

local espObjects = {}
function enableESP()
    for _,player in ipairs(game.Players:GetPlayers()) do
        if player ~= game.Players.LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local BillboardGui = Instance.new("BillboardGui", player.Character.HumanoidRootPart)
            BillboardGui.Size = UDim2.new(0,100,0,40)
            BillboardGui.Adornee = player.Character.HumanoidRootPart
            BillboardGui.AlwaysOnTop = true
            BillboardGui.Name = "SamESP"
            local TextLabel = Instance.new("TextLabel", BillboardGui)
            TextLabel.Size = UDim2.new(1,0,1,0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = player.Name
            TextLabel.TextColor3 = Color3.new(1,0,0)
            TextLabel.TextScaled = true
            table.insert(espObjects, BillboardGui)
        end
    end
end
function disableESP()
    for _,billboard in ipairs(espObjects) do
        if billboard and billboard.Parent then
            billboard:Destroy()
        end
    end
    espObjects = {}
end

PlayerTab:CreateToggle({
    Name = "ESP显示（开/关）",
    CurrentValue = false,
    Callback = function(state)
        if state then
            enableESP()
            Rayfield:Notify({Title="ESP已开启", Content="", Duration=2})
        else
            disableESP()
            Rayfield:Notify({Title="ESP已关闭", Content="", Duration=2})
        end
    end,
})

PlayerTab:CreateInput({
    Name = "Hitbox大小调整（输入数字, 0恢复）",
    PlaceholderText = "例如：10 或 0",
    RemoveTextAfterFocusLost = true,
    Callback = function(text)
        local size = tonumber(text)
        for _,p in pairs(game.Players:GetPlayers()) do
            if p.Character and p ~= game.Players.LocalPlayer then
                local root = p.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    if size and size > 0 then
                        root.Size = Vector3.new(size, size, size)
                        root.Transparency = 0.5
                        root.Material = Enum.Material.Neon
                        root.CanCollide = false
                    else
                        root.Size = Vector3.new(2,2,1)
                        root.Transparency = 1
                        root.Material = Enum.Material.Plastic
                        root.CanCollide = true
                    end
                end
            end
        end
        if size and size >= 1 then
            Rayfield:Notify({Title="Hitbox已扩大", Content="当前尺寸: "..size, Duration=2})
        else
            Rayfield:Notify({Title="Hitbox已恢复正常", Content="", Duration=2})
        end
    end,
})

Rayfield:Notify({
    Title = "SamHub 玩家区已加载",
    Content = "全部高级功能就绪！",
    Duration = 4
})

local FakeHackerTab = Window:CreateTab("服务器伪入侵区", 94307934)

FakeHackerTab:CreateButton({
    Name = "c00lkidd GUI",
    Callback = function()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/killkidd1/c00lkidd-GUI/master/c00lkidd%20GUI"))()
        Rayfield:Notify({Title="c00lkidd GUI", Content="已加载，稍等几秒...", Duration=3})
    end,
})

FakeHackerTab:CreateButton({
    Name = "（伪）崩溃全服 [本地特效]",
    Callback = function()
        Rayfield:Notify({Title="警告", Content="你已'崩溃服务器'！（仅特效）", Duration=3})
        for i=1,20 do
            game.Lighting.Brightness = math.random(0,6)
            wait(0.05)
        end
        game.Lighting.Brightness = 1
    end,
})

FakeHackerTab:CreateButton({
    Name = "（伪）全员送钱动画",
    Callback = function()
        Rayfield:Notify({Title="富豪降临", Content="已'给所有人刷钱'！（仅本地显示）", Duration=3})
        for i=1,10 do
            game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage",{
                Text = "[SamHub] 已给玩家 "..
                    game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())].Name..
                    " 添加 100000 现金！",
                Color = Color3.fromRGB(0,255,0),
                Font = Enum.Font.SourceSansBold,
                FontSize = Enum.FontSize.Size24
            })
            wait(0.3)
        end
    end,
})

FakeHackerTab:CreateButton({
    Name = "黑客进度条（假）",
    Callback = function()
        Rayfield:Notify({Title="入侵中", Content="连接服务器……", Duration=2})
        wait(2)
        Rayfield:Notify({Title="入侵中", Content="获取root权限……", Duration=2})
        wait(2)
        Rayfield:Notify({Title="入侵模拟完成", Content="你已伪装为服务器超级管理员！（仅本地）", Duration=2})
    end,
})