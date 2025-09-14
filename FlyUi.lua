-- LocalScript，放在 StarterPlayerScripts
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:FindFirstChildOfClass("Humanoid")

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local ContextActionService = game:GetService("ContextActionService")

local flying = false
local flySpeed = 50
local minSpeed, maxSpeed = 20, 150
local joystickVector = Vector3.new(0, 0, 0)

-- UI界面
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "FlyUI"

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 110, 0, 50)
flyButton.Position = UDim2.new(0, 10, 1, -130)
flyButton.Text = "飞行开关"
flyButton.Parent = screenGui

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0, 110, 0, 30)
speedLabel.Position = UDim2.new(0, 10, 1, -80)
speedLabel.Text = "速度：" .. tostring(flySpeed)
speedLabel.BackgroundTransparency = 0.6
speedLabel.Parent = screenGui

local addButton = Instance.new("TextButton")
addButton.Size = UDim2.new(0, 50, 0, 30)
addButton.Position = UDim2.new(0, 120, 1, -80)
addButton.Text = "+"
addButton.Parent = screenGui

local subButton = Instance.new("TextButton")
subButton.Size = UDim2.new(0, 50, 0, 30)
subButton.Position = UDim2.new(0, 170, 1, -80)
subButton.Text = "-"
subButton.Parent = screenGui

-- 飞行开关
flyButton.MouseButton1Click:Connect(function()
    flying = not flying
    if flying then
        flyButton.Text = "停止飞行"
    else
        flyButton.Text = "飞行开关"
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
    end
end)

-- 调整速度
addButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed + 10, minSpeed, maxSpeed)
    speedLabel.Text = "速度：" .. tostring(flySpeed)
end)
subButton.MouseButton1Click:Connect(function()
    flySpeed = math.clamp(flySpeed - 10, minSpeed, maxSpeed)
    speedLabel.Text = "速度：" .. tostring(flySpeed)
end)

-- 摇杆控制
local function updateJoystickVector(actionName, inputState, inputObj)
    if inputState == Enum.UserInputState.Change or inputState == Enum.UserInputState.Begin then
        local moveVector = humanoid.MoveDirection
        joystickVector = moveVector
    elseif inputState == Enum.UserInputState.End then
        joystickVector = Vector3.new(0, 0, 0)
    end
end

ContextActionService:BindAction(
    "FlyMove", 
    updateJoystickVector, 
    false, 
    Enum.PlayerActions.CharacterForward, 
    Enum.PlayerActions.CharacterBackward, 
    Enum.PlayerActions.CharacterLeft, 
    Enum.PlayerActions.CharacterRight
)

-- 持续施加速度
RunService.RenderStepped:Connect(function()
    if flying then
        humanoidRootPart.AssemblyLinearVelocity = Vector3.new(joystickVector.X, 0, joystickVector.Z) * flySpeed
    end
end)