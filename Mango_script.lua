local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- [[ CONFIGURATION ]] --
-- Change this to your current Ngrok URL (must end with /verify)
local NGROK_URL = "https://your-link.ngrok-free.dev/verify" 

local function CheckWhitelist()
    print("[Mango] Checking whitelist for " .. LocalPlayer.Name .. "...")
    
    -- This sends your UserID to your PC to see if you are whitelisted
    local success, response = pcall(function()
        return request({
            Url = NGROK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["ngrok-skip-browser-warning"] = "true" -- This bypasses the Ngrok warning page
            },
            Body = HttpService:JSONEncode({
                ["roblox_id"] = LocalPlayer.UserId
            })
        })
    end)

    if success and response.StatusCode == 200 then
        return true
    end
    return false
end

-- Run the check
if CheckWhitelist() then
    print("✅ Access Granted! Welcome, " .. LocalPlayer.Name)
    
    -- [[ PASTE YOUR ACTUAL GUI / SCRIPT CODE BELOW THIS LINE ]] --
    
    local sg = Instance.new("ScreenGui", LocalPlayer.PlayerGui)
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 200, 0, 100)
    f.Position = UDim2.new(0.5, -100, 0.5, -50)
    f.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    
    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1, 0, 1, 0)
    l.BackgroundTransparency = 1
    l.Text = "🥭 Mango Whitelist Active!"
    l.TextColor3 = Color3.new(1, 1, 1)
    
else
    -- This happens if the UserID isn't in your whitelist.db
    warn("❌ Access Denied: User " .. LocalPlayer.UserId .. " is not whitelisted.")
    LocalPlayer:Kick("\n[Mango Error]\nYou are not whitelisted.\nJoin the Discord and use !whitelist " .. LocalPlayer.UserId)
end
