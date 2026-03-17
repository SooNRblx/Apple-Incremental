-- 1. ATTENTE DU CHARGEMENT COMPLET
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Nettoyage si déjà présent
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

-- 3. LOGIQUE ANTI-AFK (Sécurisée)
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then
        pcall(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

-- 4. CRÉATION DE L'INTERFACE
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AppleGui"
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- Bouton Logo (Ouverture)
local logo = Instance.new("TextButton")
logo.Name = "OpenLogo"
logo.Size = UDim2.new(0, 50, 0, 50)
logo.Position = UDim2.new(0, 20, 0, 20)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 30
logo.Parent = screenGui
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

-- Fenêtre principale
local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 320, 0, 180)
frame.Position = UDim2.new(0.5, -160, 0.5, -90)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
frame.Parent = screenGui
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

-- Header
local header = Instance.new("Frame")
header.Size = UDim2.new(1, 0, 0, 35)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
header.Parent = frame
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 10)

-- Titre à GAUCHE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.Text = "Apple Incremental"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left
title.BackgroundTransparency = 1
title.Parent = header

-- Mention "Made By SooN" à DROITE (collée au bouton fermer)
local credit = Instance.new("TextLabel")
credit.Size = UDim2.new(0, 100, 1, 0)
credit.Position = UDim2.new(1, -140, 0, 0)
credit.Text = "Made By SooN"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.TextXAlignment = Enum.TextXAlignment.Right
credit.BackgroundTransparency = 1
credit.Parent = header

-- Bouton Fermer
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 25, 0, 25)
close.Position = UDim2.new(1, -30, 0, 5)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = header
Instance.new("UICorner", close)

-- BOUTON AUTO FARM
local toggleAF = Instance.new("TextButton")
toggleAF.Size = UDim2.new(0, 70, 0, 30)
toggleAF.Position = UDim2.new(1, -90, 0, 60)
toggleAF.Text = "OFF"
toggleAF.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleAF.TextColor3 = Color3.new(1, 1, 1)
toggleAF.Parent = frame
Instance.new("UICorner", toggleAF)

local labelAF = Instance.new("TextLabel")
labelAF.Size = UDim2.new(0, 100, 0, 30)
labelAF.Position = UDim2.new(0, 20, 0, 60)
labelAF.Text = "Auto Farm"
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.TextXAlignment = Enum.TextXAlignment.Left
labelAF.Parent = frame

-- BOUTON ANTI AFK
local toggleAA = Instance.new("TextButton")
toggleAA.Size = UDim2.new(0, 70, 0, 30)
toggleAA.Position = UDim2.new(1, -90, 0, 105)
toggleAA.Text = "OFF"
toggleAA.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
toggleAA.TextColor3 = Color3.new(1, 1, 1)
toggleAA.Parent = frame
Instance.new("UICorner", toggleAA)

local labelAA = Instance.new("TextLabel")
labelAA.Size = UDim2.new(0, 100, 0, 30)
labelAA.Position = UDim2.new(0, 20, 0, 105)
labelAA.Text = "Anti AFK"
labelAA.TextColor3 = Color3.new(1, 1, 1)
labelAA.BackgroundTransparency = 1
labelAA.TextXAlignment = Enum.TextXAlignment.Left
labelAA.Parent = frame

-- 5. LOGIQUE DE DRAG (SÉCURISÉE)
local UserInputService = game:GetService("UserInputService")
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)

-- 6. LOGIQUE DES BOUTONS
logo.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
close.MouseButton1Click:Connect(function() frame.Visible = false end)

toggleAF.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    toggleAF.Text = autoFarmActive and "ON" or "OFF"
    toggleAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

toggleAA.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    toggleAA.Text = antiAfkActive and "ON" or "OFF"
    toggleAA.BackgroundColor3 = antiAfkActive and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(150, 0, 0)
end)

-- BOUCLE DE TÉLÉPORTATION
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

print("Interface chargée avec succès.")
