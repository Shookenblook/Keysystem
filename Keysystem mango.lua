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
        return false, "Connection Error: Is the API and Ngrok running?" 
    end

    local data
    local decodeSuccess = pcall(function() 
        data = HttpService:JSONDecode(response.Body) 
    end)

    if not decodeSuccess then
        return false, "Server Error: Invalid Response Format."
    end

    if data.status == "success" then
        -- We store the secure session token from your Python API
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
    -- FINAL SECURITY CHECK
    if not _G.MangoSession then
        Players.LocalPlayer:Kick("\n[Mango Security]\nUnauthorized Execution.")
        return
    end

    -- ══════════════════════════════════════════
    -- YOUR FULL GUI CODE STARTS HERE
    -- ══════════════════════════════════════════
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

    -- STATE VARIABLES
    local flyEnabled = false
    local noclipEnabled = false
    local infiniteJump = false
    local godMode = false
    local antiAfk = false
    local camLockFeatureEnabled = false
    local camLockActive = false
    local camLockKey = Enum.KeyCode.F
    local triggerBotEnabled = false
    local triggerBotActive = false
    local triggerKey = Enum.KeyCode.E
    local fovEnabled = false
    local fovRadius = 120
    local lockSmooth = 0.2
    local camLockPrediction = 0.1
    local bulletTpEnabled = false

    -- [ HELPERS: getHum, getHRP, getClosestPlayer ]
    local function getHum() local c = Player.Character return c and c:FindFirstChildOfClass("Humanoid") end
    local function getHRP() local c = Player.Character return c and c:FindFirstChild("HumanoidRootPart") end

    local function getClosestPlayer()
        local cam = workspace.CurrentCamera
        local center = Vector2.new(Mouse.X, Mouse.Y)
        local closest = nil
        local closestDist = math.huge
        for _, plr in Players:GetPlayers() do
            if plr ~= Player and plr.Character then
                local head = plr.Character:FindFirstChild("Head")
                local hum = plr.Character:FindFirstChildOfClass("Humanoid")
                if head and hum and hum.Health > 0 then
                    local screenPos, onScreen = cam:WorldToScreenPoint(head.Position)
                    if onScreen then
                        local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                        if screenDist < fovRadius and screenDist < closestDist then
                            closestDist = screenDist
                            closest = plr
                        end
                    end
                end
            end
        end
        return closest
    end

    -- [ GUI INITIALIZATION CODE ]
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "MangoGUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = PlayerGui

    -- [ ALL YOUR UI BUTTONS, TOGGLES, AND TABS GO HERE ]
    -- ... Paste the rest of your UI layout and feature logic here ...

    print("✅ MangoGUI Fully Loaded with Session: " .. _G.MangoSession)
    _G.MangoSession = nil -- Clear the session for security
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
