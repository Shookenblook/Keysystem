-- MangoGUI.lua -- LocalScript → StarterGui
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local VirtualUser      = game:GetService("VirtualUser")
local Player           = Players.LocalPlayer
local PlayerGui        = Player:WaitForChild("PlayerGui")

-- ══════════════════════════════════════════
-- WHITELIST
-- ══════════════════════════════════════════
local NGROK_URL = "https://subventionary-letha-boughten.ngrok-free.dev/verify"

local function CheckWhitelist()
	local success, response = pcall(function()
		return request({
			Url    = NGROK_URL,
			Method = "POST",
			Headers = {
				["Content-Type"]               = "application/json",
				["ngrok-skip-browser-warning"] = "true",
			},
			Body = HttpService:JSONEncode({ roblox_id = Player.UserId }),
		})
	end)
	return success and response and response.StatusCode == 200
end

local SplashGui = Instance.new("ScreenGui")
SplashGui.Name           = "MangoSplash"
SplashGui.ResetOnSpawn   = false
SplashGui.IgnoreGuiInset = true
SplashGui.DisplayOrder   = 999
SplashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SplashGui.Parent         = PlayerGui

local SplashBG = Instance.new("Frame")
SplashBG.Size             = UDim2.new(1,0,1,0)
SplashBG.BackgroundColor3 = Color3.fromRGB(10,10,12)
SplashBG.BorderSizePixel  = 0
SplashBG.Parent           = SplashGui

local SplashCard = Instance.new("Frame")
SplashCard.Size             = UDim2.new(0,320,0,160)
SplashCard.AnchorPoint      = Vector2.new(0.5,0.5)
SplashCard.Position         = UDim2.new(0.5,0,0.45,0)
SplashCard.BackgroundColor3 = Color3.fromRGB(18,18,20)
SplashCard.BorderSizePixel  = 0
SplashCard.Parent           = SplashBG
Instance.new("UICorner",SplashCard).CornerRadius = UDim.new(0,12)

local SplashStroke = Instance.new("UIStroke")
SplashStroke.Color     = Color3.fromRGB(255,140,30)
SplashStroke.Thickness = 1.5
SplashStroke.Parent    = SplashCard

local SplashLogo = Instance.new("TextLabel")
SplashLogo.Size             = UDim2.new(0,44,0,44)
SplashLogo.AnchorPoint      = Vector2.new(0.5,0)
SplashLogo.Position         = UDim2.new(0.5,0,0,22)
SplashLogo.BackgroundColor3 = Color3.fromRGB(30,30,35)
SplashLogo.BorderSizePixel  = 0
SplashLogo.Text             = "M"
SplashLogo.TextColor3       = Color3.fromRGB(255,140,30)
SplashLogo.TextSize         = 22
SplashLogo.Font             = Enum.Font.GothamBold
SplashLogo.Parent           = SplashCard
Instance.new("UICorner",SplashLogo).CornerRadius = UDim.new(0,8)

local SplashTitle = Instance.new("TextLabel")
SplashTitle.Size                 = UDim2.new(1,-20,0,20)
SplashTitle.Position             = UDim2.new(0,10,0,76)
SplashTitle.BackgroundTransparency = 1
SplashTitle.Text                 = "MANGO"
SplashTitle.TextColor3           = Color3.fromRGB(225,225,225)
SplashTitle.TextSize             = 16
SplashTitle.Font                 = Enum.Font.GothamBold
SplashTitle.Parent               = SplashCard

local SplashSub = Instance.new("TextLabel")
SplashSub.Size                 = UDim2.new(1,-20,0,16)
SplashSub.Position             = UDim2.new(0,10,0,98)
SplashSub.BackgroundTransparency = 1
SplashSub.Text                 = "Checking whitelist..."
SplashSub.TextColor3           = Color3.fromRGB(140,140,150)
SplashSub.TextSize             = 12
SplashSub.Font                 = Enum.Font.Gotham
SplashSub.Parent               = SplashCard

local SplashBarBG = Instance.new("Frame")
SplashBarBG.Size             = UDim2.new(1,-24,0,4)
SplashBarBG.Position         = UDim2.new(0,12,1,-18)
SplashBarBG.BackgroundColor3 = Color3.fromRGB(40,40,45)
SplashBarBG.BorderSizePixel  = 0
SplashBarBG.Parent           = SplashCard
Instance.new("UICorner",SplashBarBG).CornerRadius = UDim.new(1,0)

local SplashBar = Instance.new("Frame")
SplashBar.Size             = UDim2.new(0,0,1,0)
SplashBar.BackgroundColor3 = Color3.fromRGB(255,140,30)
SplashBar.BorderSizePixel  = 0
SplashBar.Parent           = SplashBarBG
Instance.new("UICorner",SplashBar).CornerRadius = UDim.new(1,0)

TweenService:Create(SplashBar, TweenInfo.new(1.2,Enum.EasingStyle.Quad,Enum.EasingDirection.InOut),
	{ Size = UDim2.new(0.85,0,1,0) }):Play()
SplashCard.Position = UDim2.new(0.5,0,0.6,0)
SplashCard.BackgroundTransparency = 1
TweenService:Create(SplashCard, TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
	{ Position = UDim2.new(0.5,0,0.45,0), BackgroundTransparency = 0 }):Play()

local granted = CheckWhitelist()

if not granted then
	TweenService:Create(SplashBar, TweenInfo.new(0.3,Enum.EasingStyle.Quad),
		{ Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(210,55,55) }):Play()
	SplashSub.Text       = "❌  Not whitelisted."
	SplashSub.TextColor3 = Color3.fromRGB(210,100,100)
	SplashStroke.Color   = Color3.fromRGB(210,55,55)
	SplashTitle.Text     = "Access Denied"
	task.wait(3)
	TweenService:Create(SplashBG,   TweenInfo.new(0.4,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
	TweenService:Create(SplashCard, TweenInfo.new(0.4,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
	task.wait(0.4)
	SplashGui:Destroy()
	return
end

print("✅ Access Granted! Loading Mango Premium...")
SplashSub.Text       = "✅  Access granted!"
SplashSub.TextColor3 = Color3.fromRGB(80,210,120)
TweenService:Create(SplashBar, TweenInfo.new(0.3,Enum.EasingStyle.Quad),
	{ Size = UDim2.new(1,0,1,0), BackgroundColor3 = Color3.fromRGB(60,210,90) }):Play()
task.wait(0.8)
TweenService:Create(SplashBG,   TweenInfo.new(0.35,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
TweenService:Create(SplashCard, TweenInfo.new(0.35,Enum.EasingStyle.Quad),{BackgroundTransparency=1}):Play()
task.wait(0.35)
SplashBG.Visible = false
SplashGui:Destroy()

local Mouse = Player:GetMouse()

local ORANGE     = Color3.fromRGB(255,140,30)
local BG         = Color3.fromRGB(18,18,20)
local CARD       = Color3.fromRGB(28,28,32)
local SIDEBAR    = Color3.fromRGB(14,14,16)
local TEXT       = Color3.fromRGB(225,225,225)
local SUBTEXT    = Color3.fromRGB(140,140,150)
local TWEEN_FAST = TweenInfo.new(0.15,Enum.EasingStyle.Quad)

-- ══════════════════════════════════════════
-- STATE
-- ══════════════════════════════════════════
local flyEnabled       = false
local noclipEnabled    = false
local infiniteJump     = false
local godMode          = false
local antiAfk          = false
local invisibleEnabled = false
local silentAimEnabled = false
local bulletTpEnabled  = false
local fovEnabled       = false
local fovRadius        = 120
local bv, bg
local oldNamecall      = nil

local aimbotEnabled = false
local aimbotHolding = false
local aimbotTarget  = nil
local aimbotKey     = Enum.KeyCode.Q
local aimbotSmooth  = 0.12
local aimbotPart    = "Head"

local triggerEnabled = false
local triggerHolding = false
local triggerKey     = Enum.KeyCode.E
local triggerChance  = 100

local freecamEnabled = false
local freecamConn    = nil
local freecamPos     = Vector3.zero
local freecamPitch   = 0
local freecamYaw     = 0
local freecamSpeed   = 40

-- ══════════════════════════════════════════
-- CAM LOCK STATE (ttwizz Open Aimbot style)
-- ══════════════════════════════════════════
local camLockEnabled    = false
local camLockKey        = Enum.KeyCode.F
local camLockPrediction = 0.1
local lockSmooth        = 0.2
local camLockTarget     = nil  -- the Character model (not Player)
local camLockConn       = nil
local camLockTween      = nil

local espEnabled = false
local espNames   = true
local espHealth  = true
local espBoxes   = true
local espChams   = false
local espObjects = {}

-- ══════════════════════════════════════════
-- HELPERS
-- ══════════════════════════════════════════
local function getHum()
	local c = Player.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end
local function getHRP()
	local c = Player.Character
	return c and c:FindFirstChild("HumanoidRootPart")
end

local function getClosestPlayer()
	local cam      = workspace.CurrentCamera
	local mousePos = Vector2.new(Mouse.X, Mouse.Y)
	local closest, closestDist = nil, math.huge
	for _, plr in Players:GetPlayers() do
		if plr ~= Player and plr.Character then
			local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
			local hum = plr.Character:FindFirstChildOfClass("Humanoid")
			if hrp and hum and hum.Health > 0 then
				local sp, onScreen = cam:WorldToScreenPoint(hrp.Position)
				if onScreen then
					local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
					if d < fovRadius and d < closestDist then
						closestDist = d
						closest     = plr
					end
				end
			end
		end
	end
	return closest
end

local function getAimbotTarget()
	local cam      = workspace.CurrentCamera
	local mousePos = UserInputService:GetMouseLocation()
	local closest, closestDist = nil, math.huge
	for _, plr in Players:GetPlayers() do
		if plr ~= Player and plr.Character then
			local part = plr.Character:FindFirstChild(aimbotPart)
			             or plr.Character:FindFirstChild("Head")
			             or plr.Character:FindFirstChild("HumanoidRootPart")
			local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
			if part and hum and hum.Health > 0 then
				local sp, onScreen = cam:WorldToViewportPoint(part.Position)
				if onScreen then
					local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
					if d < fovRadius and d < closestDist then
						closestDist = d
						closest     = plr
					end
				end
			end
		end
	end
	return closest
end

-- ══════════════════════════════════════════
-- SCREEN GUI
-- ══════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name           = "MangoGUI"
ScreenGui.ResetOnSpawn   = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent         = PlayerGui

local FovCircle = Instance.new("Frame")
FovCircle.Name = "FovCircle"
FovCircle.BackgroundTransparency = 1
FovCircle.BorderSizePixel = 0
FovCircle.ZIndex  = 10
FovCircle.Visible = false
FovCircle.Parent  = ScreenGui
Instance.new("UICorner",FovCircle).CornerRadius = UDim.new(1,0)
local FovStroke = Instance.new("UIStroke")
FovStroke.Color        = ORANGE
FovStroke.Thickness    = 1.5
FovStroke.Transparency = 0.3
FovStroke.Parent       = FovCircle

RunService.RenderStepped:Connect(function()
	if not fovEnabled then return end
	local m = UserInputService:GetMouseLocation()
	FovCircle.Size     = UDim2.new(0, fovRadius*2, 0, fovRadius*2)
	FovCircle.Position = UDim2.new(0, m.X - fovRadius, 0, m.Y - fovRadius)
end)

-- ══════════════════════════════════════════
-- LOCK INDICATOR HUD
-- ══════════════════════════════════════════
local LockIndicator = Instance.new("Frame")
LockIndicator.Size             = UDim2.new(0,220,0,36)
LockIndicator.AnchorPoint      = Vector2.new(0.5,0)
LockIndicator.Position         = UDim2.new(0.5,0,0,14)
LockIndicator.BackgroundColor3 = Color3.fromRGB(14,14,16)
LockIndicator.BorderSizePixel  = 0
LockIndicator.Visible          = false
LockIndicator.ZIndex           = 20
LockIndicator.Parent           = ScreenGui
Instance.new("UICorner",LockIndicator).CornerRadius = UDim.new(0,8)

local LockStroke = Instance.new("UIStroke")
LockStroke.Color        = ORANGE
LockStroke.Thickness    = 1.5
LockStroke.Transparency = 0.3
LockStroke.Parent       = LockIndicator

local LockDot = Instance.new("Frame")
LockDot.Size             = UDim2.new(0,8,0,8)
LockDot.AnchorPoint      = Vector2.new(0,0.5)
LockDot.Position         = UDim2.new(0,12,0.5,0)
LockDot.BackgroundColor3 = ORANGE
LockDot.BorderSizePixel  = 0
LockDot.ZIndex           = 21
LockDot.Parent           = LockIndicator
Instance.new("UICorner",LockDot).CornerRadius = UDim.new(1,0)

local LockLabel = Instance.new("TextLabel")
LockLabel.Size                 = UDim2.new(1,-32,1,0)
LockLabel.Position             = UDim2.new(0,28,0,0)
LockLabel.BackgroundTransparency = 1
LockLabel.Text                 = "🔒 Locked: —"
LockLabel.TextColor3           = TEXT
LockLabel.TextSize             = 13
LockLabel.Font                 = Enum.Font.GothamSemibold
LockLabel.TextXAlignment       = Enum.TextXAlignment.Left
LockLabel.ZIndex               = 21
LockLabel.Parent               = LockIndicator

task.spawn(function()
	while true do
		if camLockEnabled and camLockTarget then
			TweenService:Create(LockDot,
				TweenInfo.new(0.6,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),
				{ BackgroundTransparency = 0.7 }
			):Play()
		else
			LockDot.BackgroundTransparency = 0
		end
		task.wait(1.2)
	end
end)

-- ══════════════════════════════════════════
-- WINDOW
-- ══════════════════════════════════════════
local Win = Instance.new("Frame")
Win.Name             = "Window"
Win.Size             = UDim2.new(0,640,0,520)
Win.AnchorPoint      = Vector2.new(0.5,0.5)
Win.Position         = UDim2.new(0.5,0,0.42,0)
Win.BackgroundColor3 = BG
Win.BorderSizePixel  = 0
Win.Active           = true
Win.Parent           = ScreenGui
Instance.new("UICorner",Win).CornerRadius = UDim.new(0,10)

TweenService:Create(Win,
	TweenInfo.new(0.5,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
	{ Position = UDim2.new(0.5,0,0.5,0) }
):Play()

local Strip = Instance.new("Frame")
Strip.Size             = UDim2.new(0,3,1,0)
Strip.BackgroundColor3 = ORANGE
Strip.BorderSizePixel  = 0
Strip.Parent           = Win
Instance.new("UICorner",Strip).CornerRadius = UDim.new(0,10)

task.spawn(function()
	while Win and Win.Parent do
		TweenService:Create(Strip,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0.6}):Play()
		task.wait(1.5)
		TweenService:Create(Strip,TweenInfo.new(1.5,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{BackgroundTransparency=0}):Play()
		task.wait(1.5)
	end
end)

local TitleBar = Instance.new("Frame")
TitleBar.Name             = "TitleBar"
TitleBar.Size             = UDim2.new(1,0,0,46)
TitleBar.BackgroundColor3 = SIDEBAR
TitleBar.BorderSizePixel  = 0
TitleBar.Active           = true
TitleBar.Parent           = Win
Instance.new("UICorner",TitleBar).CornerRadius = UDim.new(0,10)

local TFix = Instance.new("Frame")
TFix.Size             = UDim2.new(1,0,0,10)
TFix.Position         = UDim2.new(0,0,1,-10)
TFix.BackgroundColor3 = SIDEBAR
TFix.BorderSizePixel  = 0
TFix.Parent           = TitleBar

local MBox = Instance.new("Frame")
MBox.Size             = UDim2.new(0,28,0,28)
MBox.Position         = UDim2.new(0,14,0.5,-14)
MBox.BackgroundColor3 = Color3.fromRGB(30,30,35)
MBox.BorderSizePixel  = 0
MBox.Parent           = TitleBar
Instance.new("UICorner",MBox).CornerRadius = UDim.new(0,6)
local MStroke = Instance.new("UIStroke")
MStroke.Color     = ORANGE
MStroke.Thickness = 1.5
MStroke.Parent    = MBox
local ML = Instance.new("TextLabel")
ML.Size                 = UDim2.new(1,0,1,0)
ML.BackgroundTransparency = 1
ML.Text                 = "M"
ML.TextColor3           = ORANGE
ML.TextSize             = 14
ML.Font                 = Enum.Font.GothamBold
ML.Parent               = MBox

task.spawn(function()
	while Win and Win.Parent do
		TweenService:Create(MBox,   TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,31,0,31),Position=UDim2.new(0,13,0.5,-15.5)}):Play()
		TweenService:Create(MStroke,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0.55}):Play()
		task.wait(2)
		TweenService:Create(MBox,   TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Size=UDim2.new(0,28,0,28),Position=UDim2.new(0,14,0.5,-14)}):Play()
		TweenService:Create(MStroke,TweenInfo.new(2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut),{Transparency=0}):Play()
		task.wait(2)
	end
end)

local AngoLabel = Instance.new("TextLabel")
AngoLabel.Size                 = UDim2.new(0,70,1,0)
AngoLabel.Position             = UDim2.new(0,48,0,0)
AngoLabel.BackgroundTransparency = 1
AngoLabel.Text                 = "ANGO"
AngoLabel.TextColor3           = TEXT
AngoLabel.TextSize             = 16
AngoLabel.Font                 = Enum.Font.GothamBold
AngoLabel.TextXAlignment       = Enum.TextXAlignment.Left
AngoLabel.Parent               = TitleBar

local Underline = Instance.new("Frame")
Underline.Size             = UDim2.new(0,42,0,2)
Underline.Position         = UDim2.new(0,48,1,-7)
Underline.BackgroundColor3 = ORANGE
Underline.BorderSizePixel  = 0
Underline.Parent           = TitleBar
Instance.new("UICorner",Underline).CornerRadius = UDim.new(1,0)

local VerLabel = Instance.new("TextLabel")
VerLabel.Size                 = UDim2.new(0,50,0,14)
VerLabel.Position             = UDim2.new(0,122,0.5,-7)
VerLabel.BackgroundTransparency = 1
VerLabel.Text                 = "v2.9"
VerLabel.TextColor3           = SUBTEXT
VerLabel.TextSize             = 11
VerLabel.Font                 = Enum.Font.Gotham
VerLabel.TextXAlignment       = Enum.TextXAlignment.Left
VerLabel.Parent               = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size             = UDim2.new(0,24,0,24)
CloseBtn.Position         = UDim2.new(1,-34,0.5,-12)
CloseBtn.BackgroundColor3 = Color3.fromRGB(60,60,65)
CloseBtn.Text             = "✕"
CloseBtn.TextColor3       = Color3.fromRGB(200,200,200)
CloseBtn.TextSize         = 11
CloseBtn.Font             = Enum.Font.GothamBold
CloseBtn.BorderSizePixel  = 0
CloseBtn.Parent           = TitleBar
Instance.new("UICorner",CloseBtn).CornerRadius = UDim.new(0,6)
CloseBtn.MouseEnter:Connect(function() TweenService:Create(CloseBtn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(210,55,55)}):Play() end)
CloseBtn.MouseLeave:Connect(function() TweenService:Create(CloseBtn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(60,60,65)}):Play() end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local Divider = Instance.new("Frame")
Divider.Size             = UDim2.new(1,-24,0,1)
Divider.Position         = UDim2.new(0,12,0,46)
Divider.BackgroundColor3 = Color3.fromRGB(45,45,50)
Divider.BorderSizePixel  = 0
Divider.Parent           = Win

local guiDragging, guiDragStart, guiStartPos = false, nil, nil
TitleBar.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then
		guiDragging = true; guiDragStart = i.Position; guiStartPos = Win.Position
	end
end)
TitleBar.InputEnded:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 then guiDragging = false end
end)
UserInputService.InputChanged:Connect(function(i)
	if guiDragging and i.UserInputType == Enum.UserInputType.MouseMovement then
		local d = i.Position - guiDragStart
		Win.Position = UDim2.new(guiStartPos.X.Scale, guiStartPos.X.Offset+d.X, guiStartPos.Y.Scale, guiStartPos.Y.Offset+d.Y)
	end
end)

-- ══════════════════════════════════════════
-- BODY LAYOUT
-- ══════════════════════════════════════════
local Sidebar = Instance.new("Frame")
Sidebar.Size             = UDim2.new(0,130,1,-47)
Sidebar.Position         = UDim2.new(0,0,0,47)
Sidebar.BackgroundColor3 = SIDEBAR
Sidebar.BorderSizePixel  = 0
Sidebar.Parent           = Win
Instance.new("UICorner",Sidebar).CornerRadius = UDim.new(0,10)

local SideTopFix = Instance.new("Frame")
SideTopFix.Size             = UDim2.new(1,0,0,10)
SideTopFix.BackgroundColor3 = SIDEBAR
SideTopFix.BorderSizePixel  = 0
SideTopFix.Parent           = Sidebar

Instance.new("UIListLayout",Sidebar).SortOrder = Enum.SortOrder.LayoutOrder
local SidePad = Instance.new("UIPadding")
SidePad.PaddingTop    = UDim.new(0,10)
SidePad.PaddingLeft   = UDim.new(0,8)
SidePad.PaddingRight  = UDim.new(0,8)
SidePad.PaddingBottom = UDim.new(0,10)
SidePad.Parent        = Sidebar

local SideDivider = Instance.new("Frame")
SideDivider.Size             = UDim2.new(0,1,1,-47)
SideDivider.Position         = UDim2.new(0,130,0,47)
SideDivider.BackgroundColor3 = Color3.fromRGB(40,40,45)
SideDivider.BorderSizePixel  = 0
SideDivider.Parent           = Win

local ContentArea = Instance.new("Frame")
ContentArea.Size                 = UDim2.new(1,-132,1,-47)
ContentArea.Position             = UDim2.new(0,132,0,47)
ContentArea.BackgroundTransparency = 1
ContentArea.BorderSizePixel      = 0
ContentArea.Parent               = Win

local TabFlash = Instance.new("Frame")
TabFlash.Size                   = UDim2.new(1,0,1,0)
TabFlash.BackgroundColor3       = BG
TabFlash.BackgroundTransparency = 1
TabFlash.BorderSizePixel        = 0
TabFlash.ZIndex                 = 8
TabFlash.Parent                 = ContentArea

local function flashTabTransition()
	TabFlash.BackgroundTransparency = 0.35
	TweenService:Create(TabFlash,TweenInfo.new(0.25,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{BackgroundTransparency=1}):Play()
end

-- ══════════════════════════════════════════
-- TAB SYSTEM
-- ══════════════════════════════════════════
local tabs = {}

local function createTabButton(name, icon, order)
	local btn = Instance.new("TextButton")
	btn.Size             = UDim2.new(1,0,0,38)
	btn.BackgroundColor3 = Color3.fromRGB(22,22,26)
	btn.BorderSizePixel  = 0
	btn.Text             = icon.." "..name
	btn.TextColor3       = SUBTEXT
	btn.TextSize         = 12
	btn.Font             = Enum.Font.GothamSemibold
	btn.TextXAlignment   = Enum.TextXAlignment.Left
	btn.LayoutOrder      = order
	btn.Parent           = Sidebar
	Instance.new("UICorner",btn).CornerRadius = UDim.new(0,7)
	local pad = Instance.new("UIPadding"); pad.PaddingLeft = UDim.new(0,10); pad.Parent = btn

	local pip = Instance.new("Frame")
	pip.Size             = UDim2.new(0,3,0,18)
	pip.AnchorPoint      = Vector2.new(0,0.5)
	pip.Position         = UDim2.new(0,-10,0.5,0)
	pip.BackgroundColor3 = ORANGE
	pip.BorderSizePixel  = 0
	pip.Visible          = false
	pip.Parent           = btn
	Instance.new("UICorner",pip).CornerRadius = UDim.new(1,0)

	local scroll = Instance.new("ScrollingFrame")
	scroll.Size                  = UDim2.new(1,0,1,0)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel       = 0
	scroll.ScrollBarThickness    = 4
	scroll.ScrollBarImageColor3  = ORANGE
	scroll.AutomaticCanvasSize   = Enum.AutomaticSize.Y
	scroll.CanvasSize            = UDim2.new(0,0,0,0)
	scroll.Visible               = false
	scroll.Parent                = ContentArea

	local ll = Instance.new("UIListLayout")
	ll.SortOrder = Enum.SortOrder.LayoutOrder
	ll.Padding   = UDim.new(0,7)
	ll.Parent    = scroll

	local pp = Instance.new("UIPadding")
	pp.PaddingLeft   = UDim.new(0,12)
	pp.PaddingRight  = UDim.new(0,12)
	pp.PaddingTop    = UDim.new(0,10)
	pp.PaddingBottom = UDim.new(0,10)
	pp.Parent        = scroll

	local tabData = { btn=btn, scroll=scroll, pip=pip, name=name }
	table.insert(tabs, tabData)

	btn.MouseEnter:Connect(function() if tabData.scroll.Visible then return end TweenService:Create(btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(30,28,24)}):Play() end)
	btn.MouseLeave:Connect(function() if tabData.scroll.Visible then return end TweenService:Create(btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(22,22,26)}):Play() end)

	btn.MouseButton1Click:Connect(function()
		TweenService:Create(btn,TweenInfo.new(0.07,Enum.EasingStyle.Quad),{Size=UDim2.new(1,0,0,34)}):Play()
		task.delay(0.07,function() TweenService:Create(btn,TweenInfo.new(0.2,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(1,0,0,38)}):Play() end)
		flashTabTransition()
		for _,t in tabs do
			t.scroll.Visible = false; t.pip.Visible = false
			TweenService:Create(t.btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(22,22,26),TextColor3=SUBTEXT}):Play()
		end
		tabData.scroll.Visible = true; tabData.pip.Visible = true
		TweenService:Create(btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(35,30,22),TextColor3=ORANGE}):Play()
	end)
	return tabData
end

local function activateTab(tabData)
	for _,t in tabs do
		t.scroll.Visible = false; t.pip.Visible = false
		TweenService:Create(t.btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(22,22,26),TextColor3=SUBTEXT}):Play()
	end
	tabData.scroll.Visible = true; tabData.pip.Visible = true
	TweenService:Create(tabData.btn,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(35,30,22),TextColor3=ORANGE}):Play()
end

local tabMovement = createTabButton("Movement","🏃",1)
local tabPlayer   = createTabButton("Player",  "👤",2)
local tabAimbot   = createTabButton("Aimbot",  "🎯",3)
local tabCamera   = createTabButton("Camera",  "🎥",4)
local tabWorld    = createTabButton("World",   "🌍",5)
local tabESP      = createTabButton("ESP",     "👁",6)

-- ══════════════════════════════════════════
-- COMPONENT BUILDERS
-- ══════════════════════════════════════════
local orders = {}
local function nextOrder(scroll)
	if not orders[scroll] then orders[scroll] = 0 end
	orders[scroll] += 1
	return orders[scroll]
end

local function SectionHeader(scroll, text)
	local f = Instance.new("Frame")
	f.Size                   = UDim2.new(1,0,0,24)
	f.BackgroundTransparency = 1
	f.LayoutOrder            = nextOrder(scroll)
	f.Parent                 = scroll
	local line = Instance.new("Frame")
	line.Size             = UDim2.new(1,0,0,1)
	line.Position         = UDim2.new(0,0,0.5,0)
	line.BackgroundColor3 = Color3.fromRGB(45,45,50)
	line.BorderSizePixel  = 0
	line.Parent           = f
	local lbl = Instance.new("TextLabel")
	lbl.AutomaticSize    = Enum.AutomaticSize.X
	lbl.Size             = UDim2.new(0,0,1,0)
	lbl.BackgroundColor3 = BG
	lbl.BorderSizePixel  = 0
	lbl.Text             = " "..text:upper().." "
	lbl.TextColor3       = ORANGE
	lbl.TextSize         = 10
	lbl.Font             = Enum.Font.GothamBold
	lbl.Parent           = f
end

local function Slider(scroll, name, min, max, default, suffix, callback)
	suffix = suffix or ""
	local card = Instance.new("Frame")
	card.Size             = UDim2.new(1,0,0,64)
	card.BackgroundColor3 = CARD
	card.BorderSizePixel  = 0
	card.LayoutOrder      = nextOrder(scroll)
	card.Parent           = scroll
	Instance.new("UICorner",card).CornerRadius = UDim.new(0,8)
	card.MouseEnter:Connect(function() TweenService:Create(card,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(38,38,44)}):Play() end)
	card.MouseLeave:Connect(function() TweenService:Create(card,TWEEN_FAST,{BackgroundColor3=CARD}):Play() end)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size                 = UDim2.new(0.65,0,0,20)
	nameLbl.Position             = UDim2.new(0,12,0,10)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text                 = name
	nameLbl.TextColor3           = TEXT
	nameLbl.TextSize             = 13
	nameLbl.Font                 = Enum.Font.GothamSemibold
	nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
	nameLbl.Parent               = card

	local valLbl = Instance.new("TextLabel")
	valLbl.Size                 = UDim2.new(0.35,-12,0,20)
	valLbl.Position             = UDim2.new(0.65,0,0,10)
	valLbl.BackgroundTransparency = 1
	valLbl.Text                 = tostring(default)..suffix
	valLbl.TextColor3           = ORANGE
	valLbl.TextSize             = 13
	valLbl.Font                 = Enum.Font.GothamBold
	valLbl.TextXAlignment       = Enum.TextXAlignment.Right
	valLbl.Parent               = card

	local track = Instance.new("Frame")
	track.Size             = UDim2.new(1,-24,0,6)
	track.Position         = UDim2.new(0,12,0,42)
	track.BackgroundColor3 = Color3.fromRGB(50,50,55)
	track.BorderSizePixel  = 0
	track.Parent           = card
	Instance.new("UICorner",track).CornerRadius = UDim.new(1,0)

	local pct0 = (default-min)/(max-min)
	local fill = Instance.new("Frame")
	fill.Size             = UDim2.new(pct0,0,1,0)
	fill.BackgroundColor3 = ORANGE
	fill.BorderSizePixel  = 0
	fill.Parent           = track
	Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

	local knob = Instance.new("Frame")
	knob.Size             = UDim2.new(0,16,0,16)
	knob.AnchorPoint      = Vector2.new(0.5,0.5)
	knob.Position         = UDim2.new(pct0,0,0.5,0)
	knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
	knob.BorderSizePixel  = 0
	knob.ZIndex           = 3
	knob.Parent           = track
	Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

	local sliderDrag = false
	local function beginDrag(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			sliderDrag = true
		end
	end
	track.InputBegan:Connect(beginDrag)
	knob.InputBegan:Connect(beginDrag)
	UserInputService.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			sliderDrag = false
		end
	end)
	RunService.RenderStepped:Connect(function()
		if not sliderDrag then return end
		local m = UserInputService:GetMouseLocation()
		local p = math.clamp((m.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
		local v = math.round(min + p*(max-min))
		fill.Size     = UDim2.new(p,0,1,0)
		knob.Position = UDim2.new(p,0,0.5,0)
		valLbl.Text   = tostring(v)..suffix
		if callback then callback(v) end
	end)
end

local function Toggle(scroll, name, desc, default, callback)
	local card = Instance.new("Frame")
	card.Size             = UDim2.new(1,0,0, desc~="" and 52 or 44)
	card.BackgroundColor3 = CARD
	card.BorderSizePixel  = 0
	card.LayoutOrder      = nextOrder(scroll)
	card.Parent           = scroll
	Instance.new("UICorner",card).CornerRadius = UDim.new(0,8)
	card.MouseEnter:Connect(function() TweenService:Create(card,TWEEN_FAST,{BackgroundColor3=Color3.fromRGB(38,38,44)}):Play() end)
	card.MouseLeave:Connect(function() TweenService:Create(card,TWEEN_FAST,{BackgroundColor3=CARD}):Play() end)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size                 = UDim2.new(1,-70,0,18)
	nameLbl.Position             = UDim2.new(0,12,0, desc~="" and 8 or 13)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text                 = name
	nameLbl.TextColor3           = TEXT
	nameLbl.TextSize             = 13
	nameLbl.Font                 = Enum.Font.GothamSemibold
	nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
	nameLbl.Parent               = card

	if desc ~= "" then
		local descLbl = Instance.new("TextLabel")
		descLbl.Size                 = UDim2.new(1,-70,0,14)
		descLbl.Position             = UDim2.new(0,12,0,28)
		descLbl.BackgroundTransparency = 1
		descLbl.Text                 = desc
		descLbl.TextColor3           = SUBTEXT
		descLbl.TextSize             = 11
		descLbl.Font                 = Enum.Font.Gotham
		descLbl.TextXAlignment       = Enum.TextXAlignment.Left
		descLbl.Parent               = card
	end

	local pill = Instance.new("TextButton")
	pill.Size             = UDim2.new(0,46,0,26)
	pill.AnchorPoint      = Vector2.new(1,0.5)
	pill.Position         = UDim2.new(1,-12,0.5,0)
	pill.BackgroundColor3 = default and ORANGE or Color3.fromRGB(55,55,60)
	pill.Text             = ""
	pill.BorderSizePixel  = 0
	pill.Parent           = card
	Instance.new("UICorner",pill).CornerRadius = UDim.new(1,0)

	local circle = Instance.new("Frame")
	circle.Size             = UDim2.new(0,20,0,20)
	circle.AnchorPoint      = Vector2.new(0,0.5)
	circle.Position         = default and UDim2.new(1,-23,0.5,0) or UDim2.new(0,3,0.5,0)
	circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	circle.BorderSizePixel  = 0
	circle.Parent           = pill
	Instance.new("UICorner",circle).CornerRadius = UDim.new(1,0)

	local state = default
	pill.MouseButton1Click:Connect(function()
		state = not state
		TweenService:Create(pill,TweenInfo.new(0.07,Enum.EasingStyle.Quad),{Size=UDim2.new(0,42,0,23)}):Play()
		task.delay(0.07,function() TweenService:Create(pill,TweenInfo.new(0.18,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Size=UDim2.new(0,46,0,26)}):Play() end)
		TweenService:Create(pill,  TWEEN_FAST,{BackgroundColor3 = state and ORANGE or Color3.fromRGB(55,55,60)}):Play()
		TweenService:Create(circle,TWEEN_FAST,{Position = state and UDim2.new(1,-23,0.5,0) or UDim2.new(0,3,0.5,0)}):Play()
		if callback then callback(state) end
	end)
end

local function Keybind(scroll, name, desc, defaultKey, callback)
	local card = Instance.new("Frame")
	card.Size             = UDim2.new(1,0,0, desc~="" and 52 or 44)
	card.BackgroundColor3 = CARD
	card.BorderSizePixel  = 0
	card.LayoutOrder      = nextOrder(scroll)
	card.Parent           = scroll
	Instance.new("UICorner",card).CornerRadius = UDim.new(0,8)

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size                 = UDim2.new(1,-110,0,18)
	nameLbl.Position             = UDim2.new(0,12,0, desc~="" and 8 or 13)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text                 = name
	nameLbl.TextColor3           = TEXT
	nameLbl.TextSize             = 13
	nameLbl.Font                 = Enum.Font.GothamSemibold
	nameLbl.TextXAlignment       = Enum.TextXAlignment.Left
	nameLbl.Parent               = card

	if desc ~= "" then
		local dl = Instance.new("TextLabel")
		dl.Size                 = UDim2.new(1,-110,0,14)
		dl.Position             = UDim2.new(0,12,0,28)
		dl.BackgroundTransparency = 1
		dl.Text                 = desc
		dl.TextColor3           = SUBTEXT
		dl.TextSize             = 11
		dl.Font                 = Enum.Font.Gotham
		dl.TextXAlignment       = Enum.TextXAlignment.Left
		dl.Parent               = card
	end

	local keyBtn = Instance.new("TextButton")
	keyBtn.Size             = UDim2.new(0,90,0,30)
	keyBtn.AnchorPoint      = Vector2.new(1,0.5)
	keyBtn.Position         = UDim2.new(1,-12,0.5,0)
	keyBtn.BackgroundColor3 = Color3.fromRGB(55,55,60)
	keyBtn.Text             = defaultKey.Name
	keyBtn.TextColor3       = Color3.fromRGB(255,255,255)
	keyBtn.TextSize         = 13
	keyBtn.Font             = Enum.Font.GothamBold
	keyBtn.BorderSizePixel  = 0
	keyBtn.Parent           = card
	Instance.new("UICorner",keyBtn).CornerRadius = UDim.new(0,6)

	local isBinding = false
	keyBtn.MouseButton1Click:Connect(function()
		if isBinding then return end
		isBinding = true
		keyBtn.Text             = "..."
		keyBtn.BackgroundColor3 = ORANGE
		local conn
		conn = UserInputService.InputBegan:Connect(function(input, gpe)
			if gpe or not isBinding then return end
			if input.UserInputType == Enum.UserInputType.Keyboard then
				local nk = input.KeyCode
				if nk ~= Enum.KeyCode.Unknown then
					keyBtn.Text             = nk.Name
					keyBtn.BackgroundColor3 = Color3.fromRGB(55,55,60)
					isBinding = false
					conn:Disconnect()
					if callback then callback(nk) end
				end
			end
		end)
		task.delay(10, function()
			if isBinding then
				isBinding = false
				keyBtn.Text             = defaultKey.Name
				keyBtn.BackgroundColor3 = Color3.fromRGB(55,55,60)
				if conn then conn:Disconnect() end
			end
		end)
	end)
	if callback then callback(defaultKey) end
end

-- ══════════════════════════════════════════
-- WORKING LOGIC
-- ══════════════════════════════════════════
local function setFly(on)
	flyEnabled = on
	local char = Player.Character
	local hrp  = getHRP()
	local hum  = getHum()
	if not char or not hrp or not hum then return end
	if on then
		hum.PlatformStand = true
		bv = Instance.new("BodyVelocity"); bv.Velocity=Vector3.zero; bv.MaxForce=Vector3.new(1e5,1e5,1e5); bv.Parent=hrp
		bg = Instance.new("BodyGyro");    bg.MaxTorque=Vector3.new(1e5,1e5,1e5); bg.P=1e4; bg.Parent=hrp
	else
		if bv then bv:Destroy(); bv=nil end
		if bg then bg:Destroy(); bg=nil end
		hum.PlatformStand = false
	end
end

RunService.RenderStepped:Connect(function()
	if not flyEnabled or not bv or not bg then return end
	local cam = workspace.CurrentCamera
	local dir = Vector3.zero
	if UserInputService:IsKeyDown(Enum.KeyCode.W)         then dir += cam.CFrame.LookVector  end
	if UserInputService:IsKeyDown(Enum.KeyCode.S)         then dir -= cam.CFrame.LookVector  end
	if UserInputService:IsKeyDown(Enum.KeyCode.A)         then dir -= cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.D)         then dir += cam.CFrame.RightVector end
	if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then dir += Vector3.new(0,1,0)     end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir -= Vector3.new(0,1,0)     end
	bv.Velocity = dir * 60
	bg.CFrame   = cam.CFrame
end)

RunService.Stepped:Connect(function()
	if not noclipEnabled then return end
	local char = Player.Character
	if not char then return end
	for _,p in char:GetDescendants() do
		if p:IsA("BasePart") then p.CanCollide = false end
	end
end)

UserInputService.JumpRequest:Connect(function()
	if not infiniteJump then return end
	local hum = getHum()
	if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
end)

RunService.Heartbeat:Connect(function()
	if not godMode then return end
	local hum = getHum()
	if hum then hum.Health = hum.MaxHealth end
end)

Player.Idled:Connect(function()
	if not antiAfk then return end
	VirtualUser:Button2Down(Vector2.zero, workspace.CurrentCamera.CFrame)
	task.wait(0.1)
	VirtualUser:Button2Up(Vector2.zero, workspace.CurrentCamera.CFrame)
end)

local function setFreecam(on)
	freecamEnabled = on
	local cam = workspace.CurrentCamera
	local hrp = getHRP(); local hum = getHum()
	if on then
		if hrp then hrp.Anchored = true; freecamPos = hrp.CFrame.Position + Vector3.new(0,3,0)
		else freecamPos = cam.CFrame.Position end
		if hum then hum.WalkSpeed=0; hum.JumpPower=0 end
		local lv = cam.CFrame.LookVector
		freecamPitch = math.asin(math.clamp(lv.Y,-1,1))
		freecamYaw   = math.atan2(-lv.X,-lv.Z)
		UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
		freecamConn = RunService.RenderStepped:Connect(function(dt)
			if not freecamEnabled then return end
			local delta = UserInputService:GetMouseDelta()
			freecamYaw   = freecamYaw   - delta.X*0.003
			freecamPitch = math.clamp(freecamPitch - delta.Y*0.003, -math.pi/2+0.05, math.pi/2-0.05)
			local ori  = CFrame.Angles(0,freecamYaw,0)*CFrame.Angles(freecamPitch,0,0)
			local move = Vector3.zero
			if UserInputService:IsKeyDown(Enum.KeyCode.W)         then move += ori.LookVector  end
			if UserInputService:IsKeyDown(Enum.KeyCode.S)         then move -= ori.LookVector  end
			if UserInputService:IsKeyDown(Enum.KeyCode.A)         then move -= ori.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.D)         then move += ori.RightVector end
			if UserInputService:IsKeyDown(Enum.KeyCode.Space)     then move += Vector3.new(0,1,0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then move -= Vector3.new(0,1,0) end
			local spd = UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and freecamSpeed*3 or freecamSpeed
			freecamPos = freecamPos + move*spd*dt
			cam.CFrame = CFrame.new(freecamPos)*CFrame.Angles(0,freecamYaw,0)*CFrame.Angles(freecamPitch,0,0)
		end)
	else
		if freecamConn then freecamConn:Disconnect(); freecamConn=nil end
		local hrpN = getHRP(); local humN = getHum()
		if hrpN then hrpN.Anchored=false end
		if humN then humN.WalkSpeed=16; humN.JumpPower=50 end
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
end

-- ══════════════════════════════════════════
-- CAM LOCK (ttwizz Open Aimbot style)
-- Uses TweenService on Camera.CFrame, no
-- Scriptable mode, no position override.
-- Camera stays Custom so zoom works fine.
-- ══════════════════════════════════════════
local function setLockIndicator(on, name)
	LockLabel.Text   = on and ("🔒 Locked: "..(name or "—")) or "🔒 Locked: —"
	LockStroke.Color = on and ORANGE or Color3.fromRGB(80,80,80)
	if on then
		LockIndicator.Visible  = true
		LockIndicator.Position = UDim2.new(0.5,0,0,-50)
		TweenService:Create(LockIndicator,
			TweenInfo.new(0.4,Enum.EasingStyle.Back,Enum.EasingDirection.Out),
			{ Position = UDim2.new(0.5,0,0,14) }
		):Play()
	else
		TweenService:Create(LockIndicator,
			TweenInfo.new(0.22,Enum.EasingStyle.Quad,Enum.EasingDirection.In),
			{ Position = UDim2.new(0.5,0,0,-50) }
		):Play()
		task.delay(0.22, function()
			LockIndicator.Visible  = false
			LockIndicator.Position = UDim2.new(0.5,0,0,14)
		end)
	end
end

-- Find closest player to mouse within fovRadius
local function camLockFindTarget()
	local cam      = workspace.CurrentCamera
	local mousePos = UserInputService:GetMouseLocation()
	local closest, closestDist = nil, math.huge
	for _, plr in Players:GetPlayers() do
		if plr ~= Player and plr.Character then
			local head = plr.Character:FindFirstChild("Head")
			local hum  = plr.Character:FindFirstChildOfClass("Humanoid")
			if head and hum and hum.Health > 0 then
				local sp, onScreen = cam:WorldToViewportPoint(head.Position)
				if onScreen then
					local d = (Vector2.new(sp.X, sp.Y) - mousePos).Magnitude
					if d < fovRadius and d < closestDist then
						closestDist = d
						closest     = plr.Character
					end
				end
			end
		end
	end
	return closest
end

-- ttwizz-style: TweenService on Camera.CFrame toward target,
-- reading cam.CFrame.Position each frame so position is never overridden
local function updateCamLock()
	if camLockConn then camLockConn:Disconnect(); camLockConn = nil end
	if camLockTween then camLockTween:Cancel(); camLockTween = nil end

	if not camLockEnabled then
		camLockTarget = nil
		setLockIndicator(false)
		return
	end

	camLockTarget = camLockFindTarget()

	if not camLockTarget then
		camLockEnabled = false
		setLockIndicator(false)
		return
	end

	local plr = Players:GetPlayerFromCharacter(camLockTarget)
	setLockIndicator(true, plr and plr.Name or "?")

	camLockConn = RunService.RenderStepped:Connect(function(dt)
		local cam = workspace.CurrentCamera

		-- Validate target each frame
		if not camLockTarget or not camLockTarget.Parent then
			camLockEnabled = false
			updateCamLock()
			return
		end

		local head = camLockTarget:FindFirstChild("Head")
		local hrp  = camLockTarget:FindFirstChild("HumanoidRootPart")
		local hum  = camLockTarget:FindFirstChildOfClass("Humanoid")

		if not head or not hrp or not hum or hum.Health <= 0 then
			camLockEnabled = false
			updateCamLock()
			return
		end

		-- Predicted position (velocity * prediction time)
		local predicted = head.Position + (hrp.AssemblyLinearVelocity or Vector3.zero) * camLockPrediction

		-- ttwizz camera aim: CFrame.new(camPos, target) with TweenService smoothing
		-- This only changes the look direction, never the position
		local camPos  = cam.CFrame.Position
		local goalCF  = CFrame.new(camPos, predicted)

		if lockSmooth > 0 then
			-- Cancel previous tween and start a new one each frame for smooth tracking
			if camLockTween then camLockTween:Cancel() end
			camLockTween = TweenService:Create(cam,
				TweenInfo.new(math.clamp(lockSmooth, 0.01, 0.99), Enum.EasingStyle.Sine, Enum.EasingDirection.Out),
				{ CFrame = goalCF }
			)
			camLockTween:Play()
		else
			cam.CFrame = goalCF
		end
	end)
end

-- Toggle cam lock on key press
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == camLockKey then
		camLockEnabled = not camLockEnabled
		updateCamLock()
	end
end)

-- ══════════════════════════════════════════
-- AIMBOT
-- ══════════════════════════════════════════
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or UserInputService:GetFocusedTextBox() then return end
	if aimbotEnabled and input.KeyCode == aimbotKey then
		aimbotHolding = true
		aimbotTarget  = nil
	end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == aimbotKey then
		aimbotHolding = false
		aimbotTarget  = nil
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or UserInputService:GetFocusedTextBox() then return end
	if triggerEnabled and input.KeyCode == triggerKey then triggerHolding = true end
end)
UserInputService.InputEnded:Connect(function(input)
	if input.KeyCode == triggerKey then triggerHolding = false end
end)

RunService.RenderStepped:Connect(function(dt)
	if aimbotEnabled and aimbotHolding then
		if not aimbotTarget or not aimbotTarget.Character then
			aimbotTarget = getAimbotTarget()
		end
		if aimbotTarget and aimbotTarget.Character then
			local part = aimbotTarget.Character:FindFirstChild(aimbotPart)
			             or aimbotTarget.Character:FindFirstChild("Head")
			             or aimbotTarget.Character:FindFirstChild("HumanoidRootPart")
			local hum  = aimbotTarget.Character:FindFirstChildOfClass("Humanoid")
			if part and hum and hum.Health > 0 then
				local cam        = workspace.CurrentCamera
				local currentPos = cam.CFrame.Position
				local goalCF     = CFrame.new(currentPos, part.Position)
				local alpha      = 1 - (1 - aimbotSmooth)^(dt*60)
				cam.CFrame       = cam.CFrame:Lerp(goalCF, alpha)
			else
				aimbotTarget = nil
			end
		end
	end

	if triggerEnabled and triggerHolding then
		local target = getAimbotTarget()
		if target then
			if math.random(1,100) <= triggerChance then
				if getfenv and getfenv().mouse1click then
					getfenv().mouse1click()
				else
					VirtualUser:Button1Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
					task.defer(function() VirtualUser:Button1Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame) end)
				end
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe or not bulletTpEnabled or input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local target = getClosestPlayer()
	if not target or not target.Character then return end
	local hrp = target.Character:FindFirstChild("HumanoidRootPart")
	local playerHRP = getHRP()
	if not hrp or not playerHRP then return end
	playerHRP.CFrame = hrp.CFrame * CFrame.new(0,0,3)
end)

Player.CharacterAdded:Connect(function(char)
	flyEnabled = false; bv=nil; bg=nil
	if freecamEnabled then
		if freecamConn then freecamConn:Disconnect(); freecamConn=nil end
		freecamEnabled = false
		UserInputService.MouseBehavior = Enum.MouseBehavior.Default
	end
	char:WaitForChild("HumanoidRootPart")
	if noclipEnabled then
		for _,p in char:GetDescendants() do if p:IsA("BasePart") then p.CanCollide=false end end
	end
	if invisibleEnabled then
		for _,p in char:GetDescendants() do if p:IsA("BasePart") then p.Transparency=1 end end
	end
	if camLockEnabled then
		task.wait(1)
		updateCamLock()
	else
		camLockTarget = nil
		setLockIndicator(false)
	end
end)

-- ══════════════════════════════════════════
-- ESP SYSTEM
-- ══════════════════════════════════════════
local function removeESP(plr)
	if espObjects[plr] then
		pcall(function()
			if espObjects[plr].highlight then espObjects[plr].highlight:Destroy() end
			if espObjects[plr].billboard then espObjects[plr].billboard:Destroy() end
		end)
		espObjects[plr] = nil
	end
end

local function applyESP(plr)
	if plr == Player then return end
	removeESP(plr)
	if not espEnabled then return end
	local char = plr.Character
	if not char then return end

	local hl = Instance.new("Highlight")
	hl.Adornee             = char
	hl.OutlineColor        = ORANGE
	hl.FillColor           = ORANGE
	hl.OutlineTransparency = espBoxes and 0 or 1
	hl.FillTransparency    = espChams and 0.6 or 1
	hl.DepthMode           = Enum.HighlightDepthMode.AlwaysOnTop
	hl.Parent              = char

	local head = char:FindFirstChild("Head")
	if not head then espObjects[plr] = { highlight=hl }; return end

	local bb = Instance.new("BillboardGui")
	bb.Size         = UDim2.new(0,120,0,44)
	bb.StudsOffset  = Vector3.new(0,2.8,0)
	bb.AlwaysOnTop  = true
	bb.ResetOnSpawn = false
	bb.Parent       = head

	local nameLbl = Instance.new("TextLabel")
	nameLbl.Size                   = UDim2.new(1,0,0,20)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text                   = plr.Name
	nameLbl.TextColor3             = ORANGE
	nameLbl.TextSize               = 13
	nameLbl.Font                   = Enum.Font.GothamBold
	nameLbl.TextStrokeColor3       = Color3.fromRGB(0,0,0)
	nameLbl.TextStrokeTransparency = 0.4
	nameLbl.Visible                = espNames
	nameLbl.Parent                 = bb

	local hpBG = Instance.new("Frame")
	hpBG.Size             = UDim2.new(1,0,0,7)
	hpBG.Position         = UDim2.new(0,0,0,24)
	hpBG.BackgroundColor3 = Color3.fromRGB(35,35,35)
	hpBG.BorderSizePixel  = 0
	hpBG.Visible          = espHealth
	hpBG.Parent           = bb
	Instance.new("UICorner",hpBG).CornerRadius = UDim.new(1,0)

	local hpFill = Instance.new("Frame")
	hpFill.Size             = UDim2.new(1,0,1,0)
	hpFill.BackgroundColor3 = Color3.fromRGB(60,210,90)
	hpFill.BorderSizePixel  = 0
	hpFill.Parent           = hpBG
	Instance.new("UICorner",hpFill).CornerRadius = UDim.new(1,0)

	espObjects[plr] = { highlight=hl, billboard=bb, nameLbl=nameLbl, hpBG=hpBG, hpFill=hpFill }
end

local function refreshAllESP()
	for plr in espObjects do removeESP(plr) end
	if not espEnabled then return end
	for _,plr in Players:GetPlayers() do if plr ~= Player then applyESP(plr) end end
end

RunService.Heartbeat:Connect(function()
	for plr,objs in espObjects do
		if not plr or not plr.Character then continue end
		local hum = plr.Character:FindFirstChildOfClass("Humanoid")
		if not hum then continue end
		local pct = math.clamp(hum.Health/math.max(hum.MaxHealth,1),0,1)
		if objs.hpFill then
			objs.hpFill.Size             = UDim2.new(pct,0,1,0)
			objs.hpFill.BackgroundColor3 = Color3.fromRGB(math.round(255*(1-pct)),math.round(210*pct),50)
		end
		if objs.nameLbl  then objs.nameLbl.Visible  = espNames  end
		if objs.hpBG     then objs.hpBG.Visible     = espHealth end
		if objs.highlight then
			objs.highlight.OutlineTransparency = espBoxes and 0   or 1
			objs.highlight.FillTransparency    = espChams and 0.6 or 1
		end
	end
end)

local function hookPlayer(plr)
	if plr == Player then return end
	plr.CharacterAdded:Connect(function() task.wait(0.5); applyESP(plr) end)
	if plr.Character then applyESP(plr) end
end

Players.PlayerAdded:Connect(hookPlayer)
Players.PlayerRemoving:Connect(removeESP)
for _,plr in Players:GetPlayers() do hookPlayer(plr) end

-- ══════════════════════════════════════════
-- POPULATE TABS
-- ══════════════════════════════════════════
local ms = tabMovement.scroll
local ps = tabPlayer.scroll
local as = tabAimbot.scroll
local cs = tabCamera.scroll
local ws = tabWorld.scroll
local es = tabESP.scroll

-- MOVEMENT
SectionHeader(ms,"Speed")
Slider(ms,"Walk Speed",8,100,16,"",function(v) local h=getHum(); if h then h.WalkSpeed=v end end)
Slider(ms,"Jump Power",0,200,50,"",function(v) local h=getHum(); if h then h.JumpPower=v end end)
SectionHeader(ms,"Abilities")
Toggle(ms,"Fly","WASD · Space=up · Shift=down",false,function(on) setFly(on) end)
Toggle(ms,"Infinite Jump","Jump repeatedly in mid-air",false,function(on) infiniteJump=on end)
Toggle(ms,"Speed Boost","Instantly sets speed to 80",false,function(on)
	local h=getHum(); if h then h.WalkSpeed=on and 80 or 16 end
end)
Toggle(ms,"Noclip","Walk through any wall or part",false,function(on) noclipEnabled=on end)

-- PLAYER
SectionHeader(ps,"Combat")
Toggle(ps,"God Mode","Keeps your health full every frame",false,function(on) godMode=on end)
Toggle(ps,"Invisible","Hides your character from view",false,function(on)
	invisibleEnabled=on
	local char=Player.Character; if not char then return end
	for _,p in char:GetDescendants() do if p:IsA("BasePart") then p.Transparency=on and 1 or 0 end end
end)
SectionHeader(ps,"Utility")
Toggle(ps,"Anti-AFK","Prevents the server from kicking you",false,function(on) antiAfk=on end)
Toggle(ps,"No Animations","Freezes all character animations",false,function(on)
	local char=Player.Character; if not char then return end
	local a=char:FindFirstChild("Animate"); if a then a.Disabled=on end
end)

-- AIMBOT
SectionHeader(as,"Aimbot")
Toggle(as,"Enable Aimbot","Hold aim key to lock onto nearest player",false,function(on)
	aimbotEnabled=on
	if not on then aimbotHolding=false; aimbotTarget=nil end
end)
Keybind(as,"Aim Key","Hold this key to aim",Enum.KeyCode.Q,function(k) aimbotKey=k end)
SectionHeader(as,"Aim Part")
Toggle(as,"Aim at Head","Target head instead of HumanoidRootPart",true,function(on)
	aimbotPart = on and "Head" or "HumanoidRootPart"
end)
Slider(as,"Aim Smoothness",1,20,7,"",function(v) aimbotSmooth=v/20 end)

SectionHeader(as,"TriggerBot")
Toggle(as,"Enable TriggerBot","Auto-fires when enemy is in crosshair",false,function(on)
	triggerEnabled=on; if not on then triggerHolding=false end
end)
Keybind(as,"Trigger Key","Hold this key to activate trigger",Enum.KeyCode.E,function(k) triggerKey=k end)
Slider(as,"Trigger Chance",1,100,100,"%",function(v) triggerChance=v end)

SectionHeader(as,"Silent Aim")
Toggle(as,"Silent Aim","Silently snaps bullets to nearest player",false,function(on)
	silentAimEnabled=on
	if on and not oldNamecall then
		oldNamecall = hookmetamethod(game,"__namecall",function(self,...)
			local method = getnamecallmethod()
			local args   = {...}
			if silentAimEnabled and method=="FireServer" then
				local target = getClosestPlayer()
				if target and target.Character then
					local hrp = target.Character:FindFirstChild("HumanoidRootPart")
					if hrp then
						for i,arg in args do
							if typeof(arg)=="Vector3"  then args[i]=hrp.Position end
							if typeof(arg)=="Instance" and arg:IsA("BasePart") then args[i]=hrp end
						end
					end
				end
				return oldNamecall(self,table.unpack(args))
			end
			return oldNamecall(self,...)
		end)
	end
end)

SectionHeader(as,"Camera Lock")
Keybind(as,"Cam Lock Key","Press to toggle camera lock onto nearest player",Enum.KeyCode.F,function(k)
	camLockKey = k
end)
Slider(as,"Lock Smoothness",1,20,4,"",function(v) lockSmooth=v/20 end)
Slider(as,"Lock Prediction",0,50,10,"0.01s",function(v) camLockPrediction=v/100 end)
Toggle(as,"Bullet TP","Flash-TPs to target on left click",false,function(on) bulletTpEnabled=on end)

SectionHeader(as,"FOV")
Toggle(as,"Show FOV Circle","Draws FOV circle around cursor",false,function(on)
	fovEnabled=on; FovCircle.Visible=on
end)
Slider(as,"FOV Radius",10,400,120,"px",function(v) fovRadius=v end)

-- CAMERA
SectionHeader(cs,"Field of View")
Slider(cs,"Camera FOV",30,120,70,"°",function(v) workspace.CurrentCamera.FieldOfView=v end)
SectionHeader(cs,"Controls")
Toggle(cs,"First Person Lock","Forces camera into first person",false,function(on)
	Player.CameraMaxZoomDistance = on and 0.5 or 128
end)
SectionHeader(cs,"Freecam")
Toggle(cs,"Freecam","Freeze player · fly camera freely around the map",false,function(on) setFreecam(on) end)
Slider(cs,"Freecam Speed",5,200,40,"",function(v) freecamSpeed=v end)

-- WORLD
SectionHeader(ws,"Physics")
Slider(ws,"Gravity",0,300,196,"",function(v) workspace.Gravity=v end)
SectionHeader(ws,"Rendering")
Toggle(ws,"Fullbright","Sets ambient lighting to maximum",false,function(on)
	local l=game:GetService("Lighting")
	l.Brightness=on and 10 or 1
	l.Ambient=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(70,70,70)
	l.OutdoorAmbient=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(127,127,127)
end)
Toggle(ws,"No Fog","Removes all atmospheric fog",false,function(on)
	local a=game:GetService("Lighting"):FindFirstChildOfClass("Atmosphere")
	if a then a.Density=on and 0 or 0.395 end
end)
Toggle(ws,"No Shadows","Disables character shadows",false,function(on)
	game:GetService("Lighting").GlobalShadows=not on
end)

-- ESP
SectionHeader(es,"Visibility")
Toggle(es,"Enable ESP","See all players through walls",false,function(on) espEnabled=on; refreshAllESP() end)
Toggle(es,"Show Names","Display player names above heads",true,function(on) espNames=on end)
Toggle(es,"Show Health","Health bar below player name",true,function(on) espHealth=on end)
SectionHeader(es,"Style")
Toggle(es,"Outlines","Draw orange outline around each player",true,function(on) espBoxes=on end)
Toggle(es,"Chams","Semi-transparent fill through walls",false,function(on) espChams=on end)

-- ══════════════════════════════════════════
-- ACTIVATE FIRST TAB
-- ══════════════════════════════════════════
activateTab(tabMovement)
print("[MangoGUI v2.9] Loaded ✓")
