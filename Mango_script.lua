local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev/verify"

local function CheckWhitelist()
    print("[Mango] Checking whitelist for " .. LocalPlayer.Name .. "...")
    local success, response = pcall(function()
        return request({
            Url = NGROK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["ngrok-skip-browser-warning"] = "true"
            },
            Body = HttpService:JSONEncode({
                ["roblox_id"] = LocalPlayer.UserId
            })
        })
    end)
    return success and response.StatusCode == 200
end

-- ══════════════════════════════════════════
-- MAIN EXECUTION
-- ══════════════════════════════════════════
if CheckWhitelist() then
    print("✅ Access Granted! Welcome, " .. LocalPlayer.Name)

    -- Your GUI Code Starts Here
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local Player = LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local Mouse = Player:GetMouse()

    -- Colors
    local ORANGE = Color3.fromRGB(255, 140, 30)
    local BG = Color3.fromRGB(18, 18, 20)
    local SIDEBAR = Color3.fromRGB(14, 14, 16)
    local TEXT = Color3.fromRGB(225, 225, 225)

    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MangoGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- Main Window
    local Win = Instance.new("Frame")
    Win.Name = "Window"
    Win.Size = UDim2.new(0, 640, 0, 520)
    Win.Position = UDim2.new(0.5, -320, 0.5, -260)
    Win.BackgroundColor3 = BG
    Win.Parent = ScreenGui
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)

    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 46)
    TitleBar.BackgroundColor3 = SIDEBAR
    TitleBar.Parent = Win
    Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 10)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "🥭 MANGO v2.4"
    TitleLabel.TextColor3 = ORANGE
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = TitleBar

    -- [ Dragging Script ]
    local dragging, dragInput, dragStart, startPos
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = Win.Position
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    print("🥭 Mango GUI has successfully loaded!")

else
    -- ❌ Access Denied: This part handles the kick
    warn("❌ Whitelist check failed.")
    LocalPlayer:Kick("\n[Mango Error]\nYou are not whitelisted.\nJoin the Discord to get access!")
end
