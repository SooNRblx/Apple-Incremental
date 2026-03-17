-- 1. INITIALISATION
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

if playerGui:FindFirstChild("AppleGui") then
    playerGui.AppleGui:Destroy()
end

-- 2. COORDONNÉES
local locations = {
    Vector3.new(16.294, 2, 8.095), Vector3.new(26.887, 2, 32.912), Vector3.new(28.422, 2, 6.238),
    Vector3.new(39.73, 2, 41), Vector3.new(5.062, 2, 36.531), Vector3.new(37.216, 2, 25.284),
    Vector3.new(9.231, 2, 9.369), Vector3.new(19.143, 2, 23.788), Vector3.new(39.575, 2, 3.488),
    Vector3.new(35.829, 2, 8.827), Vector3.new(2.361, 2, 10.554), Vector3.new(24.833, 2, 26.129),
    Vector3.new(25.724, 3.829, 15.517), Vector3.new(10.85, 2, 18.833), Vector3.new(15.594, 2, 40.347),
    Vector3.new(0.087, 2, 22.875), Vector3.new(30.625, 2, 39.625), Vector3.new(8.973, 2, 3.131),
    Vector3.new(19.318, 2, 1.633), Vector3.new(13.03, 2, 29.887), Vector3.new(41.027, 2, 16.008),
    Vector3.new(0.444, 2, 1.704), Vector3.new(0.382, 2, 13.485), Vector3.new(31.374, 2, 19.374),
    Vector3.new(37.808, 2, 33.229), Vector3.new(41.027, 2, 31.23), Vector3.new(0.313, 2, 41.731),
    Vector3.new(19.813, 2, 32.678), Vector3.new(3.982, 2, 29.132), Vector3.new(17.084, 2, 15.058),
    Vector3.new(31.892, 2, 0.095), Vector3.new(22.716, 2, 40.894)
}

local autoFarmActive = false
local antiAfkActive = false
local currentTPIndex = 1

-- 3. INTERFACE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AppleGui"
screenGui.DisplayOrder = 5 -- Priorité moyenne pour ne pas tout cacher
screenGui.IgnoreGuiInset = true -- Optionnel, selon ton exécuteur
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Logo discret (réduit à 40x40)
local logo = Instance.new("TextButton")
logo.Name = "OpenLogo"
logo.Size = UDim2.new(0, 40, 0, 40)
logo.Position = UDim2.new(0, 10, 0, 150) -- Déplacé un peu plus bas pour ne pas gêner le chat
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 20
logo.Parent = screenGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 10)

-- Fenêtre
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 300, 0, 160)
frame.Position = UDim2.new(0.5, -150, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Header (Zone de Drag)
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.Parent = frame
local hCorner = Instance.new("UICorner", header)
hCorner.CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Apple Incremental"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 13
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 90, 1, 0)
credit.Position = UDim2.new(1, -125, 0, 0)
credit.Text = "Made By SooN"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.Gotham
credit.TextSize = 10
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 24, 0, 24)
close.Position = UDim2.new(1, -28, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = header
Instance.new("UICorner", close)

-- Fonction création boutons
local function addToggle(posY, txt)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 100, 0, 30)
    label.Position = UDim2.new(0, 20, 0, posY)
    label.Text = txt
    label.TextColor3 = Color3.new(1, 1, 1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 26)
    btn.Position = UDim2.new(1, -80, 0, posY + 2)
    btn.Text = "OFF"
    btn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Parent = frame
    Instance.new("UICorner", btn)
    return btn
end

local btnAF = addToggle(55, "Auto Farm")
local btnAA = addToggle(95, "Anti AFK")

-- 4. LOGIQUE DRAG
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 5. FONCTIONS
logo.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
close.MouseButton1Click:Connect(function() frame.Visible = false end)

btnAF.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    btnAF.Text = autoFarmActive and "ON" or "OFF"
    btnAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(100, 100, 100)
end)

btnAA.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    btnAA.Text = antiAfkActive and "ON" or "OFF"
    btnAA.BackgroundColor3 = antiAfkActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(100, 100, 100)
end)

-- Boucle TP
task.spawn(function()
    while true do
        if autoFarmActive then
            local char = player.Character
            local root = char and char:FindFirstChild("HumanoidRootPart")
            if root then
                root.CFrame = CFrame.new(locations[currentTPIndex])
                currentTPIndex = (currentTPIndex % #locations) + 1
            end
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then
        pcall(function() vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) task.wait(1) vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
    end
end)
