-- [[ MANGOLOL INTEGRATED AUTH & GUI ]] --
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

print("[Mango] Script Starting...")

-- ══════════════════════════════════════════
-- CONFIGURATION
-- ══════════════════════════════════════════
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev" 
local currentKey = _G.Key or "PASTE_KEY_HERE"

print("[Mango] Using Key: " .. tostring(currentKey))

-- ══════════════════════════════════════════
-- AUTHENTICATION LOGIC
-- ══════════════════════════════════════════
local function AuthenticateUser()
    local HWID = RbxAnalytics:GetClientId()
    print("[Mango] HWID identified, sending request to API...")
    
    local success, response = pcall(function()
        return request({
            Url = NGROK_URL .. "/verify",
            Method = "POST",
            Headers = { 
                ["Content-Type"] = "application/json",
                ["ngrok-skip-browser-warning"] = "true" 
            },
            Body = HttpService:JSONEncode({
                license_key = currentKey,
                hwid = HWID
            })
        })
    end)

    if not success or not response then 
        print("[Mango] API Connection Failed. Is Ngrok open?")
        return false, "Connection Error." 
    end

    print("[Mango] Server responded with status: " .. tostring(response.StatusCode))

    local data
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)

    if not decodeSuccess then
        return false, "Server Error: Invalid Response."
    end

    if data.status == "success" then
        _G.MangoSession = "Authenticated"
        return true, data.message
    else
        return false, data.message
    end
end

-- ══════════════════════════════════════════
-- EXECUTION START
-- ══════════════════════════════════════════
local is_authed, auth_msg = AuthenticateUser()

if is_authed then
    print("[Mango] 🔓 Access Granted! Loading GUI...")
    -- YOUR GUI CODE START
    local ScreenGui = Instance.new("ScreenGui", Players.LocalPlayer:WaitForChild("PlayerGui"))
    local Frame = Instance.new("Frame", ScreenGui)
    Frame.Size = UDim2.new(0, 200, 0, 100)
    Frame.Position = UDim2.new(0.5, -100, 0.5, -50)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 140, 30)
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, 0, 1, 0)
    Label.Text = "MANGO LOADED"
    -- YOUR GUI CODE END
else
    print("[Mango] ❌ Access Denied: " .. tostring(auth_msg))
    Players.LocalPlayer:Kick("\n[Mango Auth]\n" .. tostring(auth_msg))
end
