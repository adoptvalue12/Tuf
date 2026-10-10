-- YunoHub 1.23 - Fusion complète (Main + MM2 + Floating Buttons + Themes + RGB Cursor)
-- Local names are inferred from use (the original names are not in the bytecode)

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/UI/Wind.lua"))()
lib:SetNotificationLower(true)

--========================================================================
-- THEMES
--========================================================================

lib:AddTheme({
	Name = "White-Black",
	Background = Color3.fromHex("#111111"),
	Outline = Color3.fromHex("#ffffff"),
	Text = Color3.fromHex("#ffffff"),
	Placeholder = Color3.fromHex("#aaaaaa"),
	Button = Color3.fromHex("#333333"),
	Icon = Color3.fromHex("#ffffff"),
	ToggleActive = Color3.fromHex("#00cc44"),
})

lib:AddTheme({Name="Cyberpunk",Background=Color3.fromHex("#080914"),Outline=Color3.fromHex("#00f0ff"),Text=Color3.fromHex("#ffffff"),Placeholder=Color3.fromHex("#00f0ff"),Button=Color3.fromHex("#1a0033"),Icon=Color3.fromHex("#00f0ff"),ToggleActive=Color3.fromHex("#ff0055")})
lib:AddTheme({Name="Dracula",Background=Color3.fromHex("#282a36"),Outline=Color3.fromHex("#ff79c6"),Text=Color3.fromHex("#f8f8f2"),Placeholder=Color3.fromHex("#8be9fd"),Button=Color3.fromHex("#44475a"),Icon=Color3.fromHex("#8be9fd"),ToggleActive=Color3.fromHex("#50fa7b")})
lib:AddTheme({Name="Tokyo Night",Background=Color3.fromHex("#1a1b26"),Outline=Color3.fromHex("#7dcfff"),Text=Color3.fromHex("#c0caf5"),Placeholder=Color3.fromHex("#bb9af7"),Button=Color3.fromHex("#24283b"),Icon=Color3.fromHex("#bb9af7"),ToggleActive=Color3.fromHex("#9ece6a")})
lib:AddTheme({Name="Vaporwave",Background=Color3.fromHex("#18002e"),Outline=Color3.fromHex("#05ffa1"),Text=Color3.fromHex("#fffbfe"),Placeholder=Color3.fromHex("#01cdfe"),Button=Color3.fromHex("#2d0059"),Icon=Color3.fromHex("#01cdfe"),ToggleActive=Color3.fromHex("#ff71ce")})
lib:AddTheme({Name="Onyx Gold",Background=Color3.fromHex("#0d0d0d"),Outline=Color3.fromHex("#ffd700"),Text=Color3.fromHex("#ffffff"),Placeholder=Color3.fromHex("#f3c623"),Button=Color3.fromHex("#222222"),Icon=Color3.fromHex("#f3c623"),ToggleActive=Color3.fromHex("#ffd700")})
lib:AddTheme({Name="Blood Moon",Background=Color3.fromHex("#120303"),Outline=Color3.fromHex("#ff1a1a"),Text=Color3.fromHex("#ffffff"),Placeholder=Color3.fromHex("#ff4d4d"),Button=Color3.fromHex("#330000"),Icon=Color3.fromHex("#ff4d4d"),ToggleActive=Color3.fromHex("#ff0000")})
lib:AddTheme({Name="Furina Genshin",Background=Color3.fromHex("#090d16"),Outline=Color3.fromHex("#00f0ff"),Text=Color3.fromHex("#ffffff"),Placeholder=Color3.fromHex("#70d6ff"),Button=Color3.fromHex("#121a29"),Icon=Color3.fromHex("#00f0ff"),ToggleActive=Color3.fromHex("#00f0ff")})
lib:AddTheme({Name="Closing Eyes",Background=Color3.fromHex("#181438"),Outline=Color3.fromHex("#ffffff"),Text=Color3.fromHex("#ffffff"),Placeholder=Color3.fromHex("#c0c0c0"),Button=Color3.fromHex("#3b378a"),Icon=Color3.fromHex("#ffffff"),ToggleActive=Color3.fromHex("#3b378a")})

lib:SetTheme("White-Black")

local v = lib:CreateWindow({
	Title = "Yuno Hub",
	Icon = "terminal",
	Author = "MM2 / MMV",
	Folder = "YunoHubConfig",
	Size = UDim2.fromOffset(580, 460),
	MinSize = Vector2.new(560, 350),
	MaxSize = Vector2.new(850, 560),
	Transparent = false,
	Theme = "White-Black",
	Resizable = true,
	SideBarWidth = 200,
	Background = "rbxassetid://84559674409718",
	BackgroundImageTransparency = 0.95,
	HideSearchBar = false,
	ScrollBarEnabled = true,
	User = {
		Enabled = true,
		Callback = function()
		end,
		Anonymous = false,
	},
})

v:SetToggleKey(Enum.KeyCode.Minus)
local color = Color3.fromHex

v:EditOpenButton({
	Title = "Yuno Hub",
	Icon = "terminal",
	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,
	Color = ColorSequence.new(Color3.fromHex("ffffff"), color("ffffff")),
	OnlyMobile = false,
	Enabled = true,
	Draggable = true,
})

local YunoHubMM2 = v.ConfigManager:CreateConfig("YunoHubMM2")
local HttpService = game:GetService("HttpService")
local tbl = {}
local tbl2 = {}

local function fn()
	if writefile then
		pcall(function()
			writefile("YunoHub_ButtonPositions.json", HttpService:JSONEncode(tbl))
		end)
		pcall(function()
			writefile("YunoHub_Keybinds.json", HttpService:JSONEncode(tbl2))
		end)
		pcall(function()
			YunoHubMM2:Save()
		end)
	end
end

local function fn2()
	if readfile and isfile then
		if isfile("YunoHub_ButtonPositions.json") then
			pcall(function()
				tbl = HttpService:JSONDecode(readfile("YunoHub_ButtonPositions.json"))
			end)
		end
		if isfile("YunoHub_Keybinds.json") then
			pcall(function()
				tbl2 = HttpService:JSONDecode(readfile("YunoHub_Keybinds.json"))
			end)
		end
		pcall(function()
			YunoHubMM2:Load()
		end)
	end
end

local tbl3 = {}
local flag = false

local tbl4 = {
	ShootMurderer = "Shoot Murderer",
	ThrowKnife = "Throw Knife",
	KillAll = "Kill All",
	GetDroppedGun = "Get Dropped Gun",
	SpeedGlitch = "Speed Glitch",
	FlingMurderer = "Fling Murderer",
	FlingSheriff = "Fling Sheriff",
}

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if flag then return end
	if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
	local name = input.KeyCode.Name
	for k, v2 in pairs(tbl3) do
		if v2.active and tbl2[k] == name then
			pcall(v2.action)
		end
	end
end)

task.spawn(function()
	pcall(function()
		if game.PlaceId ~= 142823291 then return end
		local response = game:HttpGet("https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/UI/LastCheckedGameVersion.json")
		if response then
			local data = HttpService:JSONDecode(response)
			if type(data) == "table" then
				local version = data.Version or data.version or data.GameVersion or data.gameVersion or data.PlaceVersion or data.placeVersion
				if not version then
					local v2, v3, v4 = pairs(data)
					local v5 = table.pack(F_1())
					if not v5[1] then
						data = version
					end
				else
					data = version
				end
			end
			if data and tostring(data) ~= tostring(game.PlaceVersion) then
				lib:Notify({
					Title = "Yuno Hub",
					Content = "Game version change detected! Some features might be patched!",
					Duration = 5,
					Icon = "triangle-alert",
				})
			end
		end
	end)
end)

local localPlayer = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local str = "Old Method"
local n = 2.8
local flag2 = false
local flag3 = false
local flag4 = false
local n2 = 200
local flag5 = false
local v2 = nil
local v3 = nil
local flag6 = false
local screenGui = nil
local flag7 = false
local connection = nil
local flag8 = false
local walkSpeed = 16
local jumpPower = 50
local connection2 = nil
local n3 = -1
local n4 = -1
local flag9 = false
local tbl5 = {}
local vector = Vector3.new(14, 516, -25)
local n5 = 3000

--========================================================================
-- FLOATING BUTTON SYSTEM (nouveau - repris du 2ème fichier adapté)
--========================================================================

local floatingButtons = {}
local floatingButtonKeybinds = {}

local function saveFloatingButtonPositions()
	if writefile then
		local data = {}
		for k, v in pairs(floatingButtons) do
			if v.button then
				data[k] = {
					X = v.button.Position.X.Offset,
					Y = v.button.Position.Y.Offset,
				}
			end
		end
		pcall(function()
			writefile("YunoHub_FloatingButtons.json", HttpService:JSONEncode(data))
		end)
	end
end

local function loadFloatingButtonPositions()
	if readfile and isfile and isfile("YunoHub_FloatingButtons.json") then
		local ok, data = pcall(function()
			return HttpService:JSONDecode(readfile("YunoHub_FloatingButtons.json"))
		end)
		if ok and data then
			return data
		end
	end
	return {}
end

local savedFloatingPositions = loadFloatingButtonPositions()

local function createFloatingButton(name, callback, defaultColor)
	if floatingButtons[name] then return end

	local sg = Instance.new("ScreenGui")
	sg.Name = "YunoFloat_" .. tostring(name):gsub("%s+", "_")
	sg.ResetOnSpawn = false
	sg.DisplayOrder = 50

	local parented = false
	pcall(function()
		if gethui then
			sg.Parent = gethui()
			parented = true
		end
	end)
	if not parented then
		pcall(function()
			sg.Parent = game.CoreGui
			parented = true
		end)
	end
	if not parented and localPlayer then
		local pGui = localPlayer:FindFirstChild("PlayerGui")
		if pGui then
			sg.Parent = pGui
		else
			sg.Parent = localPlayer:WaitForChild("PlayerGui", 10)
		end
	end

	local btn = Instance.new("TextButton")
	btn.Name = "Button"
	btn.Size = UDim2.fromOffset(150, 45)

	local saved = savedFloatingPositions[name]
	if saved then
		btn.Position = UDim2.new(0, saved.X or 100, 0, saved.Y or 100)
	else
		btn.Position = UDim2.new(0, 100 + #tostring(name) * 3, 0, 100 + #floatingButtons * 55)
	end

	btn.BackgroundColor3 = defaultColor or Color3.fromRGB(15, 15, 15)
	btn.TextColor3 = Color3.fromRGB(255, 255, 255)
	btn.Text = name
	btn.TextSize = 14
	btn.Font = Enum.Font.GothamBold
	btn.BorderSizePixel = 0
	btn.AutoButtonColor = false
	btn.Parent = sg

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 2
	stroke.Parent = btn

	local dragging = false
	local dragStart = nil
	local startPos = nil
	local dragged = false

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragged = false
			dragStart = input.Position
			startPos = btn.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					if dragging and dragged then
						saveFloatingButtonPositions()
					end
					dragging = false
				end
			end)
		end
	end)

	btn.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			if math.abs(delta.X) > 3 or math.abs(delta.Y) > 3 then
				dragged = true
			end
			if dragged then
				btn.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end
	end)

	btn.MouseButton1Click:Connect(function()
		if dragged then return end
		pcall(callback)
	end)

	-- Right click to bind key
	btn.MouseButton2Click:Connect(function()
		lib:Notify({
			Title = "Floating Button",
			Content = "Press a key to bind '" .. name .. "'...",
			Duration = 3,
			Icon = "keyboard",
		})
		task.spawn(function()
			local result = UserInputService.InputBegan:Wait()
			if result.UserInputType == Enum.UserInputType.Keyboard then
				floatingButtonKeybinds[name] = result.KeyCode
				lib:Notify({
					Title = "Floating Button",
					Content = "'" .. name .. "' bound to " .. result.KeyCode.Name,
					Duration = 3,
					Icon = "check",
				})
			end
		end)
	end)

	UserInputService.InputBegan:Connect(function(input, processed)
		if processed then return end
		if floatingButtonKeybinds[name] and input.KeyCode == floatingButtonKeybinds[name] then
			pcall(callback)
		end
	end)

	floatingButtons[name] = { gui = sg, button = btn }
	return floatingButtons[name]
end

local function removeFloatingButton(name)
	if floatingButtons[name] then
		pcall(function()
			floatingButtons[name].gui:Destroy()
		end)
		floatingButtons[name] = nil
		floatingButtonKeybinds[name] = nil
		saveFloatingButtonPositions()
	end
end

--========================================================================
-- HELPERS
--========================================================================

local function splitString(str, delim)
	local broken = {}
	if delim == nil then delim = "," end
	for w in string.gmatch(str, "[^"..delim.."]+") do
		table.insert(broken, w)
	end
	return broken
end

local function toTokens(str)
	local tokens = {}
	for op, name in string.gmatch(str, "([+-])([^+-]+)") do
		table.insert(tokens, {Operator = op, Name = name})
	end
	return tokens
end

local function onlyIncludeInTable(tab, matches)
	local matchTable = {}
	local resultTable = {}
	for i, v in pairs(matches) do matchTable[v.Name] = true end
	for i, v in pairs(tab) do if matchTable[v.Name] then table.insert(resultTable, v) end end
	return resultTable
end

local function removeTableMatches(tab, matches)
	local matchTable = {}
	local resultTable = {}
	for i, v in pairs(matches) do matchTable[v.Name] = true end
	for i, v in pairs(tab) do if not matchTable[v.Name] then table.insert(resultTable, v) end end
	return resultTable
end

local function getPlayersByName(Name)
	local Name, Len, Found = string.lower(Name), #Name, {}
	for _, v in pairs(Players:GetPlayers()) do
		if Name:sub(0, 1) == '@' then
			if string.sub(string.lower(v.Name), 1, Len - 1) == Name:sub(2) then
				table.insert(Found, v)
			end
		else
			if string.sub(string.lower(v.Name), 1, Len) == Name or string.sub(string.lower(v.DisplayName), 1, Len) == Name then
				table.insert(Found, v)
			end
		end
	end
	return Found
end

local function getPlayer(list, speaker)
	if list == nil then return {speaker.Name} end
	local nameList = splitString(list, ",")
	local foundList = {}
	for _, name in pairs(nameList) do
		if string.sub(name, 1, 1) ~= "+" and string.sub(name, 1, 1) ~= "-" then name = "+"..name end
		local tokens = toTokens(name)
		local initialPlayers = Players:GetPlayers()
		for i, v in pairs(tokens) do
			if v.Operator == "+" then
				initialPlayers = onlyIncludeInTable(initialPlayers, getPlayersByName(v.Name))
			else
				initialPlayers = removeTableMatches(initialPlayers, getPlayersByName(v.Name))
			end
		end
		for i, v in pairs(initialPlayers) do table.insert(foundList, v) end
	end
	local foundNames = {}
	for i, v in pairs(foundList) do table.insert(foundNames, v.Name) end
	return foundNames[1]
end

--========================================================================
-- FLY UTILITY
--========================================================================

local FlyUtility = (function()
	local l = {}
	local _ = game:GetService("Players")
	local b = game:GetService("RunService")
	local d = _.LocalPlayer
	local h = false
	local e = 50
	local c = 2
	local i = 0
	local g = Vector3.new()
	local j = nil
	local k = nil
	local f = nil
	local function cleanup()
		if f then f:Disconnect() f = nil end
		if j then j:Destroy() j = nil end
		if k then k:Destroy() k = nil end
		local ch = d.Character
		if ch then
			local hum = ch:FindFirstChildOfClass("Humanoid")
			if hum then hum.PlatformStand = false end
		end
		h = false
		i = 0
	end
	local function update()
		local a = d.Character
		if not h or not a then l:Stop() return end
		local hum = a:FindFirstChildOfClass("Humanoid")
		local hrp = a:FindFirstChild("HumanoidRootPart")
		local cam = workspace.CurrentCamera
		if not hum or hum.Health <= 0 or not hrp or not cam then l:Stop() return end
		local md = hum.MoveDirection
		if md.Magnitude > 0.01 then
			i = math.min(e, i + c)
			g = md.Unit
		else
			i = math.max(0, i - c)
		end
		local flat = Vector3.new(g.X, 0, g.Z)
		local vel = Vector3.zero
		if flat.Magnitude > 0 then vel = flat.Unit * i end
		local look = cam.CFrame.LookVector.Unit
		local dot = g:Dot(look)
		local sign = dot < 0 and -1 or 1
		local flatLook = Vector3.new(look.X, 0, look.Z)
		if flatLook.Magnitude > 0 then flatLook = flatLook.Unit end
		local dot2 = math.abs(g:Dot(flatLook))
		local yComp = look.Y * sign * dot2
		local yv = yComp * i
		k.Velocity = Vector3.new(vel.X, yv, vel.Z)
		local roll = (i / e) * 30
		local pitch = -math.rad(dot * roll)
		j.CFrame = CFrame.new(hrp.Position, hrp.Position + look) * CFrame.Angles(pitch, 0, 0)
	end
	function l:Start()
		if h then return end
		local ch = d.Character
		if not ch then return end
		local hum = ch:FindFirstChildOfClass("Humanoid")
		local hrp = ch:FindFirstChild("HumanoidRootPart")
		if not hum or not hrp then return end
		h = true
		j = Instance.new("BodyGyro")
		j.P = 100000
		j.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		j.CFrame = hrp.CFrame
		j.Parent = hrp
		k = Instance.new("BodyVelocity")
		k.P = 10000
		k.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		k.Velocity = Vector3.new(0, 0, 0)
		k.Parent = hrp
		hum.PlatformStand = true
		f = b.Heartbeat:Connect(update)
	end
	function l:Stop()
		if not h then return end
		cleanup()
	end
	function l:SetMaxSpeed(spd)
		if type(spd) == "number" and spd >= 0 then e = spd end
	end
	function l:GetMaxSpeed() return e end
	function l:IsFlying() return h end
	d.CharacterRemoving:Connect(function()
		if h then l:Stop() end
	end)
	return l
end)()

--========================================================================
-- MM2 CORE
--========================================================================

local function fn3()
	local character = localPlayer.Character
	if not character then return true end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then return true end
	return (humanoidRootPart.Position - vector).Magnitude < n5
end

local tbl6 = {}
for _, player in ipairs(game.Players:GetPlayers()) do
	if player ~= localPlayer then
		table.insert(tbl6, player.Name)
	end
end

local tbl7 = {}
local flag10 = false

local function fn4()
	if flag10 then return end
	flag10 = true
	task.spawn(function()
		task.wait(0.5)
		flag10 = false
		for _, v4 in ipairs(tbl7) do
			if v4 and v4.Refresh then
				pcall(function()
					v4:Refresh(tbl6)
				end)
			end
		end
	end)
end

game.Players.PlayerAdded:Connect(function(player)
	if player ~= localPlayer then
		table.insert(tbl6, player.Name)
		fn4()
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	local v4 = table.find(tbl6, player.Name)
	if v4 then
		table.remove(tbl6, v4)
		fn4()
	end
end)

local v4 = nil
v4 = hookmetamethod(game, "__namecall", function(arg, ...)
	local v5 = getnamecallmethod()
	if flag7 and not checkcaller() and v5 == "FireServer" and arg.Name == "Shoot" then
		return
	end
	return v4(arg, ...)
end)

local CurrentRoundClient = nil
task.spawn(function()
	pcall(function()
		CurrentRoundClient = require(ReplicatedStorage:WaitForChild("Modules", 10):WaitForChild("CurrentRoundClient", 10))
	end)
end)

local function fn5()
	task.wait(1)
	if not CurrentRoundClient then return end
	local playerData = CurrentRoundClient.PlayerData
	v2 = nil
	v3 = nil
	local key = playerData and next(playerData)
	local v5 = nil
	local v6 = nil
	if key then
		v5 = nil
		v6 = nil
		for k, v7 in pairs(playerData) do
			if v7.Role then
				local v8 = Players:FindFirstChild(k)
				if v8 then
					if v7.Role == "Murderer" then
						v2 = v8
					elseif v7.Role == "Sheriff" then
						v5 = v8
					elseif v7.Role == "Hero" then
						v6 = v8
					end
				end
			end
		end
	end
	v3 = v6 or v5
end

task.spawn(function()
	pcall(function()
		local gameplay = ReplicatedStorage:WaitForChild("Remotes", 10):WaitForChild("Gameplay", 10)
		if not gameplay then return end
		local roleSelect = gameplay:FindFirstChild("RoleSelect")
		if roleSelect then
			roleSelect.OnClientEvent:Connect(function()
				task.spawn(fn5)
			end)
		end
		local playerDataChanged = gameplay:FindFirstChild("PlayerDataChanged")
		if playerDataChanged then
			playerDataChanged.OnClientEvent:Connect(function()
				task.spawn(fn5)
			end)
		end
	end)
end)

local function fn6()
	local flag11 = false
	if flag5 then flag11 = v2 end
	if flag11 then return v2 end
	for _, player in ipairs(game.Players:GetPlayers()) do
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Knife") then return player end
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if not player.Character then continue end
		if player.Character:FindFirstChild("Knife") then return player end
	end
	return nil
end

local function fn7()
	local flag11 = false
	if flag5 then flag11 = v3 end
	if flag11 then return v3 end
	for _, player in ipairs(game.Players:GetPlayers()) do
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Gun") then return player end
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if not player.Character then continue end
		if player.Character:FindFirstChild("Gun") then return player end
	end
	return nil
end

local function fn8()
	local flag11 = false
	if flag5 then flag11 = v3 end
	if flag11 and v3 ~= localPlayer then return v3 end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player == localPlayer then continue end
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Gun") then return player end
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player == localPlayer then continue end
		if not player.Character then continue end
		if player.Character:FindFirstChild("Gun") then return player end
	end
	return nil
end

local function fn9()
	local huge = math.huge
	local v5 = nil
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local humanoidRootPart = localPlayer.Character:FindFirstChild("HumanoidRootPart")
			local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")
			if humanoidRootPart and humanoidRootPart2 then
				local magnitude = (humanoidRootPart.Position - humanoidRootPart2.Position).Magnitude
				if magnitude < huge then
					huge = magnitude
					v5 = player
				end
			end
		end
	end
	return v5
end

local function fn10()
	local backpack = localPlayer:FindFirstChild("Backpack")
	return backpack and backpack:FindFirstChild("Knife") or localPlayer.Character and localPlayer.Character:FindFirstChild("Knife")
end

local function fn11()
	for _, child in ipairs(workspace:GetChildren()) do
		if child:FindFirstChild("CoinContainer") and child:FindFirstChild("Spawns") then
			return child
		end
	end
	return nil
end

--========================================================================
-- PREDICTION (from 2nd file)
--========================================================================

local shootOffset = 2.8
local offsetToPingMult = 1

local function getPredictedPosition(player, offset)
	local ogplayer = player
	pcall(function()
		player = player.Character
	end)
	if not player then return Vector3.zero end
	local playerHRP = player:FindFirstChild("UpperTorso") or player:FindFirstChild("HumanoidRootPart")
	local playerHum = player:FindFirstChild("Humanoid")
	if not playerHRP or not playerHum then return Vector3.zero end
	local velocity = playerHRP.AssemblyLinearVelocity
	local playerMoveDirection = playerHum.MoveDirection
	local predictedPosition = playerHRP.Position + (velocity * Vector3.new(0.75, 0.5, 0.75)) * (offset / 15) + playerMoveDirection * offset
	predictedPosition = predictedPosition * (((localPlayer:GetNetworkPing() * 1000) * ((offsetToPingMult - 1) * 0.01)) + 1)
	return predictedPosition
end

--========================================================================
-- MAIN ACTIONS (from 1st file - original functions)
--========================================================================

local function fn12(arg, arg2)
	pcall(function() arg = arg.Character end)
	if not arg then return Vector3.zero end
	local upperTorso = arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("HumanoidRootPart")
	local humanoid = arg:FindFirstChild("Humanoid")
	if not upperTorso or not humanoid then return Vector3.zero end
	return upperTorso.Position + upperTorso.AssemblyLinearVelocity * Vector3.new(0.75, 0.5, 0.75) * arg2 / 15 + humanoid.MoveDirection * arg2
end

local function fn13(arg)
	pcall(function() arg = arg.Character end)
	if not arg then return Vector3.zero end
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
	local humanoid = arg:FindFirstChild("Humanoid")
	if not humanoidRootPart or not humanoid then return Vector3.zero end
	local position = humanoidRootPart.Position
	local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
	local moveDirection = humanoid.MoveDirection
	local lookVector = humanoidRootPart.CFrame.LookVector
	local magnitude = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
	local y = assemblyLinearVelocity.Y
	local flag11 = magnitude > 1 or moveDirection.Magnitude > 0.1
	local flag12 = y > 2
	local flag13 = y < -2
	if flag12 then return position + Vector3.new(0, 3, 0) + lookVector * (magnitude > 1 and 2 or 0) end
	if flag13 then return position + Vector3.new(0, -4, 0) + lookVector * (magnitude > 1 and 2 or 0) end
	if flag11 then return position + (moveDirection.Magnitude > 0.1 and moveDirection.Unit or lookVector) * 3 end
	return position
end

shootMurdererAction = function()
	if fn7() ~= localPlayer then
		lib:Notify({ Title = "Error", Content = "You are not sheriff", Duration = 3, Icon = "lock" })
		return
	end
	local v5 = fn6() or fn8()
	if not v5 then
		lib:Notify({ Title = "Error", Content = "No murderer to shoot", Duration = 3, Icon = "lock" })
		return
	end
	local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
	if not localPlayer.Character:FindFirstChild("Gun") then
		if not localPlayer.Backpack:FindFirstChild("Gun") then
			lib:Notify({ Title = "Error", Content = "You don't have the gun", Duration = 3, Icon = "lock" })
			return
		end
		humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("Gun"))
	end
	if not v5.Character:FindFirstChild("HumanoidRootPart") then return end
	local v6
	if str == "Smart Method" then
		v6 = fn13(v5)
	else
		v6 = fn12(v5, 2.8)
	end
	local cframe = CFrame.new
	local tbl8 = { CFrame.new(localPlayer.Character.RightHand.Position), cframe(v6) }
	localPlayer.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(tbl8))
	local flag11 = false
	if flag6 then flag11 = humanoid end
	if flag11 then humanoid:UnequipTools() end
end

killAllAction = function()
	if fn6() ~= localPlayer then
		lib:Notify({ Title = "Error", Content = "You are not murderer", Duration = 3, Icon = "lock" })
		return
	end
	if not localPlayer.Character:FindFirstChild("Knife") then
		local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
		if not localPlayer.Backpack:FindFirstChild("Knife") then
			lib:Notify({ Title = "Error", Content = "You don't have the knife", Duration = 3, Icon = "lock" })
			return
		end
		humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
	end
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= localPlayer then
			player.Character:FindFirstChild("HumanoidRootPart").Anchored = true
			local character = localPlayer.Character
			player.Character:FindFirstChild("HumanoidRootPart").CFrame = localPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame + character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1
		end
	end
	localPlayer.Character.Knife.Stab:FireServer(unpack({ "Slash" }))
	localPlayer.Character.Knife:Activate()
	task.wait(0.05)
	localPlayer.Character.Knife:Activate()
end

knifeThrowFunc = function(arg)
	if fn6() ~= localPlayer then
		if not arg then
			lib:Notify({ Title = "Error", Content = "You are not murderer", Duration = 3, Icon = "lock" })
		end
		return
	end
	if not localPlayer.Character:FindFirstChild("Knife") then
		local humanoid = localPlayer.Character:FindFirstChild("Humanoid")
		if not localPlayer.Backpack:FindFirstChild("Knife") then
			if not arg then
				lib:Notify({ Title = "Error", Content = "You don't have the knife", Duration = 3, Icon = "lock" })
			end
			return
		end
		humanoid:EquipTool(localPlayer.Backpack:FindFirstChild("Knife"))
	end
	local v5 = fn9()
	if not v5 or not v5.Character then return end
	if not v5.Character:FindFirstChild("HumanoidRootPart") then return end
	local cframe = CFrame.new
	local n6 = n + 1
	local tbl8 = { CFrame.new(localPlayer.Character.RightHand.Position), cframe(fn12(v5, n6)) }
	localPlayer.Character:WaitForChild("Knife"):WaitForChild("Events"):WaitForChild("KnifeThrown"):FireServer(unpack(tbl8))
end

-- NEW: Auto shoot with prediction (from 2nd file)
local autoShooting = false
local autoShootConnection = nil

local function startAutoShoot()
	if autoShootConnection then return end
	lib:Notify({ Title = "MM2", Content = "Auto-shoot started", Duration = 3, Icon = "info" })
	autoShootConnection = RunService.Heartbeat:Connect(function()
		if not autoShooting then return end
		if findSheriffRole() ~= localPlayer then return end
		local murderer = findMurdererRole()
		if not murderer or not murderer.Character then return end
		local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
		if not murdererHRP then return end
		if not localPlayer.Character then return end
		local charHRP = localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not charHRP then return end
		local rayDirection = (murdererHRP.Position - charHRP.Position).Unit * 500
		local raycastParams = RaycastParams.new()
		raycastParams.FilterType = Enum.RaycastFilterType.Exclude
		raycastParams.FilterDescendantsInstances = {localPlayer.Character}
		local hit = workspace:Raycast(charHRP.Position, rayDirection, raycastParams)
		if not hit or hit.Instance:IsDescendantOf(murderer.Character) then
			if not localPlayer.Character:FindFirstChild("Gun") then
				local backpack = localPlayer:FindFirstChild("Backpack")
				if backpack and backpack:FindFirstChild("Gun") then
					localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(backpack.Gun)
				end
			end
			local gun = localPlayer.Character:FindFirstChild("Gun")
			if gun then
				local predictedPosition = getPredictedPosition(murderer, shootOffset)
				pcall(function()
					local args = {
						CFrame.new(localPlayer.Character.RightHand.Position),
						CFrame.new(predictedPosition)
					}
					gun.Shoot:FireServer(unpack(args))
				end)
			end
		end
	end)
end

local function stopAutoShoot()
	autoShooting = false
	if autoShootConnection then
		autoShootConnection:Disconnect()
		autoShootConnection = nil
	end
end

-- NEW: Auto knife throw loop
local autoKnifeThrow = false

task.spawn(function()
	while task.wait(1.5) do
		if autoKnifeThrow then
			pcall(function()
				knifeThrowFunc(true)
			end)
		end
	end
end)

-- NEW: findSheriffRole / findMurdererRole (alias to fn6/fn7 for clarity)
findMurdererRole = fn6
findSheriffRole = fn7
findNearestPlayer = fn9

-- NEW: Round timer
local roundTimerText = nil
local roundTimerConnection = nil

local function startRoundTimer()
	if roundTimerText then return end
	local sg = Instance.new("ScreenGui")
	sg.Name = "YunoRoundTimer"
	sg.ResetOnSpawn = false
	pcall(function() sg.Parent = game.CoreGui end)
	if not sg.Parent then
		local pGui = localPlayer:FindFirstChild("PlayerGui")
		if pGui then sg.Parent = pGui end
	end

	roundTimerText = Instance.new("TextLabel")
	roundTimerText.Size = UDim2.fromOffset(200, 35)
	roundTimerText.Position = UDim2.fromScale(0.5, 0.1)
	roundTimerText.AnchorPoint = Vector2.new(0.5, 0.5)
	roundTimerText.BackgroundTransparency = 1
	roundTimerText.TextColor3 = Color3.fromRGB(255, 255, 255)
	roundTimerText.TextScaled = true
	roundTimerText.Font = Enum.Font.GothamBold
	roundTimerText.TextStrokeTransparency = 0.5
	roundTimerText.Text = "0m 0s"
	roundTimerText.Parent = sg

	roundTimerConnection = RunService.Heartbeat:Connect(function()
		local roundPart = workspace:FindFirstChild("RoundTimerPart")
		if roundPart then
			local timeLeft = roundPart:GetAttribute("Time")
			if timeLeft and timeLeft ~= -1 then
				local mins = math.floor(timeLeft / 60)
				local secs = timeLeft % 60
				roundTimerText.Text = string.format("%dm %ds", mins, secs)
			else
				roundTimerText.Text = ""
			end
		else
			roundTimerText.Text = ""
		end
	end)
end

local function stopRoundTimer()
	if roundTimerConnection then
		roundTimerConnection:Disconnect()
		roundTimerConnection = nil
	end
	if roundTimerText then
		roundTimerText.Parent:Destroy()
		roundTimerText = nil
	end
end

--========================================================================
-- GUI ACTIONS
--========================================================================

local function fn14()
	if fn10() then
		lib:Notify({ Title = "Error", Content = "You are the murderer", Duration = 3, Icon = "lock" })
		return
	end
	if fn3() then
		lib:Notify({ Title = "Error", Content = "You cant get gun when not in game", Duration = 3, Icon = "lock" })
		return
	end
	local v5 = fn11()
	if not v5 or not v5:FindFirstChild("GunDrop") then
		lib:Notify({ Title = "Error", Content = "Dropped gun not found", Duration = 3, Icon = "lock" })
		return
	end
	local character = localPlayer.Character
	if not character then return end
	local pivot = character:GetPivot()
	character:PivotTo(v5:FindFirstChild("GunDrop"):GetPivot())
	localPlayer.Backpack.ChildAdded:Wait()
	character:PivotTo(pivot)
	lib:Notify({ Title = "Info", Content = "Dropped gun has been get", Duration = 3, Icon = "info" })
end

workspace.DescendantAdded:Connect(function(descendant)
	if descendant.Name == "GunDrop" then
		if flag2 then
			if fn10() then return end
			if fn3() then return end
			task.spawn(function()
				local v5 = fn11()
				if not v5 or not v5:FindFirstChild("GunDrop") then return end
				local pivot = localPlayer.Character:GetPivot()
				localPlayer.Character:PivotTo(v5:FindFirstChild("GunDrop"):GetPivot())
				localPlayer.Backpack.ChildAdded:Wait()
				localPlayer.Character:PivotTo(pivot)
				lib:Notify({ Title = "Info", Content = "Dropped gun has been get", Duration = 3, Icon = "info" })
			end)
		end
	end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
	if flag8 and localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		end
	end
end)

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if flag7 and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Gun") then
			local v5 = fn6() or fn8()
			if not v5 then return end
			if not (v5.Character and v5.Character:FindFirstChild("HumanoidRootPart")) then return end
			local v6
			if str == "Smart Method" then
				v6 = fn13(v5)
			else
				v6 = fn12(v5, 2.8)
			end
			local cframe = CFrame.new
			local tbl8 = { CFrame.new(localPlayer.Character.RightHand.Position), cframe(v6) }
			pcall(function()
				localPlayer.Character:WaitForChild("Gun"):WaitForChild("Shoot"):FireServer(unpack(tbl8))
			end)
		end
	end
end)

local function fn15(arg)
	local humanoid = arg:FindFirstChild("Humanoid") or arg:WaitForChild("Humanoid", 5)
	if not humanoid then return end
	if connection2 then connection2:Disconnect() end
	n3 = -1
	n4 = -1
	connection2 = RunService.Heartbeat:Connect(function()
		if not humanoid or not humanoid.Parent then return end
		local jumpPower2, walkSpeed2
		if not flag4 then
			jumpPower2 = 50
			walkSpeed2 = 16
		else
			local state = humanoid:GetState()
			if (state == Enum.HumanoidStateType.Jumping or state == Enum.HumanoidStateType.Freefall) and humanoid.MoveDirection.Magnitude > 0 then
				walkSpeed2 = n2
			else
				walkSpeed2 = 16
			end
			jumpPower2 = 50
		end
		if walkSpeed2 ~= n3 then
			humanoid.WalkSpeed = walkSpeed2
			n3 = walkSpeed2
		end
		if jumpPower2 ~= n4 then
			humanoid.JumpPower = jumpPower2
			n4 = jumpPower2
		end
	end)
end

local function fn16()
	flag4 = false
	if connection2 then connection2:Disconnect() connection2 = nil end
	if localPlayer.Character then
		local humanoid = localPlayer.Character:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = walkSpeed
			humanoid.JumpPower = jumpPower
		end
	end
	n3 = -1
	n4 = -1
end

localPlayer.CharacterAdded:Connect(function(character)
	n3 = -1
	n4 = -1
	if flag4 then
		task.wait(0.5)
		fn15(character)
	end
end)

--========================================================================
-- MM2 NEW FEATURES (from 2nd file)
--========================================================================

-- Kill closest player as murderer
local function killClosestPlayer()
	if fn6() ~= localPlayer then
		lib:Notify({ Title = "Error", Content = "You're not murderer", Duration = 3, Icon = "lock" })
		return
	end
	if not localPlayer.Character:FindFirstChild("Knife") then
		local backpack = localPlayer:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Knife") then
			localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(backpack.Knife)
		else
			lib:Notify({ Title = "Error", Content = "You don't have the knife", Duration = 3, Icon = "lock" })
			return
		end
	end
	local nearest = findNearestPlayer()
	if not nearest or not nearest.Character then
		lib:Notify({ Title = "Error", Content = "Can't find a player", Duration = 3, Icon = "lock" })
		return
	end
	local nearestHRP = nearest.Character:FindFirstChild("HumanoidRootPart")
	if not nearestHRP then return end
	nearestHRP.Anchored = true
	nearestHRP.CFrame = localPlayer.Character.HumanoidRootPart.CFrame + localPlayer.Character.HumanoidRootPart.CFrame.LookVector * 2
	task.wait(0.1)
	localPlayer.Character.Knife.Stab:FireServer("Slash")
end

-- Murderer Kill Aura
local killAuraConnection = nil
local function startKillAura()
	if killAuraConnection then return end
	killAuraConnection = RunService.Heartbeat:Connect(function()
		if not localPlayer.Character then return end
		local charHRP = localPlayer.Character:FindFirstChild("HumanoidRootPart")
		if not charHRP then return end
		for _, player in ipairs(Players:GetPlayers()) do
			if player ~= localPlayer and player.Character then
				local hrp = player.Character:FindFirstChild("HumanoidRootPart")
				if hrp and (hrp.Position - charHRP.Position).Magnitude < 7 then
					hrp.Anchored = true
					hrp.CFrame = charHRP.CFrame + charHRP.CFrame.LookVector * 2
					task.wait(0.1)
					local knife = localPlayer.Character:FindFirstChild("Knife")
					if knife then
						pcall(function()
							knife.Stab:FireServer("Slash")
						end)
					end
					return
				end
			end
		end
	end)
end
local function stopKillAura()
	if killAuraConnection then killAuraConnection:Disconnect() killAuraConnection = nil end
end

-- Kill everyone
local function killEveryone()
	if fn6() ~= localPlayer then
		lib:Notify({ Title = "Error", Content = "You're not murderer", Duration = 3, Icon = "lock" })
		return
	end
	if not localPlayer.Character:FindFirstChild("Knife") then
		local backpack = localPlayer:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Knife") then
			localPlayer.Character:FindFirstChild("Humanoid"):EquipTool(backpack.Knife)
		else
			lib:Notify({ Title = "Error", Content = "You don't have the knife", Duration = 3, Icon = "lock" })
			return
		end
	end
	local charHRP = localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not charHRP then return end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Anchored = true
				hrp.CFrame = charHRP.CFrame + charHRP.CFrame.LookVector * 1
			end
		end
	end
	localPlayer.Character.Knife.Stab:FireServer("Slash")
end

-- Hold everyone hostage
local function holdEveryoneHostage()
	if fn6() ~= localPlayer then
		lib:Notify({ Title = "Warning", Content = "You're not murderer but still trying", Duration = 3, Icon = "triangle-alert" })
	end
	local charHRP = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not charHRP then return end
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character then
			local hrp = player.Character:FindFirstChild("HumanoidRootPart")
			if hrp then
				hrp.Anchored = true
				hrp.CFrame = charHRP.CFrame + charHRP.CFrame.LookVector * 5
			end
		end
	end
	lib:Notify({ Title = "MM2", Content = "Every player placed in single point", Duration = 3, Icon = "info" })
end

-- God mode (from 2nd file, credits EdgeIY)
local function godMode()
	local Cam = workspace.CurrentCamera
	local Pos, Char = Cam.CFrame, localPlayer.Character
	if not Char then return end
	local Human = Char:FindFirstChildWhichIsA("Humanoid")
	if not Human then return end
	local nHuman = Human:Clone()
	nHuman.Parent = Char
	localPlayer.Character = nil
	nHuman:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	nHuman:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
	nHuman:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
	nHuman.BreakJointsOnDeath = true
	Human:Destroy()
	localPlayer.Character = Char
	Cam.CameraSubject = nHuman
	Cam.CFrame = Pos
	nHuman.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	local Script = Char:FindFirstChild("Animate")
	if Script then
		Script.Disabled = true
		task.wait()
		Script.Disabled = false
	end
	nHuman.Health = nHuman.MaxHealth
end

-- Send murderer/sheriff names into chat
local function sendRolesToChat()
	local textchannels = game:GetService("TextChatService"):WaitForChild("TextChannels"):GetChildren()
	for _, tc in ipairs(textchannels) do
		if tc.Name ~= "RBXSystem" then
			local murd = fn6()
			local sher = fn7()
			local murdName = murd and murd.Name or "-"
			local sherName = sher and sher.Name or "-"
			local message = string.format("Murderer: %s | Sheriff: %s | <<Yuno Hub>>", murdName, sherName)
			pcall(function()
				tc:SendAsync(message)
			end)
		end
	end
end

-- Teleport to lobby
local function teleportToLobby()
	local lobby = workspace:FindFirstChild("Lobby")
	if lobby then
		local spawnLoc = lobby:FindFirstChild("Spawns") and lobby.Spawns:FindFirstChildWhichIsA("SpawnLocation")
		if spawnLoc and localPlayer.Character then
			localPlayer.Character:MoveTo(spawnLoc.Position)
		end
	end
end

-- Teleport to map
local function teleportToMap()
	local map = fn11()
	if map then
		local spawns = map:FindFirstChild("Spawns")
		if spawns then
			local spawnsList = spawns:GetChildren()
			if #spawnsList > 0 then
				local randomSpawn = spawnsList[math.random(1, #spawnsList)]
				if localPlayer.Character then
					localPlayer.Character:MoveTo(randomSpawn.Position)
				end
			end
		end
	else
		lib:Notify({ Title = "Error", Content = "No map found", Duration = 3, Icon = "lock" })
	end
end

--========================================================================
-- FLING (SkidFling)
--========================================================================

local cFrame = nil

local function fn31()
	flag3 = false
	if screenGui then return end
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlingStopGui"
	pcall(function() screenGui.Parent = game.CoreGui end)
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0, 160, 0, 45)
	frame2.Position = UDim2.new(0.5, -80, 1, -120)
	frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame2.BorderSizePixel = 0
	frame2.Active = true
	frame2.Parent = screenGui
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame2
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 2
	uiStroke.Parent = frame2
	local textButton2 = Instance.new("TextButton")
	textButton2.Size = UDim2.new(1, 0, 1, 0)
	textButton2.BackgroundTransparency = 1
	textButton2.Text = "Stop Fling"
	textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 15
	textButton2.Parent = frame2
	textButton2.MouseButton1Click:Connect(function()
		flag3 = true
	end)
end

local function fn32()
	if screenGui then screenGui:Destroy() screenGui = nil end
	if cFrame then
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if humanoidRootPart then
			local now = tick()
			while true do
				humanoidRootPart.CFrame = cFrame * CFrame.new(0, 0.5, 0)
				character:SetPrimaryPartCFrame(cFrame * CFrame.new(0, 0.5, 0))
				if humanoid then humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("BasePart") then
						child.Velocity = Vector3.zero
						child.RotVelocity = Vector3.zero
					end
				end
				task.wait()
				if not ((humanoidRootPart.Position - cFrame.p).Magnitude < 25 or tick() - now > 3) then continue end
				break
			end
		end
		cFrame = nil
	end
	workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
end

local function SkidFling(TargetPlayer)
	if not TargetPlayer then return end
	local player = localPlayer
	local Players_ = game:GetService("Players")
	local Character = player.Character
	local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
	local RootPart = Humanoid and Humanoid.RootPart
	local TCharacter = TargetPlayer.Character
	if not TCharacter then
		lib:Notify({ Title = "Error", Content = "Target has no character", Duration = 3, Icon = "lock" })
		return
	end
	local THumanoid, TRootPart, THead, Accessory, Handle
	if TCharacter:FindFirstChildOfClass("Humanoid") then THumanoid = TCharacter:FindFirstChildOfClass("Humanoid") end
	if THumanoid and THumanoid.RootPart then TRootPart = THumanoid.RootPart end
	if TCharacter:FindFirstChild("Head") then THead = TCharacter.Head end
	if TCharacter:FindFirstChildOfClass("Accessory") then Accessory = TCharacter:FindFirstChildOfClass("Accessory") end
	if Accessory and Accessory:FindFirstChild("Handle") then Handle = Accessory.Handle end
	if not (Character and Humanoid and RootPart) then
		lib:Notify({ Title = "Error", Content = "No valid character of said target player", Duration = 3, Icon = "lock" })
		return
	end
	if RootPart.Velocity.Magnitude < 50 then getgenv().OldPos = RootPart.CFrame end
	if THead then
		if THead.Velocity.Magnitude > 500 then
			lib:Notify({ Title = "Info", Content = "Player already flung. Flinging again...", Duration = 3, Icon = "info" })
		end
	elseif not THead and Handle then
		if Handle.Velocity.Magnitude > 500 then
			lib:Notify({ Title = "Info", Content = "Player already flung. Flinging again...", Duration = 3, Icon = "info" })
		end
	end
	if THead then
		workspace.CurrentCamera.CameraSubject = THead
	elseif not THead and Handle then
		workspace.CurrentCamera.CameraSubject = Handle
	elseif THumanoid and TRootPart then
		workspace.CurrentCamera.CameraSubject = THumanoid
	end
	if not TCharacter:FindFirstChildWhichIsA("BasePart") then return end
	local FPos = function(BasePart, Pos, Ang)
		RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
		Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
		RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
		RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
	end
	local SFBasePart = function(BasePart)
		local TimeToWait = 2
		local Time = tick()
		local Angle = 0
		repeat
			if RootPart and THumanoid then
				if BasePart.Velocity.Magnitude < 50 then
					Angle = Angle + 100
					FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection, CFrame.Angles(math.rad(Angle), 0, 0))
					task.wait()
				else
					FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(-90), 0, 0))
					task.wait()
					FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
					task.wait()
				end
			else
				break
			end
		until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players_ or TargetPlayer.Character ~= TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
	end
	getgenv().FPDH = workspace.FallenPartsDestroyHeight
	workspace.FallenPartsDestroyHeight = 0 / 0
	local BV = Instance.new("BodyVelocity")
	BV.Name = "EpixVel"
	BV.Parent = RootPart
	BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
	BV.MaxForce = Vector3.new(1 / 0, 1 / 0, 1 / 0)
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
	if TRootPart and THead then
		if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
			SFBasePart(THead)
		else
			SFBasePart(TRootPart)
		end
	elseif TRootPart and not THead then
		SFBasePart(TRootPart)
	elseif not TRootPart and THead then
		SFBasePart(THead)
	elseif not TRootPart and not THead and Accessory and Handle then
		SFBasePart(Handle)
	else
		lib:Notify({ Title = "Error", Content = "Can't find a proper part of target player to fling.", Duration = 3, Icon = "lock" })
	end
	BV:Destroy()
	Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
	workspace.CurrentCamera.CameraSubject = Humanoid
	repeat
		RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
		Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
		Humanoid:ChangeState("GettingUp")
		for _, x in ipairs(Character:GetChildren()) do
			if x:IsA("BasePart") then
				x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
			end
		end
		task.wait()
	until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25 or flag3
	workspace.FallenPartsDestroyHeight = getgenv().FPDH
end

--========================================================================
-- GUI CREATORS (original)
--========================================================================

local flag11 = false

local function fn17(arg)
	local viewportSize = workspace.CurrentCamera.ViewportSize
	local absoluteSize = arg.AbsoluteSize
	local absolutePosition = arg.AbsolutePosition
	local n6 = absoluteSize.X / 2
	local n7 = absoluteSize.Y / 2
	local n8 = math.clamp(absolutePosition.X, -n6, viewportSize.X - n6)
	local n9 = math.clamp(absolutePosition.Y, -n7, viewportSize.Y - n7)
	arg.Position = UDim2.new(0, n8, 0, n9)
end

local function fn18(arg, arg2, arg3)
	local flag12 = false
	local v5 = nil
	local position = nil
	local position2 = nil
	local vector2 = Vector2.new(0, 0)
	local flag13 = false
	local n6 = 5
	if tbl[arg3] then
		arg2.Position = UDim2.new(tbl[arg3].XScale, tbl[arg3].XOffset, tbl[arg3].YScale, tbl[arg3].YOffset)
	end
	arg.InputBegan:Connect(function(input)
		if flag11 then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			flag12 = true
			flag13 = false
			vector2 = Vector2.new(0, 0)
			position = input.Position
			position2 = arg2.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					flag12 = false
					if flag13 then
						fn17(arg2)
						tbl[arg3] = {
							XScale = arg2.Position.X.Scale,
							XOffset = arg2.Position.X.Offset,
							YScale = arg2.Position.Y.Scale,
							YOffset = arg2.Position.Y.Offset,
						}
					end
				end
			end)
		end
	end)
	arg.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			v5 = input
		end
	end)
	arg.MouseButton1Click:Connect(function() end)
	UserInputService.InputChanged:Connect(function(input)
		if input == v5 and flag12 then
			local n7 = input.Position - position
			vector2 = Vector2.new(math.abs(n7.X) + math.abs(n7.Y), 0)
			if n6 <= vector2.X then flag13 = true end
			if flag13 then
				arg2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n7.X, position2.Y.Scale, position2.Y.Offset + n7.Y)
			end
		end
	end)
	return { getWasDragged = function() return flag13 end }
end

local function fn19(arg, arg2)
	local v5 = tbl4[arg] or arg
	if arg2 == "Escape" then
		if tbl2[arg] then
			tbl2[arg] = nil
			lib:Notify({ Title = "Info", Content = "Keybind Removed / " .. v5, Duration = 3, Icon = "info" })
		end
	else
		tbl2[arg] = arg2
		lib:Notify({ Title = "Info", Content = "Keybind Set / " .. v5 .. " / " .. arg2, Duration = 3, Icon = "info" })
	end
end

local function createScreenGui(name, text, arg, arg2, arg3)
	local screenGui2 = Instance.new("ScreenGui")
	screenGui2.Name = name
	screenGui2.ResetOnSpawn = false
	pcall(function() screenGui2.Parent = game.CoreGui end)
	if not screenGui2.Parent then
		screenGui2.Parent = localPlayer:WaitForChild("PlayerGui", 10)
	end
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 160, 0, 45)
	frame.Position = UDim2.new(0.5, -80, 0.5, arg2)
	frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame.BorderSizePixel = 0
	frame.Active = true
	frame.Draggable = false
	frame.Parent = screenGui2
	local uiCorner = Instance.new("UICorner")
	uiCorner.CornerRadius = UDim.new(0, 8)
	uiCorner.Parent = frame
	local uiStroke = Instance.new("UIStroke")
	uiStroke.Color = Color3.fromRGB(255, 255, 255)
	uiStroke.Thickness = 2
	uiStroke.Parent = frame
	local textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.BackgroundTransparency = 1
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 15
	textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton.Parent = frame
	local function fn20()
		textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		textButton.Text = text
	end
	fn20()
	tbl3[arg] = { action = arg3, active = true }
	local v5 = fn18(textButton, frame, arg)
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local color2 = Color3.fromRGB(50, 230, 110)
	local color3 = Color3.fromRGB(255, 255, 255)
	local function fn21(arg4)
		TweenService:Create(textButton, tweenInfo, { TextColor3 = arg4 and color2 or color3 }):Play()
	end
	local flag12 = false
	textButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			flag12 = true
			fn21(true)
		end
	end)
	textButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if flag12 then
				local v6 = tbl4[arg] or text
				if tbl2[arg] then
					tbl2[arg] = nil
					lib:Notify({ Title = "Info", Content = "Keybind Removed / " .. v6, Duration = 3, Icon = "info" })
				end
			end
			flag12 = false
			fn21(false)
			fn20()
		end
	end)
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if not flag12 then return end
		if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
		local name2 = input.KeyCode.Name
		flag = true
		flag12 = false
		fn21(false)
		fn19(arg, name2)
		fn20()
		task.defer(function()
			flag = false
		end)
	end)
	textButton.MouseButton1Click:Connect(function()
		if v5.getWasDragged() then return end
		arg3()
	end)
	return screenGui2
end

--========================================================================
-- MAIN TAB
--========================================================================

local v5Tab = v:Tab({ Title = "Main", Icon = "box", Locked = false })

v5Tab:Toggle({
	Title = "Shoot Murderer",
	Flag = "ScreenShootFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			createFloatingButton("Shoot Murderer", shootMurdererAction, Color3.fromRGB(200, 30, 30))
		else
			removeFloatingButton("Shoot Murderer")
		end
	end,
})

v5Tab:Toggle({
	Title = "Silent Aim",
	Flag = "SilentAimFlag",
	Value = false,
	Callback = function(arg)
		flag7 = arg
	end,
})

v5Tab:Divider()

v5Tab:Toggle({
	Title = "Throw Knife",
	Flag = "ScreenThrowFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			createFloatingButton("Throw Knife", function() knifeThrowFunc(false) end, Color3.fromRGB(150, 0, 100))
		else
			removeFloatingButton("Throw Knife")
		end
	end,
})

v5Tab:Button({
	Title = "Kill All",
	Callback = function()
		killAllAction()
	end,
})

v5Tab:Button({
	Title = "Kill All (Floating)",
	Callback = function()
		createFloatingButton("Kill All", killAllAction, Color3.fromRGB(200, 0, 0))
		lib:Notify({ Title = "Info", Content = "Kill All floating button added", Duration = 3, Icon = "info" })
	end,
})

v5Tab:Divider()

v5Tab:Button({
	Title = "Get Dropped Gun",
	Callback = function()
		fn14()
	end,
})

v5Tab:Toggle({
	Title = "Auto Get Dropped Gun",
	Flag = "AutoGetDroppedGunFlag",
	Value = false,
	Callback = function(arg)
		flag2 = arg
		if arg then
			if fn10() then return end
			if fn3() then return end
			local v6 = fn11()
			if v6 and v6:FindFirstChild("GunDrop") then
				local pivot = localPlayer.Character:GetPivot()
				localPlayer.Character:PivotTo(v6:FindFirstChild("GunDrop"):GetPivot())
				localPlayer.Backpack.ChildAdded:Wait()
				localPlayer.Character:PivotTo(pivot)
			end
		end
	end,
})

v5Tab:Button({
	Title = "Get Dropped Gun (Floating)",
	Callback = function()
		createFloatingButton("Get Dropped Gun", fn14, Color3.fromRGB(180, 150, 0))
		lib:Notify({ Title = "Info", Content = "Floating button added", Duration = 3, Icon = "info" })
	end,
})

v5Tab:Divider()

v5Tab:Slider({
	Title = "Speed Value",
	Flag = "SpeedValueFlag",
	Step = 1,
	Value = { Min = 16, Max = 500, Default = 200 },
	Callback = function(arg)
		n2 = arg
	end,
})

v5Tab:Toggle({
	Title = "Speed Glitch",
	Flag = "SpeedGlitchDirectFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			createFloatingButton("Speed Glitch", function()
				flag4 = not flag4
				if flag4 then
					if localPlayer.Character then
						fn15(localPlayer.Character)
					end
				else
					fn16()
				end
			end, Color3.fromRGB(0, 150, 200))
		else
			removeFloatingButton("Speed Glitch")
		end
	end,
})

--========================================================================
-- MM2 TAB (NEW from 2nd file)
--========================================================================

local vMM2 = v:Tab({ Title = "MM2", Icon = "sword", Locked = false })

vMM2:Toggle({
	Title = "Auto Shoot Murderer",
	Flag = "AutoShootFlag",
	Value = false,
	Callback = function(arg)
		autoShooting = arg
		if arg then
			startAutoShoot()
			createFloatingButton("Auto Shoot ON", function()
				-- Floating button just visual indicator
			end, Color3.fromRGB(0, 200, 0))
		else
			stopAutoShoot()
			removeFloatingButton("Auto Shoot ON")
		end
	end,
})

vMM2:Toggle({
	Title = "Auto Knife Throw",
	Flag = "AutoKnifeThrowFlag",
	Value = false,
	Callback = function(arg)
		autoKnifeThrow = arg
		if arg then
			createFloatingButton("Auto Knife ON", function() end, Color3.fromRGB(200, 0, 150))
		else
			removeFloatingButton("Auto Knife ON")
		end
	end,
})

vMM2:Input({
	Title = "Shoot Position Offset",
	Flag = "ShootOffsetInput",
	Value = "2.8",
	Placeholder = "e.g. 2.8",
	Callback = function(text)
		local num = tonumber(text)
		if num then
			shootOffset = num
			lib:Notify({ Title = "MM2", Content = "Shoot offset = " .. num, Duration = 3, Icon = "info" })
		end
	end,
})

vMM2:Input({
	Title = "Offset to Ping Multiplier",
	Flag = "OffsetPingInput",
	Value = "1",
	Placeholder = "e.g. 1",
	Callback = function(text)
		local num = tonumber(text)
		if num then
			offsetToPingMult = num
			lib:Notify({ Title = "MM2", Content = "Ping multiplier = " .. num, Duration = 3, Icon = "info" })
		end
	end,
})

vMM2:Divider()

vMM2:Button({
	Title = "Kill Closest Player (Murderer)",
	Callback = function()
		killClosestPlayer()
	end,
})

vMM2:Button({
	Title = "Kill Closest (Floating)",
	Callback = function()
		createFloatingButton("Kill Closest", killClosestPlayer, Color3.fromRGB(200, 30, 30))
	end,
})

vMM2:Toggle({
	Title = "Murderer Kill Aura",
	Flag = "KillAuraFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			startKillAura()
		else
			stopKillAura()
		end
	end,
})

vMM2:Button({
	Title = "Kill EVERYONE (Murderer)",
	Callback = function()
		killEveryone()
	end,
})

vMM2:Button({
	Title = "Kill Everyone (Floating)",
	Callback = function()
		createFloatingButton("Kill Everyone", killEveryone, Color3.fromRGB(200, 0, 0))
	end,
})

vMM2:Divider()

vMM2:Button({
	Title = "Send Murderer & Sheriff to Chat",
	Callback = function()
		sendRolesToChat()
	end,
})

vMM2:Toggle({
	Title = "Round Timer",
	Flag = "RoundTimerFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			startRoundTimer()
		else
			stopRoundTimer()
		end
	end,
})

vMM2:Divider()

vMM2:Button({
	Title = "Teleport to Lobby",
	Callback = function()
		teleportToLobby()
	end,
})

vMM2:Button({
	Title = "Teleport to Map",
	Callback = function()
		teleportToMap()
	end,
})

vMM2:Divider()

vMM2:Button({
	Title = "Hold Everyone Hostage (Fun)",
	Callback = function()
		holdEveryoneHostage()
	end,
})

vMM2:Button({
	Title = "God Mode (VERY UNSTABLE)",
	Callback = function()
		pcall(godMode)
	end,
})

vMM2:Divider()

vMM2:Text({
	Title = "Floating Buttons Manager",
})

vMM2:Button({
	Title = "Remove ALL Floating Buttons",
	Callback = function()
		for name, _ in pairs(floatingButtons) do
			removeFloatingButton(name)
		end
		lib:Notify({ Title = "Info", Content = "All floating buttons removed", Duration = 3, Icon = "trash" })
	end,
})

--========================================================================
-- HIGHLIGHT TAB
--========================================================================

local espFlag12 = false
local espFlag13 = false
local espFlag14 = false
local espFlag15 = false
local tbl8 = {}
local tbl9 = {}
local n6 = 1500
local highlight = Instance.new("Highlight")
pcall(function() highlight.Parent = game.CoreGui end)
highlight.FillColor = Color3.fromRGB(255, 255, 0)
highlight.FillTransparency = 0.5
highlight.OutlineTransparency = 1
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = false
local billboardGui = nil
local flag16 = false

local function fn38(parent)
	if not billboardGui then
		billboardGui = Instance.new("BillboardGui")
		billboardGui.Name = "ESP_GunDrop_Billboard"
		billboardGui.Size = UDim2.new(0, 120, 0, 30)
		billboardGui.StudsOffset = Vector3.new(0, 3, 0)
		billboardGui.AlwaysOnTop = true
		billboardGui.ResetOnSpawn = false
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Name = "GunDropLabel"
		textLabel2.Size = UDim2.new(1, 0, 1, 0)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.Arcade
		textLabel2.TextSize = 18
		textLabel2.TextColor3 = Color3.fromRGB(255, 255, 0)
		textLabel2.TextStrokeTransparency = 0.5
		textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel2.Text = "Dropped Gun"
		textLabel2.Parent = billboardGui
	end
	if billboardGui.Parent ~= parent then
		billboardGui.Parent = parent
	end
	return billboardGui
end

local function fn39()
	if billboardGui then
		billboardGui:Destroy()
		billboardGui = nil
	end
	flag16 = false
end

local function fn40(arg, arg2)
	local billboardGui2 = tbl9[arg]
	if not billboardGui2 then
		billboardGui2 = Instance.new("BillboardGui")
		billboardGui2.Name = "ESP_Billboard"
		billboardGui2.Size = UDim2.new(0, 100, 0, 30)
		billboardGui2.StudsOffset = Vector3.new(0, 3, 0)
		billboardGui2.AlwaysOnTop = true
		billboardGui2.ResetOnSpawn = false
		local textLabel2 = Instance.new("TextLabel")
		textLabel2.Name = "RoleLabel"
		textLabel2.Size = UDim2.new(1, 0, 1, 0)
		textLabel2.BackgroundTransparency = 1
		textLabel2.Font = Enum.Font.Arcade
		textLabel2.TextSize = 18
		textLabel2.TextStrokeTransparency = 0.5
		textLabel2.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
		textLabel2.Parent = billboardGui2
		tbl9[arg] = billboardGui2
	end
	local head = arg2:FindFirstChild("Head")
	if head and billboardGui2.Parent ~= head then
		billboardGui2.Parent = head
	end
	return billboardGui2
end

local function fn41(arg)
	local v6 = tbl9[arg]
	if v6 then
		v6:Destroy()
		tbl9[arg] = nil
	end
end

local function fn42(arg)
	local currentCamera = workspace.CurrentCamera
	if not currentCamera then return false end
	return (currentCamera.CFrame.Position - arg).Magnitude > n6
end

RunService.RenderStepped:Connect(function()
	for _, player in ipairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			local character = player.Character
			local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local flag17 = character ~= nil and humanoidRootPart ~= nil and humanoid ~= nil and humanoid.Health > 0 and character.Parent == workspace
			local highlight2 = tbl8[player]
			if flag17 then
				if not highlight2 then
					highlight2 = Instance.new("Highlight")
					highlight2.Parent = game.CoreGui
					highlight2.FillTransparency = 0.5
					highlight2.OutlineTransparency = 1
					highlight2.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
					tbl8[player] = highlight2
				end
				if highlight2.Adornee ~= character then
					highlight2.Adornee = character
				end
				local flag18 = player:GetAttribute("Alive") == true
				local flag19 = flag18 and (player == v2 or player == fn6())
				flag18 = flag18 and (player == v3 or player == fn7())
				local v6 = fn42(humanoidRootPart.Position)
				if flag19 then
					highlight2.FillColor = Color3.fromRGB(255, 0, 0)
					highlight2.Enabled = espFlag12 and not v6
					if espFlag12 and not v6 then
						local v7 = fn40(player, character)
						local roleLabel = v7:FindFirstChild("RoleLabel")
						if roleLabel then
							roleLabel.Text = "Murderer"
							roleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
						end
						v7.Enabled = true
					else
						local v7 = tbl9[player]
						if v7 then v7.Enabled = false end
					end
				elseif flag18 then
					highlight2.FillColor = Color3.fromRGB(0, 0, 255)
					highlight2.Enabled = espFlag13 and not v6
					if espFlag13 and not v6 then
						local v7 = fn40(player, character)
						local roleLabel = v7:FindFirstChild("RoleLabel")
						if roleLabel then
							roleLabel.Text = "Sheriff"
							roleLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
						end
						v7.Enabled = true
					else
						local v7 = tbl9[player]
						if v7 then v7.Enabled = false end
					end
				else
					highlight2.FillColor = Color3.fromRGB(255, 255, 255)
					highlight2.Enabled = espFlag14 and not v6
					local v7 = tbl9[player]
					if v7 then v7.Enabled = false end
				end
			else
				if highlight2 then
					highlight2.Enabled = false
					highlight2.Adornee = nil
				end
				local v6 = tbl9[player]
				if v6 then v6.Enabled = false end
			end
		end
	end
	for k, v6 in pairs(tbl8) do
		if not k.Parent then
			v6:Destroy()
			tbl8[k] = nil
			fn41(k)
		end
	end
	if espFlag15 then
		local v6 = fn11()
		if v6 and v6:FindFirstChild("GunDrop") then
			local gunDrop = v6.GunDrop
			local v7 = fn42(gunDrop:IsA("BasePart") and gunDrop.Position or gunDrop:FindFirstChildWhichIsA("BasePart") and gunDrop:FindFirstChildWhichIsA("BasePart").Position or gunDrop:GetPivot().Position)
			highlight.Adornee = gunDrop
			local enabled = not v7
			highlight.Enabled = enabled
			if enabled then
				fn38(gunDrop).Enabled = true
			elseif billboardGui then
				billboardGui.Enabled = false
			end
			if not flag16 then flag16 = true end
		else
			highlight.Enabled = false
			highlight.Adornee = nil
			if billboardGui then
				billboardGui.Enabled = false
				billboardGui.Parent = nil
			end
			flag16 = false
		end
	else
		highlight.Enabled = false
		highlight.Adornee = nil
		if billboardGui then
			billboardGui.Enabled = false
			billboardGui.Parent = nil
		end
		flag16 = false
	end
end)

local v6Tab = v:Tab({ Title = "Highlight", Icon = "eye", Locked = false })

v6Tab:Toggle({
	Title = "Show Murderer",
	Flag = "ShowMurdererFlag",
	Value = false,
	Callback = function(arg) espFlag12 = arg end,
})

v6Tab:Toggle({
	Title = "Show Sheriff",
	Flag = "ShowSheriffFlag",
	Value = false,
	Callback = function(arg) espFlag13 = arg end,
})

v6Tab:Toggle({
	Title = "Show Innocent",
	Flag = "ShowInnocentFlag",
	Value = false,
	Callback = function(arg) espFlag14 = arg end,
})

v6Tab:Toggle({
	Title = "Show Dropped Gun",
	Flag = "ShowDroppedGunFlag",
	Value = false,
	Callback = function(arg)
		espFlag15 = arg
		if not arg then fn39() end
	end,
})

--========================================================================
-- FLING TAB
--========================================================================

local v7 = v:Tab({ Title = "Fling", Icon = "zap", Locked = false })

v7:Button({
	Title = "Fling Murderer",
	Callback = function()
		local v8 = fn6()
		if not v8 or v8 == localPlayer then
			lib:Notify({ Title = "Error", Content = "Murderer not found", Duration = 3, Icon = "lock" })
			return
		end
		task.spawn(function() pcall(function() SkidFling(v8) end) end)
	end,
})

v7:Button({
	Title = "Fling Sheriff",
	Callback = function()
		local v8 = fn7()
		if not v8 or v8 == localPlayer then
			lib:Notify({ Title = "Error", Content = "Sheriff not found", Duration = 3, Icon = "lock" })
			return
		end
		task.spawn(function() pcall(function() SkidFling(v8) end) end)
	end,
})

v7:Divider()

local flingTargetStr = ""

v7:Input({
	Title = "Target player name",
	Flag = "FlingTargetInput",
	Value = "",
	Placeholder = "e.g. +Notch, +Steve -Alex",
	Callback = function(arg) flingTargetStr = arg end,
})

v7:Button({
	Title = "Fling Target",
	Callback = function()
		if flingTargetStr == "" or flingTargetStr == nil then
			lib:Notify({ Title = "Error", Content = "Enter a player name first", Duration = 3, Icon = "lock" })
			return
		end
		local pname = getPlayer(flingTargetStr, localPlayer)
		local targetP = pname and Players:FindFirstChild(pname)
		if not targetP then
			lib:Notify({ Title = "Error", Content = "Player not found", Duration = 3, Icon = "lock" })
			return
		end
		if targetP == localPlayer then
			lib:Notify({ Title = "Error", Content = "Can't fling yourself!", Duration = 3, Icon = "lock" })
			return
		end
		task.spawn(function() pcall(function() SkidFling(targetP) end) end)
	end,
})

v7:Button({
	Title = "Fling Murderer (Floating)",
	Callback = function()
		createFloatingButton("Fling Murderer", function()
			local v8 = fn6()
			if v8 and v8 ~= localPlayer then
				task.spawn(function() pcall(function() SkidFling(v8) end) end)
			end
		end, Color3.fromRGB(150, 0, 0))
	end,
})

v7:Button({
	Title = "Fling Sheriff (Floating)",
	Callback = function()
		createFloatingButton("Fling Sheriff", function()
			local v8 = fn7()
			if v8 and v8 ~= localPlayer then
				task.spawn(function() pcall(function() SkidFling(v8) end) end)
			end
		end, Color3.fromRGB(0, 0, 150))
	end,
})

v7:Divider()

local str2 = ""

local v8Drop = v7:Dropdown({
	Title = "Select Player (all)",
	Flag = "FlingPlayerDropdown",
	Values = tbl6,
	Value = "",
	Callback = function(arg) str2 = arg end,
})

table.insert(tbl7, v8Drop)

v7:Button({
	Title = "Fling Selected Player",
	Callback = function()
		if str2 == "" or str2 == nil then
			lib:Notify({ Title = "Error", Content = "Select a player first", Duration = 3, Icon = "lock" })
			return
		end
		local v9 = game.Players:FindFirstChild(str2)
		if not v9 then
			lib:Notify({ Title = "Error", Content = "Player not found", Duration = 3, Icon = "lock" })
			return
		end
		task.spawn(function() pcall(function() SkidFling(v9) end) end)
	end,
})

v7:Button({
	Title = "Fling All",
	Callback = function()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")
		if character then cFrame = character.CFrame end
		fn31()
		task.spawn(function()
			for _, player in ipairs(game.Players:GetPlayers()) do
				if not flag3 then
					if player ~= localPlayer then
						pcall(function() SkidFling(player) end)
					end
					continue
				end
				break
			end
			fn32()
		end)
	end,
})

--========================================================================
-- UNIVERSAL TAB
--========================================================================

local vUniversal = v:Tab({ Title = "Universal", Icon = "globe", Locked = false })

vUniversal:Toggle({
	Title = "OP Fly",
	Flag = "OPFlyFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			if localPlayer.Character then FlyUtility:Start() end
		else
			FlyUtility:Stop()
		end
	end,
})

vUniversal:Slider({
	Title = "Fly Speed",
	Flag = "FlySpeedFlag",
	Step = 1,
	Value = { Min = 10, Max = 500, Default = 50 },
	Callback = function(arg) FlyUtility:SetMaxSpeed(arg) end,
})

vUniversal:Divider()

local function setupHumanoid(humanoid)
	if landedConnection then landedConnection:Disconnect() end
	landedConnection = humanoid.StateChanged:Connect(function(_, n)
		if n == Enum.HumanoidStateType.Landed or n == Enum.HumanoidStateType.Running then
			landed = true
			infJumps = 0
		end
	end)
end

local infJump = false
local infJumpConnection = nil
local landedConnection = nil
local infJumps = 0
local infJumpDeb = false
local infJumpOnlyTwo = false
local landed = true
local aggressiveExp = false
local hitboxExp = 1
local loopHitBoxExp
local antiFlingImproved = false
local antiFlingLastPos = Vector3.zero
local flingNeutralizerCon
local flingDetectionCon
local detectedPlayers = {}
local clip = true
local nocliploop
local aimlockrscon
local aimlockTarget
local aimlock = false
local spectateLoop = nil

vUniversal:Toggle({
	Title = "Infinite Jump",
	Flag = "InfJumpFlag",
	Value = false,
	Callback = function(state)
		infJump = state
		if state then
			local char = localPlayer.Character
			if char and char:FindFirstChildWhichIsA("Humanoid") then
				setupHumanoid(char:FindFirstChildWhichIsA("Humanoid"))
			end
			infJumpConnection = UserInputService.JumpRequest:Connect(function()
				local character = localPlayer.Character
				local humanoid = character and character:FindFirstChildWhichIsA("Humanoid")
				if not humanoid then return end
				if infJumpOnlyTwo and infJumps >= 2 and not landed then return end
				if not infJumpDeb then
					infJumpDeb = true
					humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
					infJumps += 1
					landed = false
					task.wait(.1)
					infJumpDeb = false
				end
			end)
		else
			if infJumpConnection then infJumpConnection:Disconnect() infJumpConnection = nil end
			if landedConnection then landedConnection:Disconnect() landedConnection = nil end
			infJumps = 0
			landed = true
		end
	end,
})

vUniversal:Toggle({
	Title = "Limit infinite jump to 2 jumps only",
	Flag = "InfJumpLimitFlag",
	Value = false,
	Callback = function(state)
		infJumpOnlyTwo = state
		infJumps = 0
	end,
})

vUniversal:Divider()

vUniversal:Input({
	Title = "Hitbox expander size",
	Flag = "HitboxSizeInput",
	Value = "1",
	Placeholder = "e.g. 5",
	Callback = function(text)
		hitboxExp = text
		local sizeArg = tonumber(text)
		if not sizeArg then return end
		local Size = Vector3.new(sizeArg, sizeArg, sizeArg)
		for _, v in ipairs(Players:GetPlayers()) do
			if v ~= localPlayer and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
				if aggressiveExp then
					for _, part in ipairs(v.Character:GetChildren()) do
						if part:IsA("BasePart") then
							if sizeArg == 1 then
								part.Size = Vector3.new(2, 1, 1)
							else
								part.Size = Size
							end
							part.Transparency = 0.2
						end
					end
				else
					local Root = v.Character:FindFirstChild('HumanoidRootPart')
					if Root then
						if sizeArg == 1 then
							Root.Size = Vector3.new(2, 1, 1)
						else
							Root.Size = Size
						end
						Root.Transparency = 0.2
						Root.CanCollide = false
					end
				end
			end
		end
		lib:Notify({ Title = "Info", Content = "Hitboxes expanded.", Duration = 3, Icon = "info" })
	end,
})

vUniversal:Toggle({
	Title = "Loop hitbox expansion",
	Flag = "LoopHitboxFlag",
	Value = false,
	Callback = function(state)
		if state then
			loopHitBoxExp = RunService.Heartbeat:Connect(function()
				local sizeArg = tonumber(hitboxExp)
				if not sizeArg then return end
				local Size = Vector3.new(sizeArg, sizeArg, sizeArg)
				for _, v in ipairs(Players:GetPlayers()) do
					if v ~= localPlayer and v.Character and v.Character:FindFirstChild('HumanoidRootPart') then
						if aggressiveExp then
							for _, part in ipairs(v.Character:GetChildren()) do
								if part:IsA("BasePart") then
									if sizeArg == 1 then
										part.Size = Vector3.new(2, 1, 1)
									else
										part.Size = Size
									end
									part.Transparency = 0.2
								end
							end
						else
							local Root = v.Character:FindFirstChild('HumanoidRootPart')
							if Root then
								if sizeArg == 1 then
									Root.Size = Vector3.new(2, 1, 1)
								else
									Root.Size = Size
								end
								Root.Transparency = 0.2
								Root.CanCollide = false
							end
						end
					end
				end
			end)
		else
			if loopHitBoxExp then loopHitBoxExp:Disconnect() loopHitBoxExp = nil end
		end
	end,
})

vUniversal:Toggle({
	Title = "Aggressive hitbox expansion (all parts)",
	Flag = "AggressiveHitboxFlag",
	Value = false,
	Callback = function(state) aggressiveExp = state end,
})

vUniversal:Divider()

local ws = 16
local fov = 70
local walkspeedInDeCrement = 2
local loopfovandws = false

vUniversal:Input({
	Title = "Walkspeed",
	Flag = "WSInput",
	Value = "16",
	Placeholder = "e.g. 100",
	Callback = function(text)
		local char = localPlayer.Character
		if not char then
			lib:Notify({ Title = "Error", Content = "No character!", Duration = 3, Icon = "lock" })
			return
		end
		local hu = char:FindFirstChildOfClass("Humanoid")
		if not hu then return end
		hu.WalkSpeed = tonumber(text) or 16
		ws = tonumber(text) or 16
	end,
})

vUniversal:Button({
	Title = "Increase walkspeed",
	Callback = function()
		local char = localPlayer.Character
		if not char then return end
		local hu = char:FindFirstChildOfClass("Humanoid")
		if not hu then return end
		ws = ws + walkspeedInDeCrement
		hu.WalkSpeed = hu.WalkSpeed + walkspeedInDeCrement
	end,
})

vUniversal:Button({
	Title = "Decrease walkspeed",
	Callback = function()
		local char = localPlayer.Character
		if not char then return end
		local hu = char:FindFirstChildOfClass("Humanoid")
		if not hu then return end
		ws = ws - walkspeedInDeCrement
		hu.WalkSpeed = hu.WalkSpeed - walkspeedInDeCrement
	end,
})

vUniversal:Input({
	Title = "Walkspeed increment",
	Flag = "WSIncInput",
	Value = "2",
	Placeholder = "e.g. 5",
	Callback = function(text)
		walkspeedInDeCrement = tonumber(text) or 2
	end,
})

vUniversal:Input({
	Title = "FOV change",
	Flag = "FOVInput",
	Value = "70",
	Placeholder = "e.g. 120",
	Callback = function(text)
		local tofov = tonumber(text) or 70
		game:GetService("TweenService"):Create(workspace.CurrentCamera, TweenInfo.new(1, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), {
			FieldOfView = tofov
		}):Play()
		fov = tofov
	end,
})

vUniversal:Toggle({
	Title = "Loop walkspeed and FOV",
	Flag = "LoopWSFOVFlag",
	Value = false,
	Callback = function(state) loopfovandws = state end,
})

RunService.RenderStepped:Connect(function()
	if loopfovandws then
		workspace.CurrentCamera.FieldOfView = fov
		if localPlayer.Character then
			local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then hum.WalkSpeed = ws end
		end
	end
end)

vUniversal:Divider()

local ctrlclicktp = false

vUniversal:Toggle({
	Title = "CTRL + Click Teleport",
	Flag = "CtrlClickTPFlag",
	Value = false,
	Callback = function(state) ctrlclicktp = state end,
})

UserInputService.InputBegan:Connect(function(inp, proc)
	if proc then return end
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and inp.UserInputType == Enum.UserInputType.MouseButton1 and ctrlclicktp then
		local mouse = localPlayer:GetMouse()
		if not mouse then return end
		local camera = workspace.CurrentCamera
		local unitRay = camera:ScreenPointToRay(mouse.X, mouse.Y)
		local ray = Ray.new(unitRay.Origin, unitRay.Direction * 1000)
		local part, position = workspace:FindPartOnRay(ray, localPlayer.Character)
		if part then
			local hrp = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
			if hrp then hrp.CFrame = CFrame.new(position) end
		end
	end
end)

vUniversal:Input({
	Title = "Teleport to player name",
	Flag = "TPPlayerInput",
	Value = "",
	Placeholder = "Player name",
	Callback = function(text)
		local pname = getPlayer(text, localPlayer)
		local targetPlayer = Players:FindFirstChild(pname)
		if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
			local pc = localPlayer.Character
			if pc and pc:FindFirstChild("HumanoidRootPart") then
				pc.HumanoidRootPart.CFrame = CFrame.new(targetPlayer.Character.HumanoidRootPart.Position + Vector3.new(0, 5, 0))
			end
		end
	end,
})

vUniversal:Button({
	Title = "Spectate Players",
	Callback = function()
		local listofplayers = Players:GetPlayers()
		local currentPlayer = listofplayers[1]
		if not currentPlayer or not currentPlayer.Character then return end
		workspace.CurrentCamera.CameraSubject = currentPlayer.Character:FindFirstChildOfClass("Humanoid")
	end,
})

vUniversal:Button({
	Title = "Stop Spectating",
	Callback = function()
		if localPlayer.Character then
			local hum = localPlayer.Character:FindFirstChildOfClass("Humanoid")
			if hum then workspace.CurrentCamera.CameraSubject = hum end
		end
	end,
})

vUniversal:Divider()

vUniversal:Input({
	Title = "Aim lock target",
	Flag = "AimlockTargetInput",
	Value = "",
	Placeholder = "Player name",
	Callback = function(text)
		local pname = getPlayer(text, localPlayer)
		local targetP = pname and Players:FindFirstChild(pname)
		if not targetP then
			lib:Notify({ Title = "Error", Content = "Player not found.", Duration = 3, Icon = "lock" })
			return
		end
		aimlockTarget = targetP
		lib:Notify({ Title = "Info", Content = "Target set to " .. targetP.Name, Duration = 3, Icon = "info" })
	end,
})

vUniversal:Button({
	Title = "Aim Lock",
	Callback = function()
		if aimlock then return end
		if aimlockrscon then aimlockrscon:Disconnect() end
		if not aimlockTarget then
			lib:Notify({ Title = "Error", Content = "Set a target first.", Duration = 3, Icon = "lock" })
			return
		end
		local cam = workspace.CurrentCamera
		aimlockrscon = RunService.RenderStepped:Connect(function()
			if not aimlockTarget then return end
			if not aimlockTarget.Character then return end
			local hrp = aimlockTarget.Character:FindFirstChild("HumanoidRootPart")
			if not hrp then return end
			cam.CFrame = CFrame.new(cam.CFrame.Position, hrp.Position)
		end)
		aimlock = true
	end,
})

vUniversal:Button({
	Title = "Unaim Lock",
	Callback = function()
		if not aimlock then return end
		aimlock = false
		if aimlockrscon then aimlockrscon:Disconnect() aimlockrscon = nil end
	end,
})

vUniversal:Divider()

vUniversal:Toggle({
	Title = "Anti-Fling (improved)",
	Flag = "AntiFlingImprovedFlag",
	Value = false,
	Callback = function(state)
		antiFlingImproved = state
		if state then
			flingDetectionCon = RunService.Heartbeat:Connect(function()
				for _, pl in ipairs(Players:GetPlayers()) do
					if pl.Character and pl.Character:IsDescendantOf(workspace) and pl.Character.PrimaryPart then
						if pl.Character.PrimaryPart.AssemblyAngularVelocity.Magnitude > 50 or pl.Character.PrimaryPart.AssemblyLinearVelocity.Magnitude > 100 then
							for _, p in ipairs(pl.Character:GetDescendants()) do
								if p:IsA("BasePart") then
									p.CanCollide = false
									p.AssemblyAngularVelocity = Vector3.zero
									p.AssemblyLinearVelocity = Vector3.zero
									p.CustomPhysicalProperties = PhysicalProperties.new(0, 0, 0)
								end
							end
						end
					end
				end
			end)
			flingNeutralizerCon = RunService.Heartbeat:Connect(function()
				local char = localPlayer.Character
				if char and char.PrimaryPart then
					if char.PrimaryPart.AssemblyLinearVelocity.Magnitude > 250 or char.PrimaryPart.AssemblyAngularVelocity.Magnitude > 250 then
						char.PrimaryPart.AssemblyLinearVelocity = Vector3.zero
						char.PrimaryPart.AssemblyAngularVelocity = Vector3.zero
						if antiFlingLastPos ~= Vector3.zero then
							char.PrimaryPart.CFrame = CFrame.new(antiFlingLastPos)
						end
					else
						antiFlingLastPos = char.PrimaryPart.Position
					end
				end
			end)
		else
			if flingDetectionCon then flingDetectionCon:Disconnect() flingDetectionCon = nil end
			if flingNeutralizerCon then flingNeutralizerCon:Disconnect() flingNeutralizerCon = nil end
		end
	end,
})

vUniversal:Divider()

vUniversal:Button({
	Title = "Noclip",
	Callback = function()
		clip = false
		nocliploop = RunService.Stepped:Connect(function()
			if clip == false and localPlayer.Character ~= nil then
				for _, child in pairs(localPlayer.Character:GetDescendants()) do
					if child:IsA("BasePart") and child.CanCollide == true then
						child.CanCollide = false
					end
				end
			end
		end)
	end,
})

vUniversal:Button({
	Title = "Reclip",
	Callback = function()
		if clip then return end
		clip = true
		if nocliploop then nocliploop:Disconnect() nocliploop = nil end
	end,
})

vUniversal:Divider()

vUniversal:Button({
	Title = "Anti-AFK",
	Callback = function()
		local pl = localPlayer
		if getconnections then
			for _, c in pairs(getconnections(pl.Idled)) do
				if c["Disable"] then c["Disable"](c)
				elseif c["Disconnect"] then c["Disconnect"](c) end
			end
		else
			pl.Idled:Connect(function()
				game:GetService("VirtualUser"):CaptureController()
				game:GetService("VirtualUser"):ClickButton2(Vector2.new())
			end)
		end
	end,
})

vUniversal:Button({
	Title = "Get Ping",
	Callback = function()
		local ping = localPlayer:GetNetworkPing() * 1000
		lib:Notify({ Title = "Ping", Content = tostring(math.floor(ping)) .. " ms", Duration = 3, Icon = "info" })
	end,
})

vUniversal:Button({
	Title = "Open Developer Console",
	Callback = function()
		game.StarterGui:SetCore("DevConsoleVisible", true)
	end,
})

--========================================================================
-- UTILITIES TAB
--========================================================================

local v9Tab = v:Tab({ Title = "Utilities", Icon = "wrench", Locked = false })

v9Tab:Toggle({
	Title = "Teleport Tool",
	Flag = "tptoolflag",
	Value = false,
	Callback = function(arg)
		if arg then
			local tool = Instance.new("Tool")
			tool.RequiresHandle = false
			tool.Name = "Teleport Tool"
			tool.Activated:Connect(function()
				local p = localPlayer:GetMouse().Hit.p
				if localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
					localPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(p + Vector3.new(0, 3, 0))
				end
			end)
			tool.Parent = localPlayer.Backpack
		else
			if localPlayer.Backpack:FindFirstChild("Teleport Tool") then
				localPlayer.Backpack:FindFirstChild("Teleport Tool"):Destroy()
			end
		end
	end,
})

v9Tab:Toggle({
	Title = "Noclip Tool",
	Flag = "noclipflag",
	Value = false,
	Callback = function(arg)
		if arg then
			local tool = Instance.new("Tool")
			tool.RequiresHandle = false
			tool.Name = "Noclip Tool"
			tool.Equipped:Connect(function()
				connection3 = RunService.Stepped:Connect(function()
					if localPlayer.Character then
						for _, descendant in pairs(localPlayer.Character:GetDescendants()) do
							if descendant:IsA("BasePart") then
								descendant.CanCollide = false
							end
						end
					end
				end)
			end)
			tool.Unequipped:Connect(function()
				if connection3 then connection3:Disconnect() connection3 = nil end
			end)
			tool.Parent = localPlayer.Backpack
		else
			if connection3 then connection3:Disconnect() connection3 = nil end
			if localPlayer.Backpack:FindFirstChild("Noclip Tool") then
				localPlayer.Backpack:FindFirstChild("Noclip Tool"):Destroy()
			end
		end
	end,
})

v9Tab:Toggle({
	Title = "Infinite Jump (basic)",
	Flag = "infjumpflag",
	Value = false,
	Callback = function(arg) flag8 = arg end,
})

v9Tab:Divider()

v9Tab:Button({
	Title = "FPS Boost",
	Callback = function()
		local Lighting = game:GetService("Lighting")
		Lighting.GlobalShadows = false
		Lighting.FogEnd = 9e9
		Lighting.Brightness = 1
		for _, child in ipairs(Lighting:GetChildren()) do
			if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
				child:Destroy()
			end
		end
		pcall(function() settings().Rendering.QualityLevel = 1 end)
	end,
})

v9Tab:Button({
	Title = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end,
})

--========================================================================
-- SETTINGS TAB
--========================================================================

local v10 = v:Tab({ Title = "Settings", Icon = "settings", Locked = false })

local allThemes = {
	"White-Black", "Cyberpunk", "Dracula", "Tokyo Night", "Vaporwave",
	"Onyx Gold", "Blood Moon", "Furina Genshin", "Closing Eyes",
}

v10:Dropdown({
	Title = "Select Theme",
	Flag = "ThemeSelectFlag",
	Values = allThemes,
	Value = "White-Black",
	Callback = function(themeName)
		if themeName and themeName ~= "" then
			pcall(function()
				lib:SetTheme(themeName)
				lib:Notify({ Title = "Theme", Content = "Applied: " .. themeName, Duration = 3, Icon = "palette" })
			end)
		end
	end,
})

v10:Divider()

v10:Button({
	Title = "Save Config",
	Callback = function()
		v:Dialog({
			Title = "Save Config",
			Content = "Do you want to save the config?",
			Buttons = {
				{ Title = "Cancel", Callback = function() end, Variant = "Secondary" },
				{ Title = "Save", Callback = function()
					fn()
					lib:Notify({ Title = "Info", Content = "Config Saved", Duration = 3, Icon = "save" })
				end, Variant = "Primary" },
			},
		})
	end,
})

v10:Button({
	Title = "Load Config",
	Callback = function()
		v:Dialog({
			Title = "Load Config",
			Content = "Do you want to load the config?",
			Buttons = {
				{ Title = "Cancel", Callback = function() end, Variant = "Secondary" },
				{ Title = "Load", Callback = function()
					fn2()
					lib:Notify({ Title = "Info", Content = "Config Loaded", Duration = 3, Icon = "save" })
				end, Variant = "Primary" },
			},
		})
	end,
})

v10:Divider()

--========================================================================
-- CUSTOM RGB CURSOR
--========================================================================

local cursorState = {
	enabled = true,
	textEnabled = true,
	rgbEnabled = true,
	screenGui = nil,
	connection = nil,
}

local function updateCursor()
	task.spawn(function()
		if cursorState.enabled then
			if not cursorState.screenGui then
				local sg = Instance.new("ScreenGui")
				sg.Name = "YunoCustomCursor"
				sg.DisplayOrder = 99999
				sg.IgnoreGuiInset = true
				sg.ResetOnSpawn = false

				local img = Instance.new("ImageLabel")
				img.Name = "CursorImage"
				img.BackgroundTransparency = 1
				img.Image = "rbxassetid://10769687353"
				img.Size = UDim2.new(0, 32, 0, 32)
				img.AnchorPoint = Vector2.new(0.5, 0.5)
				img.Parent = sg

				local txt = Instance.new("TextLabel")
				txt.Name = "CursorText"
				txt.BackgroundTransparency = 1
				txt.Text = "Yuno Hub"
				txt.TextColor3 = Color3.fromRGB(255, 255, 255)
				txt.TextStrokeTransparency = 0
				txt.Font = Enum.Font.GothamBold
				txt.TextSize = 14
				txt.Size = UDim2.new(0, 100, 0, 20)
				txt.AnchorPoint = Vector2.new(0.5, 0)
				txt.Visible = cursorState.textEnabled
				txt.Parent = sg

				local ok, parent = pcall(function() return gethui and gethui() end)
				if ok and parent then
					sg.Parent = parent
				else
					local CoreGui = game:GetService("CoreGui")
					local pcOk, pc = pcall(function() return CoreGui end)
					if pcOk and pc then
						sg.Parent = pc
					else
						local pGui = localPlayer:FindFirstChild("PlayerGui")
						if pGui then sg.Parent = pGui
						else sg.Parent = localPlayer:WaitForChild("PlayerGui", 10) end
					end
				end
				cursorState.screenGui = sg
			end

			if not cursorState.connection then
				UserInputService.MouseIconEnabled = false
				cursorState.connection = RunService.RenderStepped:Connect(function()
					pcall(function()
						UserInputService.MouseIconEnabled = false
						if cursorState.screenGui then
							local mouseLocation = UserInputService:GetMouseLocation()
							local img = cursorState.screenGui:FindFirstChild("CursorImage")
							if img then
								img.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y)
								img.Rotation = img.Rotation + 2.5
								if cursorState.rgbEnabled then
									img.ImageColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
								else
									img.ImageColor3 = Color3.new(1, 1, 1)
								end
							end
							local txt = cursorState.screenGui:FindFirstChild("CursorText")
							if txt then
								txt.Position = UDim2.new(0, mouseLocation.X, 0, mouseLocation.Y + 20)
								if cursorState.rgbEnabled then
									txt.TextColor3 = Color3.fromHSV(tick() % 5 / 5, 1, 1)
								else
									txt.TextColor3 = Color3.new(1, 1, 1)
								end
							end
						end
					end)
				end)
			end
		else
			pcall(function() UserInputService.MouseIconEnabled = true end)
			if cursorState.connection then
				cursorState.connection:Disconnect()
				cursorState.connection = nil
			end
			if cursorState.screenGui then
				cursorState.screenGui:Destroy()
				cursorState.screenGui = nil
			end
		end
	end)
end

v10:Toggle({
	Title = "Enable Custom Cursor",
	Flag = "CustomCursorFlag",
	Value = true,
	Callback = function(arg)
		cursorState.enabled = arg
		updateCursor()
	end,
})

v10:Toggle({
	Title = "Disable RGB Effect on Cursor",
	Flag = "CustomCursorRGBFlag",
	Value = false,
	Callback = function(arg)
		cursorState.rgbEnabled = not arg
		updateCursor()
	end,
})

v10:Toggle({
	Title = "Show Text Under Cursor",
	Flag = "CustomCursorTextFlag",
	Value = true,
	Callback = function(arg)
		cursorState.textEnabled = arg
		updateCursor()
	end,
})

updateCursor()

--========================================================================
-- UNKNOWN TAB
--========================================================================

v:Tab({ Title = "Unknown", Icon = "info", Locked = false, Hidden = true }):Paragraph({
	Title = "Yuno Studios",
	Desc = "Join our Discord server for updates and more!",
	Thumbnail = "rbxassetid://140031939906800",
	ThumbnailSize = 140,
	Buttons = {
		{
			Title = "Copy Link",
			Callback = function()
				setclipboard("https://discord.gg/eNt4edXCKS")
				lib:Notify({ Title = "Info", Content = "Discord link copied", Duration = 3, Icon = "info" })
			end,
		},
	},
})

v.Minimized:Connect(function()
end)

print("Yuno Hub v1.23 loaded - Main + MM2 + Floating Buttons + Themes + RGB Cursor")