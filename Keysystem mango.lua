-- [[ MANGOLOL INTEGRATED AUTH & GUI ]] --
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")
local Players = game:GetService("Players")

-- ══════════════════════════════════════════
-- CONFIGURATION
-- ══════════════════════════════════════════
-- Ensure this URL matches your active Ngrok window!
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev" 
-- This line checks if _G.Key exists; otherwise, it uses the placeholder.
local currentKey = _G.Key or "PASTE_KEY_HERE"

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
                license_key = currentKey, -- Fixed: Using currentKey instead of _G.Key directly
                hwid = HWID
            })
        })
    end)

    if not success or not response then 
        return false, "Connection Error: Check Ngrok/API." 
    end

    local data
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)

    if not decodeSuccess then
        return false, "Server Error: Invalid Format."
    end

    if data.status == "success" then
        _G.MangoSession = "Authenticated" -- Simple session marker
        return true, data.message
    else
        return false, data.message
    end
end

-- ══════════════════════════════════════════
-- THE MAIN MANGO GUI FUNCTION
-- ══════════════════════════════════════════
local function LoadMangoGUI()
    if not _G.MangoSession then
        Players.LocalPlayer:Kick("\n[Mango Security]\nUnauthorized Execution.")
        return
    end

    -- [ PLACE YOUR GUI CODE BELOW ]
    print("✅ MangoGUI Fully Loaded!")
end

-- ══════════════════════════════════════════
-- EXECUTION START
-- ══════════════════════════════════════════
local is_authed, auth_msg = AuthenticateUser()

if is_authed then
    print("🔓 Access Granted: " .. auth_msg)
    LoadMangoGUI()
else
    Players.LocalPlayer:Kick("\n[Mango Auth]\n" .. tostring(auth_msg))
end
