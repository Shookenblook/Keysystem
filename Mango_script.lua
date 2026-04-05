local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev/verify"

local function CheckWhitelist()
    print("[Mango] Verifying access for " .. LocalPlayer.Name .. "...")
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
    print("✅ Whitelist Passed! Loading GUI...")

    -- GUI START
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MangoGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    local Win = Instance.new("Frame")
    Win.Name = "Window"
    Win.Size = UDim2.new(0, 500, 0, 400)
    Win.Position = UDim2.new(0.5, -250, 0.5, -200)
    Win.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Win.Parent = ScreenGui
    Instance.new("UICorner", Win)

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(255, 140, 30)
    TitleBar.Parent = Win
    Instance.new("UICorner", TitleBar)

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 1, 0)
    TitleLabel.Text = "🥭 MANGO PREMIUM - ACCESS GRANTED"
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar

    -- Draggable logic
    local dragging, dragStart, startPos
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)

    print("🥭 GUI LOADED SUCCESSFULLY")

else
    -- THIS RUNS IF YOU ARE NOT WHITELISTED
    warn("❌ ACCESS DENIED")
    LocalPlayer:Kick("\n[Mango]\nNot Whitelisted!\nDiscord: .gg/mango")
end
