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
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Logo 60x60
local logo = Instance.new("TextButton")
logo.Name = "OpenLogo"
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 15, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 35
logo.Parent = screenGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

-- Fenêtre principale 350x250 (légèrement plus haute pour l'onglet)
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Apple Incremental"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 110, 1, 0)
credit.Position = UDim2.new(1, -145, 0, 0)
credit.Text = "Made By RoScript"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.Parent = header

local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -34, 0, 6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = header
Instance.new("UICorner", close)

--- SECTION "FARM" ---
local farmSection = Instance.new("Frame")
farmSection.Name = "FarmSection"
farmSection.Size = UDim2.new(0, 310, 0, 100) -- Boîte de séparation
farmSection.Position = UDim2.new(0, 20, 0, 60)
farmSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
farmSection.BorderSizePixel = 0
farmSection.Parent = frame
Instance.new("UICorner", farmSection).CornerRadius = UDim.new(0, 8)

-- Titre de l'onglet Farm
local farmTitle = Instance.new("TextLabel")
farmTitle.Size = UDim2.new(0, 60, 0, 20)
farmTitle.Position = UDim2.new(0, 10, 0, 5)
farmTitle.Text = "FARM"
farmTitle.TextColor3 = Color3.fromRGB(255, 100, 100) -- Rouge clair pour le titre de section
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextSize = 12
farmTitle.BackgroundTransparency = 1
farmTitle.TextXAlignment = Enum.TextXAlignment.Left
farmTitle.Parent = farmSection

-- Bouton Auto Farm (à l'intérieur de la section)
local labelAF = Instance.new("TextLabel")
labelAF.Size = UDim2.new(0, 100, 0, 35)
labelAF.Position = UDim2.new(0, 10, 0, 40)
labelAF.Text = "Auto Farm"
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.Font = Enum.Font.Gotham
labelAF.TextSize = 14
labelAF.TextXAlignment = Enum.TextXAlignment.Left
labelAF.Parent = farmSection

local btnAF = Instance.new("TextButton")
btnAF.Size = UDim2.new(0, 75, 0, 30)
btnAF.Position = UDim2.new(1, -85, 0, 42)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
btnAF.Parent = farmSection
Instance.new("UICorner", btnAF)

--- ELEMENT ANTI-AFK (hors section pour le moment ou dans une autre) ---
local labelAA = Instance.new("TextLabel")
labelAA.Size = UDim2.new(0, 120, 0, 35)
labelAA.Position = UDim2.new(0, 25, 0, 175)
labelAA.Text = "Anti AFK"
labelAA.TextColor3 = Color3.new(1, 1, 1)
labelAA.BackgroundTransparency = 1
labelAA.Font = Enum.Font.Gotham
labelAA.TextSize = 14
labelAA.TextXAlignment = Enum.TextXAlignment.Left
labelAA.Parent = frame

local btnAA = Instance.new("TextButton")
btnAA.Size = UDim2.new(0, 75, 0, 30)
btnAA.Position = UDim2.new(1, -100, 0, 177)
btnAA.Text = "OFF"
btnAA.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAA.TextColor3 = Color3.new(1, 1, 1)
btnAA.Parent = frame
Instance.new("UICorner", btnAA)

-- Version V1
local version = Instance.new("TextLabel")
version.Size = UDim2.new(0, 40, 0, 20)
version.Position = UDim2.new(1, -50, 1, -25)
version.Text = "V1"
version.TextColor3 = Color3.fromRGB(100, 100, 100)
version.Font = Enum.Font.Gotham
version.TextSize = 12
version.BackgroundTransparency = 1
version.TextXAlignment = Enum.TextXAlignment.Right
version.Parent = frame

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
    btnAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

btnAA.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    btnAA.Text = antiAfkActive and "ON" or "OFF"
    btnAA.BackgroundColor3 = antiAfkActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

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

local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then
        pcall(function() 
            vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
            task.wait(1) 
            vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) 
        end)
    end
end)
