-- 1. SERVICES
local player = game:GetService("Players").LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Nettoyage
if playerGui:FindFirstChild("AppleAutoFarmGui") then
    playerGui.AppleAutoFarmGui:Destroy()
end

-- 2. VARIABLES
local autoFarmActive = false
local antiAfkActive = false
local currentTPIndex = 1
local walkSpeedValue = 16
local jumpPowerValue = 50
local farmWaitTime = 1.0 -- Valeur par défaut (1 seconde)

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

-- 3. INTERFACE
local screenGui = Instance.new("ScreenGui", playerGui)
screenGui.Name = "AppleAutoFarmGui"
screenGui.ResetOnSpawn = false

local logo = Instance.new("TextButton", screenGui)
logo.Size = UDim2.new(0, 60, 0, 60)
logo.Position = UDim2.new(0, 20, 0, 150)
logo.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
logo.Text = "🍎"
logo.TextSize = 35
Instance.new("UICorner", logo).CornerRadius = UDim.new(0, 12)

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 350, 0, 300)
frame.Position = UDim2.new(0.5, -175, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Visible = false
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

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
title.TextSize = 14
title.BackgroundTransparency = 1
title.TextXAlignment = Enum.TextXAlignment.Left

local headerCredit = Instance.new("TextLabel", header)
headerCredit.Size = UDim2.new(0, 100, 1, 0)
headerCredit.Position = UDim2.new(1, -140, 0, 0)
headerCredit.Text = "Made By RoScript"
headerCredit.TextColor3 = Color3.fromRGB(200, 200, 200)
headerCredit.Font = Enum.Font.Gotham
headerCredit.TextSize = 10
headerCredit.BackgroundTransparency = 1
headerCredit.TextXAlignment = Enum.TextXAlignment.Right

local close = Instance.new("TextButton", header)
close.Size = UDim2.new(0, 28, 0, 28)
close.Position = UDim2.new(1, -34, 0, 6)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
close.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", close)

local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -85)
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 480)
scroll.ScrollBarThickness = 2

local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0, 10)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

--- SECTION FARM (Avec Speed Slider) ---
local farmSection = Instance.new("Frame", scroll)
farmSection.Size = UDim2.new(0, 310, 0, 140)
farmSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", farmSection)

local labelAF = Instance.new("TextLabel", farmSection)
labelAF.Size = UDim2.new(0, 150, 0, 30)
labelAF.Position = UDim2.new(0, 10, 0, 10)
labelAF.Text = "Auto Farm"
labelAF.TextColor3 = Color3.new(1, 1, 1)
labelAF.BackgroundTransparency = 1
labelAF.Font = Enum.Font.GothamBold
labelAF.TextSize = 18
labelAF.TextXAlignment = Enum.TextXAlignment.Left

local btnAF = Instance.new("TextButton", farmSection)
btnAF.Size = UDim2.new(0, 80, 0, 30)
btnAF.Position = UDim2.new(1, -90, 0, 10)
btnAF.Text = "OFF"
btnAF.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAF.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAF)

local labelFS = Instance.new("TextLabel", farmSection)
labelFS.Size = UDim2.new(0, 200, 0, 20)
labelFS.Position = UDim2.new(0, 10, 0, 60)
labelFS.Text = "Farm Speed: 1.00s"
labelFS.TextColor3 = Color3.fromRGB(200, 200, 200)
labelFS.BackgroundTransparency = 1
labelFS.Font = Enum.Font.Gotham
labelFS.TextSize = 14
labelFS.TextXAlignment = Enum.TextXAlignment.Left

local sliderBackFS = Instance.new("Frame", farmSection)
sliderBackFS.Size = UDim2.new(0, 260, 0, 6)
sliderBackFS.Position = UDim2.new(0.5, -130, 0, 100)
sliderBackFS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderBackFS)

local dotFS = Instance.new("Frame", sliderBackFS)
dotFS.Size = UDim2.new(0, 18, 0, 18)
dotFS.Position = UDim2.new(0.2, -9, 0.5, -9) -- Position par défaut vers 1s
dotFS.BackgroundColor3 = Color3.fromRGB(150, 255, 150)
Instance.new("UICorner", dotFS).CornerRadius = UDim.new(1, 0)

--- SECTION MOVEMENT ---
local moveSection = Instance.new("Frame", scroll)
moveSection.Size = UDim2.new(0, 310, 0, 160)
moveSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", moveSection)

-- WS Slider
local labelWS = Instance.new("TextLabel", moveSection)
labelWS.Size = UDim2.new(0, 200, 0, 20)
labelWS.Position = UDim2.new(0, 10, 0, 20)
labelWS.Text = "WalkSpeed: 16"
labelWS.TextColor3 = Color3.new(1, 1, 1)
labelWS.BackgroundTransparency = 1

local sliderWS = Instance.new("Frame", moveSection)
sliderWS.Size = UDim2.new(0, 260, 0, 6)
sliderWS.Position = UDim2.new(0.5, -130, 0, 50)
sliderWS.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderWS)

local dotWS = Instance.new("Frame", sliderWS)
dotWS.Size = UDim2.new(0, 18, 0, 18)
dotWS.Position = UDim2.new(0, 0, 0.5, -9)
dotWS.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
Instance.new("UICorner", dotWS).CornerRadius = UDim.new(1, 0)

-- JP Slider
local labelJP = Instance.new("TextLabel", moveSection)
labelJP.Size = UDim2.new(0, 200, 0, 20)
labelJP.Position = UDim2.new(0, 10, 0, 90)
labelJP.Text = "JumpPower: 50"
labelJP.TextColor3 = Color3.new(1, 1, 1)
labelJP.BackgroundTransparency = 1

local sliderJP = Instance.new("Frame", moveSection)
sliderJP.Size = UDim2.new(0, 260, 0, 6)
sliderJP.Position = UDim2.new(0.5, -130, 0, 120)
sliderJP.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Instance.new("UICorner", sliderJP)

local dotJP = Instance.new("Frame", sliderJP)
dotJP.Size = UDim2.new(0, 18, 0, 18)
dotJP.Position = UDim2.new(0, 0, 0.5, -9)
dotJP.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
Instance.new("UICorner", dotJP).CornerRadius = UDim.new(1, 0)

--- SECTION ANTI-AFK ---
local afkSection = Instance.new("Frame", scroll)
afkSection.Size = UDim2.new(0, 310, 0, 60)
afkSection.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Instance.new("UICorner", afkSection)

local labelAA = Instance.new("TextLabel", afkSection)
labelAA.Size = UDim2.new(0, 150, 0, 30)
labelAA.Position = UDim2.new(0, 10, 0.5, -15)
labelAA.Text = "Anti-AFK"
labelAA.TextColor3 = Color3.new(1, 1, 1)
labelAA.BackgroundTransparency = 1
labelAA.Font = Enum.Font.Gotham
labelAA.TextXAlignment = Enum.TextXAlignment.Left

local btnAA = Instance.new("TextButton", afkSection)
btnAA.Size = UDim2.new(0, 80, 0, 30)
btnAA.Position = UDim2.new(1, -90, 0.5, -15)
btnAA.Text = "OFF"
btnAA.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
btnAA.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", btnAA)

local footerVersion = Instance.new("TextLabel", frame)
footerVersion.Size = UDim2.new(0, 120, 0, 20)
footerVersion.Position = UDim2.new(1, -130, 1, -25)
footerVersion.Text = "v1 (More soon)"
footerVersion.TextColor3 = Color3.fromRGB(120, 120, 120)
footerVersion.BackgroundTransparency = 1
footerVersion.Font = Enum.Font.Gotham
footerVersion.TextSize = 11
footerVersion.TextXAlignment = Enum.TextXAlignment.Right

-- 4. DRAG LOGIC (FENÊTRE COMPLÈTE)
local function makeDraggable(obj, target)
    target = target or obj
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true dragStart = input.Position startPos = target.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            target.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    obj.InputEnded:Connect(function(input) dragging = false end)
end

makeDraggable(logo)
makeDraggable(frame)
makeDraggable(header, frame)

-- 5. SLIDERS LOGIC
local function setupSlider(back, dot, min, max, isDecimal, callback)
    local isSliding = false
    local function update(input)
        local relPos = math.clamp((input.Position.X - back.AbsolutePosition.X) / back.AbsoluteSize.X, 0, 1)
        dot.Position = UDim2.new(relPos, -9, 0.5, -9)
        local val = min + (relPos * (max - min))
        if not isDecimal then val = math.floor(val) end
        callback(val)
    end
    back.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true scroll.ScrollingEnabled = false update(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    UserInputService.InputEnded:Connect(function() isSliding = false scroll.ScrollingEnabled = true end)
end

-- Sliders Setup
setupSlider(sliderBackFS, dotFS, 0.01, 5, true, function(v) 
    farmWaitTime = v 
    labelFS.Text = string.format("Farm Speed: %.2fs", v) 
end)
setupSlider(sliderWS, dotWS, 16, 250, false, function(v) walkSpeedValue = v labelWS.Text = "WalkSpeed: "..v end)
setupSlider(sliderJP, dotJP, 50, 350, false, function(v) jumpPowerValue = v labelJP.Text = "JumpPower: "..v end)

-- 6. FONCTIONNEMENT
local lastLogoPos = logo.Position
logo.MouseButton1Up:Connect(function()
    if (logo.Position.X.Offset - lastLogoPos.X.Offset) == 0 then frame.Visible = not frame.Visible end
    lastLogoPos = logo.Position
end)

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

RunService.Stepped:Connect(function()
    pcall(function()
        local hum = player.Character.Humanoid
        hum.WalkSpeed = walkSpeedValue
        hum.UseJumpPower = true
        hum.JumpPower = jumpPowerValue
    end)
end)

task.spawn(function()
    while true do
        if autoFarmActive then
            pcall(function()
                player.Character.HumanoidRootPart.CFrame = CFrame.new(locations[currentTPIndex])
                currentTPIndex = (currentTPIndex % #locations) + 1
            end)
            task.wait(farmWaitTime) -- Utilise la valeur du slider
        else task.wait(0.5) end
    end
end)

local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    if antiAfkActive then pcall(function() vu:CaptureController() vu:ClickButton2(Vector2.new()) end) end
end)
