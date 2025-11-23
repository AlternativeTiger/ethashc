--[[ Trap GUI with Player Dropdown Selector ]]--

-- GUI Setup
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "TrapGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 200)
frame.Position = UDim2.new(0, 50, 0, 50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local title = Instance.new("TextLabel", frame)
title.Text = "Trap Tool GUI"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(60,60,60)
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20

local playerDropdown = Instance.new("TextButton", frame)
playerDropdown.Position = UDim2.new(0, 10, 0, 40)
playerDropdown.Size = UDim2.new(1, -20, 0, 30)
playerDropdown.Text = "Select Player"
playerDropdown.BackgroundColor3 = Color3.fromRGB(40,40,40)
playerDropdown.TextColor3 = Color3.new(1,1,1)
playerDropdown.Font = Enum.Font.SourceSans
playerDropdown.TextSize = 16

local selectedPlayer = nil
local dropdownFrame = Instance.new("ScrollingFrame", frame)
dropdownFrame.Position = UDim2.new(0, 10, 0, 70)
dropdownFrame.Size = UDim2.new(1, -20, 0, 100)
dropdownFrame.BackgroundColor3 = Color3.fromRGB(50,50,50)
dropdownFrame.Visible = false
dropdownFrame.CanvasSize = UDim2.new(0,0,0,0)
dropdownFrame.ScrollBarThickness = 5

-- Create player buttons
local function refreshPlayerList()
    dropdownFrame:ClearAllChildren()
    local y = 0
    for _, player in ipairs(game.Players:GetPlayers()) do
        local button = Instance.new("TextButton", dropdownFrame)
        button.Position = UDim2.new(0, 0, 0, y)
        button.Size = UDim2.new(1, 0, 0, 25)
        button.Text = player.Name
        button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        button.TextColor3 = Color3.new(1,1,1)
        button.MouseButton1Click:Connect(function()
            selectedPlayer = player
            playerDropdown.Text = "Selected: " .. player.Name
            dropdownFrame.Visible = false
        end)
        y = y + 30
    end
    dropdownFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

playerDropdown.MouseButton1Click:Connect(function()
    refreshPlayerList()
    dropdownFrame.Visible = not dropdownFrame.Visible
end)

local boxSizeBox = Instance.new("TextBox", frame)
boxSizeBox.PlaceholderText = "Box Size (e.g. 4)"
boxSizeBox.Position = UDim2.new(0, 10, 0, 175)
boxSizeBox.Size = UDim2.new(0.5, -15, 0, 25)
boxSizeBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
boxSizeBox.TextColor3 = Color3.new(1,1,1)
boxSizeBox.Font = Enum.Font.SourceSans
boxSizeBox.TextSize = 16

local heightBox = Instance.new("TextBox", frame)
heightBox.PlaceholderText = "Height (e.g. 5)"
heightBox.Position = UDim2.new(0.5, 5, 0, 175)
heightBox.Size = UDim2.new(0.5, -15, 0, 25)
heightBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
heightBox.TextColor3 = Color3.new(1,1,1)
heightBox.Font = Enum.Font.SourceSans
heightBox.TextSize = 16

local trapButton = Instance.new("TextButton", frame)
trapButton.Text = "Trap Player"
trapButton.Position = UDim2.new(0, 10, 0, 150)
trapButton.Size = UDim2.new(0.5, -15, 0, 25)
trapButton.BackgroundColor3 = Color3.fromRGB(20,150,20)
trapButton.TextColor3 = Color3.new(1,1,1)
trapButton.Font = Enum.Font.SourceSansBold
trapButton.TextSize = 16

local releaseButton = Instance.new("TextButton", frame)
releaseButton.Text = "Release Player"
releaseButton.Position = UDim2.new(0.5, 5, 0, 150)
releaseButton.Size = UDim2.new(0.5, -15, 0, 25)
releaseButton.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
releaseButton.TextColor3 = Color3.new(1,1,1)
releaseButton.Font = Enum.Font.SourceSansBold
releaseButton.TextSize = 16

-- Trap Logic
local trapParts = {}

trapButton.MouseButton1Click:Connect(function()
    if not selectedPlayer or not selectedPlayer.Character or not selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local boxSize = tonumber(boxSizeBox.Text) or 4
    local height = tonumber(heightBox.Text) or 5
    local pos = selectedPlayer.Character.HumanoidRootPart.Position

    for x = -1, 1 do
        for y = 0, height - 1 do
            for z = -1, 1 do
                if not (x == 0 and z == 0) then
                    local part = Instance.new("Part", workspace)
                    part.Anchored = true
                    part.CanCollide = true
                    part.Size = Vector3.new(boxSize, boxSize, boxSize)
                    part.Position = pos + Vector3.new(x * boxSize, y * boxSize, z * boxSize)
                    part.Material = Enum.Material.SmoothPlastic
                    part.BrickColor = BrickColor.new("Dark stone grey")
                    table.insert(trapParts, part)
                end
            end
        end
    end

    selectedPlayer.Character.HumanoidRootPart.Anchored = true
end)

releaseButton.MouseButton1Click:Connect(function()
    for _, part in ipairs(trapParts) do
        if part and part.Parent then
            part:Destroy()
        end
    end
    trapParts = {}

    if selectedPlayer and selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
        selectedPlayer.Character.HumanoidRootPart.Anchored = false
    end
end)
