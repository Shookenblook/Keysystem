-- [[ MANGOLOL INTEGRATED AUTH & GUI - DIRECT TEST ]] --
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

-- ══════════════════════════════════════════
-- CONFIGURATION
-- ══════════════════════════════════════════
-- [[ CONFIGURATION ON GITHUB ]] --
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev" -- <--- UPDATE THIS
local HttpService = game:GetService("HttpService")

-- ══════════════════════════════════════════
-- AUTHENTICATION LOGIC
-- ══════════════════════════════════════════
local function AuthenticateUser()
    print("[Mango] Starting Auth...")
    local HWID = RbxAnalytics:GetClientId()
    
    local success, response = pcall(function()
        return request({
            Url = NGROK_URL .. "/verify",
            Method = "POST",
            Headers = { 
                ["Content-Type"] = "application/json", 
                ["ngrok-skip-browser-warning"] = "true" 
            },
            Body = HttpService:JSONEncode({
                license_key = _G.Key,
                hwid = HWID
            })
        })
    end)

    if not success or not response then 
        warn("[Mango] ERROR: Connection failed. Check Ngrok/API.")
        return false, "Connection Error" 
    end

    local data = HttpService:JSONDecode(response.Body)

    if data.status == "success" then
        return true, data.message
    else
        return false, data.message
    end
end

-- ══════════════════════════════════════════
-- THE MAIN MANGO GUI FUNCTION
-- ══════════════════════════════════════════
local function LoadMangoGUI()
    local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    ScreenGui.Name = "MangoTestGUI"

    local MainFrame = Instance.new("Frame", ScreenGui)
    MainFrame.Size = UDim2.new(0, 300, 0, 150)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 0

    local Title = Instance.new("TextLabel", MainFrame)
    Title.Size = UDim2.new(1, 0, 0, 40)
    Title.Text = "🥭 MANGOLOL LOADED"
    Title.TextColor3 = Color3.fromRGB(255, 140, 30)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 20

    local Status = Instance.new("TextLabel", MainFrame)
    Status.Size = UDim2.new(1, 0, 0, 80)
    Status.Position = UDim2.new(0, 0, 0, 50)
    Status.Text = "Authentication Successful!\nWelcome back."
    Status.TextColor3 = Color3.fromRGB(255, 255, 255)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.Gotham
    Status.TextSize = 14

    print("✅ MangoGUI Successfully Loaded!")
end

-- ══════════════════════════════════════════
-- EXECUTION START
-- ══════════════════════════════════════════
local is_authed, auth_msg = AuthenticateUser()

if is_authed then
    print("🔓 Access Granted: " .. auth_msg)
    LoadMangoGUI()
else
    print("❌ Access Denied: " .. tostring(auth_msg))
    Players.LocalPlayer:Kick("\n[Mango Auth]\n" .. tostring(auth_msg))
end
