-- Delta Easy-Flick Speed Glitch (150 Speed)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera

-- Create ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FlickGlitchUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Floating Main Button Frame
local SGButton = Instance.new("TextButton")
SGButton.Name = "SGButton"
SGButton.Size = UDim2.new(0, 55, 0, 55)
SGButton.Position = UDim2.new(0.85, -27, 0.4, -27)
SGButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
SGButton.BorderSizePixel = 0
SGButton.Text = ""
SGButton.Active = true
SGButton.Draggable = true
SGButton.Parent = ScreenGui

-- Rounded Corners & Outer Ring
local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 14)
Corner.Parent = SGButton

local Stroke = Instance.new("UIStroke")
Stroke.Color = Color3.fromRGB(120, 40, 40) -- Red/Off outline
Stroke.Thickness = 2
Stroke.Parent = SGButton

-- Top Text: "SG"
local SGLabel = Instance.new("TextLabel")
SGLabel.Name = "SGLabel"
SGLabel.Size = UDim2.new(1, 0, 0.55, 0)
SGLabel.Position = UDim2.new(0, 0, 0.05, 0)
SGLabel.BackgroundTransparency = 1
SGLabel.Text = "SG"
SGLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SGLabel.Font = Enum.Font.GothamBold
SGLabel.TextSize = 18
SGLabel.Parent = SGButton

-- Bottom Text: Status ("OFF" / "ON")
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Name = "StatusLabel"
StatusLabel.Size = UDim2.new(1, 0, 0.35, 0)
StatusLabel.Position = UDim2.new(0, 0, 0.55, 0)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "OFF"
StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
StatusLabel.Font = Enum.Font.GothamBold
StatusLabel.TextSize = 11
StatusLabel.Parent = SGButton

-- Variables
local scriptActive = false
local defaultSpeed = 16
local glitchSpeed = 150
local lastCameraCFrame = Camera.CFrame
local flickTimer = 0

-- Easy-Flick Detection Loop
RunService.RenderStepped:Connect(function(dt)
    if scriptActive then
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                local currentCFrame = Camera.CFrame
                -- Measure angle change between frames
                local rotationAngle = math.acos(math.clamp(lastCameraCFrame.LookVector:Dot(currentCFrame.LookVector), -1, 1))
                lastCameraCFrame = currentCFrame
                
                -- Lowered threshold (0.18) and longer timer (0.4s) for much easier flicking
                if rotationAngle > 0.18 then
                    flickTimer = 0.4 
                elseif flickTimer > 0 then
                    flickTimer = flickTimer - dt
                end
                
                -- Check character states
                local isMoving = humanoid.MoveDirection.Magnitude > 0
                local currentState = humanoid:GetState()
                local isJumpingOrAirborne = (currentState == Enum.HumanoidStateType.Jumping or currentState == Enum.HumanoidStateType.Freefall)
                
                -- MUST be moving, airborne (jumping), AND have recent flick input
                if isMoving and isJumpingOrAirborne and flickTimer > 0 then
                    humanoid.WalkSpeed = glitchSpeed
                else
                    humanoid.WalkSpeed = defaultSpeed -- Instantly reset when landing or running normally
                end
            end
        end
    end
end)

-- Toggle Functionality
SGButton.MouseButton1Click:Connect(function()
    scriptActive = not scriptActive
    
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    
    if scriptActive then
        -- ON State
        StatusLabel.Text = "ON"
        StatusLabel.TextColor3 = Color3.fromRGB(80, 255, 120)
        Stroke.Color = Color3.fromRGB(0, 255, 120)
        SGButton.BackgroundColor3 = Color3.fromRGB(20, 45, 30)
    else
        -- OFF State
        StatusLabel.Text = "OFF"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
        Stroke.Color = Color3.fromRGB(120, 40, 40)
        SGButton.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        if humanoid then humanoid.WalkSpeed = defaultSpeed end
    end
end)
