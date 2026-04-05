-- [[ MANGOLOL INTEGRATED AUTH & GUI ]] --
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

-- ══════════════════════════════════════════
-- CONFIGURATION
-- ══════════════════════════════════════════
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev" 
_G.Key = _G.Key or "PASTE_KEY_HERE"

-- ══════════════════════════════════════════
-- AUTHENTICATION LOGIC
-- ══════════════════════════════════════════
local function AuthenticateUser()
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
        return false, "Connection Error: Check if your API and Ngrok are running." 
    end

    local data
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)

    if not decodeSuccess then
        return false, "Server Error: JSON Parsing Failed."
    end

    if data.status == "success" then
        -- The Python API sends a 'session' token. We store it to verify the GUI.
        _G.MangoSession = data.session 
        return true, data.message
    else
        return false, data.message
    end
end

-- ══════════════════════════════════════════
-- THE MAIN MANGO GUI FUNCTION
-- ══════════════════════════════════════════
local function LoadMangoGUI()
    -- SECURITY CHECK: If someone tried to bypass the auth, this kicks them.
    if not _G.MangoSession then
        Players.LocalPlayer:Kick("Unauthorized Execution.")
        return
    end

    -- YOUR FULL GUI CODE STARTS HERE
    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local Player = Players.LocalPlayer
    local PlayerGui = Player:WaitForChild("PlayerGui")
    local Mouse = Player:GetMouse()

    local ORANGE = Color3.fromRGB(255, 140, 30)
    local BG = Color3.fromRGB(18, 18, 20)
    local CARD = Color3.fromRGB(28, 28, 32)
    local SIDEBAR = Color3.fromRGB(14, 14, 16)
    local TEXT = Color3.fromRGB(225, 225, 225)
    local SUBTEXT = Color3.fromRGB(140, 140, 150)
    local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad)

    -- [INSERT ALL YOUR STATE VARIABLES HERE: flyEnabled, noclipEnabled, etc.]
    -- [INSERT ALL YOUR GUI CREATION CODE HERE: ScreenGui, Win, Tabs, etc.]
    -- [INSERT ALL YOUR FEATURE LOOPS HERE: Fly, Noclip, ESP, etc.]

    print("✅ MangoGUI Loaded for Session: " .. _G.MangoSession)
    _G.MangoSession = nil -- Clear it so it can't be reused
end

-- ══════════════════════════════════════════
-- EXECUTION START
-- ══════════════════════════════════════════
local authed, msg = AuthenticateUser()

if authed then
    print("🔓 Access Granted: " .. msg)
    LoadMangoGUI()
else
    Players.LocalPlayer:Kick("\n[Mango Auth]\n" .. tostring(msg))
end
