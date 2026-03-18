-- 1. INITIALISATION ET SERVICES
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Nettoyage de l'ancienne version
if playerGui:FindFirstChild("AppleGui") then
    playerGui.AppleGui:Destroy()
end

-- 2. VARIABLES DE CONTRÔLE
local autoFarmActive = false
local antiAfkActive = false
local currentTPIndex = 1
local walkSpeedValue = 16
local sliding = false

-- Coordonnées des pommes
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

-- 3. CRÉATION DE L'INTERFACE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AppleGui"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Logo d'ouverture (60x60)
local logo = Instance.new("TextButton", screenGui)
logo.Name = "LogoButton"
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 20, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 35
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

-- Fenêtre principale (350x250)
local frame = Instance.new("Frame", screenGui)
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 350, 0, 250)
frame.Position = UDim2.new(0.5, -175, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

-- Barre de titre (Header / Drag)
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0.6, 0, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.Text = "Apple Incremental"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local credit = Instance.new("TextLabel", header)
credit.Size = UDim2.new(0.4, -40, 1, 0)
credit.Position = UDim2.new(1, -150, 0, 0)
credit.Text = "Made By RoScript"
credit.TextColor3 = Color3.fromRGB(180, 180, 180)
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

-- Scrolling Frame
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -85)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 320)
scroll.ScrollBarThickness = 3
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
farmTitle.Size = UDim2.new(0, 100, 0, 25)
farmTitle.Position = UDim2.new(0, 10, 0, 5)
farmTitle.Text = "FARM"
farmTitle.TextColor3 = Color3.fromRGB(255, 100, 100)
farmTitle.Font = Enum.Font.GothamBold
farmTitle.TextSize = 12
farmTitle.BackgroundTransparency = 1
farmTitle.TextXAlignment = Enum.TextXAlignment.Left

local labelAF = Instance.new("TextLabel", farmSection)
labelAF.Size = UDim2.new(0, 100, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 35)
labelAF.Text = "Auto Farm"
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.Font = Enum.Font.Gotham
labelAF.TextXAlignment = Enum.TextXAlignment.Left

local btnAF = Instance.new("TextButton", farmSection)
btnAF.Size = UDim2.new(0, 75, 0, 30)
btnAF.Position = UDim2.new(1, -85, 0, 35)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

--- SECTION MOVEMENT ---
local moveSection = Instance.new("Frame", scroll)
moveSection.Size = UDim2.new(0, 310, 0, 110)
moveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", moveSection)

local moveTitle = Instance.new("TextLabel", moveSection)
moveTitle.Size = UDim2.new(0, 100, 0, 25)
moveTitle.Position = UDim2.new(0, 10, 0, 5)
moveTitle.Text = "MOVEMENT"
moveTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
moveTitle.Font = Enum.Font.GothamBold
moveTitle.TextSize = 12
moveTitle.BackgroundTransparency = 1
moveTitle.TextXAlignment = Enum.TextXAlignment.Left

local labelWS = Instance.new("TextLabel", moveSection)
labelWS.Size = UDim2.new(0, 200, 0, 30)
labelWS.Position = UDim2.new(0, 10, 0, 35)
labelWS.Text = "WalkSpeed: 16"
labelWS.TextColor3 = Color3.new(1, 1, 1)
labelWS.BackgroundTransparency = 1
labelWS.Font = Enum.Font.Gotham
labelWS.TextXAlignment = Enum.TextXAlignment.Left

local sliderBack = Instance.new("Frame", moveSection)
sliderBack.Size = UDim2.new(0, 260, 0, 8)
sliderBack.Position = UDim2.new(0.5, -130, 0, 80)
sliderBack.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderBack)

local sliderBtn = Instance.new("Frame", sliderBack)
sliderBtn.Size = UDim2.new(0, 20, 0, 20)
sliderBtn.Position = UDim2.new(0, 0, 0.5, -10)
sliderBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Instance.new("UICorner", sliderBtn).CornerRadius = UDim.new(1, 0)

-- Bas de l'UI fixe
local btnAA = Instance.new("TextButton", frame)
btnAA.Size = UDim2.new(0, 100, 0, 26)
btnAA.Position = UDim2.new(0, 10, 1, -34)
btnAA.Text = "Anti-AFK: OFF"
btnAA.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnAA.TextColor3 = Color3.new(1, 1, 1)
btnAA.TextSize = 11
Instance.new("UICorner", btnAA)

local version = Instance.new("TextLabel", frame)
version.Size = UDim2.new(0, 50, 0, 20)
version.Position = UDim2.new(1, -60, 1, -28)
version.Text = "V1"
version.TextColor3 = Color3.fromRGB(120, 120, 120)
version.BackgroundTransparency = 1
version.Font = Enum.Font.Gotham
version.TextXAlignment = Enum.TextXAlignment.Right

-- 4. LOGIQUE DU SLIDER (MOBILE & PC)
local function updateSlider(input)
    local mouseX = input.Position.X
    local sliderX = sliderBack.AbsolutePosition.X
    local sliderWidth = sliderBack.AbsoluteSize.X
    local percentage = math.clamp((mouseX - sliderX) / sliderWidth, 0, 1)
    
    sliderBtn.Position = UDim2.new(percentage, -10, 0.5, -10)
    walkSpeedValue = math.floor(16 + (percentage * 234))
    labelWS.Text = "WalkSpeed: " .. walkSpeedValue
end

local function handleSliderInput(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = true
        scroll.ScrollingEnabled = false
        updateSlider(input)
    end
end

sliderBack.InputBegan:Connect(handleSliderInput)
sliderBtn.InputBegan:Connect(handleSliderInput)

UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        sliding = false
        scroll.ScrollingEnabled = true
    end
end)

-- Boucle pour appliquer la vitesse
RunService.Stepped:Connect(function()
    pcall(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = walkSpeedValue
        end
    end)
end)

-- 5. DRAG DE LA FENÊTRE
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

-- 6. FONCTIONS DES BOUTONS
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

-- Boucle Auto Farm (Téléporement)
task.spawn(function()
    while true do
        if autoFarmActive then
            pcall(function()
                local root = player.Character.HumanoidRootPart
                root.CFrame = CFrame.new(locations[currentTPIndex])
                currentTPIndex = (currentTPIndex % #locations) + 1
            end)
            task.wait(0.1)
        else
            task.wait(0.5)
        end
    end
end)

-- Logique Anti-AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then
        pcall(function()
            vu:CaptureController()
            vu:ClickButton2(Vector2.new())
        end)
    end
end)

print("RoScript V1 chargé !")
