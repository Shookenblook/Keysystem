-- [[ MANGOLOL OFFICIAL LOADER ]] --
local HttpService = game:GetService("HttpService")
local RbxAnalytics = game:GetService("RbxAnalyticsService")

-- CONFIG (Updated with your live ngrok link)
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev" 
local GITHUB_RAW = "https://raw.githubusercontent.com/Shookenblook/Mango/refs/heads/main/Mango.lua"

-- Use the key from the Discord bot here
_G.Key = _G.Key or "PASTE_YOUR_KEY_HERE"
local HWID = RbxAnalytics:GetClientId()

local function authenticate()
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
        return false, "Connection Error: Check if api.py is running on port 5000." 
    end

    local data
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)

    if not decodeSuccess then
        return false, "Server Error: Make sure your api.py terminal doesn't have errors."
    end

    return data.status == "success", data.message
end

local is_authed, message = authenticate()
if is_authed then
    print("✅ Success! Loading Mango...")
    loadstring(game:HttpGet(GITHUB_RAW))()
else
    game.Players.LocalPlayer:Kick("\n[Mango Auth]\n" .. tostring(message))
end
