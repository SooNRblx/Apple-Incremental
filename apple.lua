-- 1. INITIALISATION
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

if playerGui:FindFirstChild("AppleGui") then
    playerGui.AppleGui:Destroy()
end

-- 2. VARIABLES DE CONTROLE
local autoFarmActive = false
local antiAfkActive = false
local currentTPIndex = 1
local walkSpeedValue = 16

-- 3. INTERFACE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AppleGui"
screenGui.ResetOnSpawn = false

-- Logo (Bouton d'ouverture)
local logo = Instance.new("TextButton", screenGui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 15, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 35
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

-- Fenêtre principale
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Header (Drag)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.5, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Apple Incremental"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local credit = Instance.new("TextLabel", header)
credit.Size = UDim2.new(0, 110, 1, 0)
credit.Position = UDim2.new(1, -145, 0, 0)
credit.Text = "Made By RoScript"
credit.TextColor3 = Color3.fromRGB(200, 200, 200)
credit.Font = Enum.Font.Gotham
credit.TextSize = 11
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Right

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -34, 0, 6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

--- SCROLLING FRAME ---
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -70)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 1.5, 0) -- Ajuste la hauteur du scroll ici
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100)

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--- SECTION FARM ---
local farmSection = Instance.new("Frame", scroll)
farmSection.Size = UDim2.new(0, 310, 0, 80)
farmSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", farmSection)

local farmTitle = Instance.new("TextLabel", farmSection)
farmTitle.Size = UDim2.new(0, 100, 0, 20)
farmTitle.Position = UDim2.new(0, 10, 0, 5)
farmTitle.Text = "FARM"
farmTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextSize = 12
farmTitle.BackgroundTransparency = 1
farmTitle.TextXAlignment = Enum.TextXAlignment.Left

local btnAF = Instance.new("TextButton", farmSection)
btnAF.Size = UDim2.new(0, 75, 0, 30)
btnAF.Position = UDim2.new(1, -85, 0, 35)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

local labelAF = Instance.new("TextLabel", farmSection)
labelAF.Size = UDim2.new(0, 100, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 35)
labelAF.Text = "Auto Farm"
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.Font = Enum.Font.Gotham
labelAF.TextXAlignment = Enum.TextXAlignment.Left

--- SECTION MOVEMENT ---
local moveSection = Instance.new("Frame", scroll)
moveSection.Size = UDim2.new(0, 310, 0, 100)
moveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", moveSection)

local moveTitle = Instance.new("TextLabel", moveSection)
moveTitle.Size = UDim2.new(0, 100, 0, 20)
moveTitle.Position = UDim2.new(0, 10, 0, 5)
moveTitle.Text = "MOVEMENT"
moveTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
moveTitle.Font = Enum.Font.GothamBold
moveTitle.TextSize = 12
moveTitle.BackgroundTransparency = 1
moveTitle.TextXAlignment = Enum.TextXAlignment.Left

local labelWS = Instance.new("TextLabel", moveSection)
labelWS.Size = UDim2.new(0, 100, 0, 30)
labelWS.Position = UDim2.new(0, 10, 0, 30)
labelWS.Text = "WalkSpeed: 16"
labelWS.TextColor3 = Color3.new(1, 1, 1)
labelWS.BackgroundTransparency = 1
labelWS.Font = Enum.Font.Gotham
labelWS.TextXAlignment = Enum.TextXAlignment.Left

-- Slider (La barre)
local sliderBack = Instance.new("Frame", moveSection)
sliderBack.Size = UDim2.new(0, 200, 0, 6)
sliderBack.Position = UDim2.new(0, 10, 0, 75)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderBack)

local sliderBall = Instance.new("TextButton", sliderBack)
sliderBall.Size = UDim2.new(0, 16, 0, 16)
sliderBall.Position = UDim2.new(0, 0, 0.5, -8)
sliderBall.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
sliderBall.Text = ""
Instance.new("UICorner", sliderBall).CornerRadius = UDim.new(1, 0)

--- ANTI-AFK & VERSION (Bas fixe) ---
local btnAA = Instance.new("TextButton", frame)
btnAA.Size = UDim2.new(0, 70, 0, 25)
btnAA.Position = UDim2.new(0, 10, 1, -35)
btnAA.Text = "Anti-AFK: OFF"
btnAA.TextSize = 10
btnAA.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnAA.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAA)

local version = Instance.new("TextLabel", frame)
version.Size = UDim2.new(0, 40, 0, 20)
version.Position = UDim2.new(1, -50, 1, -25)
version.Text = "V1"
version.TextColor3 = Color3.fromRGB(100, 100, 100)
version.BackgroundTransparency = 1
version.Font = Enum.Font.Gotham

-- 4. LOGIQUE SLIDER (Mouvement)
local isSliding = false
sliderBall.MouseButton1Down:Connect(function() isSliding = true end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end
end)

UserInputService.InputChanged:Connect(function(input)
    if isSliding and input.UserInputType == Enum.UserInputType.MouseMovement then
        local mousePos = UserInputService:GetMouseLocation().X
        local relativePos = mousePos - sliderBack.AbsolutePosition.X
        local percentage = math.clamp(relativePos / sliderBack.AbsoluteSize.X, 0, 1)
        
        sliderBall.Position = UDim2.new(percentage, -8, 0.5, -8)
        walkSpeedValue = math.floor(16 + (percentage * 184)) -- Range 16 à 200
        labelWS.Text = "WalkSpeed: " .. walkSpeedValue
    end
end)

-- Appliquer le WalkSpeed en boucle
RunService.RenderStepped:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.WalkSpeed = walkSpeedValue
    end
end)

-- 5. LOGIQUE BOUTONS & DRAG (Inchangée mais adaptée)
logo.MouseButton1Click:Connect(function() frame.Visible = not frame.Visible end)
close.MouseButton1Click:Connect(function() frame.Visible = false end)

btnAF.MouseButton1Click:Connect(function()
    autoFarmActive = not autoFarmActive
    btnAF.Text = autoFarmActive and "ON" or "OFF"
    btnAF.BackgroundColor3 = autoFarmActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(80, 80, 80)
end)

btnAA.MouseButton1Click:Connect(function()
    antiAfkActive = not antiAfkActive
    btnAA.Text = antiAfkActive and "Anti-AFK: ON" or "Anti-AFK: OFF"
    btnAA.BackgroundColor3 = antiAfkActive and Color3.fromRGB(40, 160, 40) or Color3.fromRGB(60, 60, 60)
end)

-- Drag système
local dragging, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true dragStart = input.Position startPos = frame.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
header.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)

-- Boucle TP Farm
task.spawn(function()
    local locations = { Vector3.new(16.294, 2, 8.095), Vector3.new(26.887, 2, 32.912), Vector3.new(28.422, 2, 6.238), Vector3.new(39.73, 2, 41), Vector3.new(5.062, 2, 36.531), Vector3.new(37.216, 2, 25.284), Vector3.new(9.231, 2, 9.369), Vector3.new(19.143, 2, 23.788), Vector3.new(39.575, 2, 3.488), Vector3.new(35.829, 2, 8.827), Vector3.new(2.361, 2, 10.554), Vector3.new(24.833, 2, 26.129), Vector3.new(25.724, 3.829, 15.517), Vector3.new(10.85, 2, 18.833), Vector3.new(15.594, 2, 40.347), Vector3.new(0.087, 2, 22.875), Vector3.new(30.625, 2, 39.625), Vector3.new(8.973, 2, 3.131), Vector3.new(19.318, 2, 1.633), Vector3.new(13.03, 2, 29.887), Vector3.new(41.027, 2, 16.008), Vector3.new(0.444, 2, 1.704), Vector3.new(0.382, 2, 13.485), Vector3.new(31.374, 2, 19.374), Vector3.new(37.808, 2, 33.229), Vector3.new(41.027, 2, 31.23), Vector3.new(0.313, 2, 41.731), Vector3.new(19.813, 2, 32.678), Vector3.new(3.982, 2, 29.132), Vector3.new(17.084, 2, 15.058), Vector3.new(31.892, 2, 0.095), Vector3.new(22.716, 2, 40.894) }
    while true do
        if autoFarmActive then
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
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
