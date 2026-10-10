
-- Detected obfuscation: Luraph v15
-- Local names are inferred from use (the original names are not in the bytecode)

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/platinww/UwU/refs/heads/main/UI/Wind.lua"))()
lib:SetNotificationLower(true)

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

lib:SetTheme("White-Black")

local v = lib:CreateWindow({
	Title = "UwU",
	Icon = "terminal",
	Author = "MM2 / MMV",
	Folder = "UwUConfig",
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
	Title = "UwU",
	Icon = "terminal",
	CornerRadius = UDim.new(0, 16),
	StrokeThickness = 2,
	Color = ColorSequence.new(Color3.fromHex("ffffff"), color("ffffff")),
	OnlyMobile = false,
	Enabled = true,
	Draggable = true,
})

local UwUHubMM2 = v.ConfigManager:CreateConfig("UwUHubMM2")
local HttpService = game:GetService("HttpService")
local tbl = {}
local tbl2 = {}

local function fn()
	if writefile then
		pcall(function()
			writefile("UwUHub_ButtonPositions.json", HttpService:JSONEncode(tbl))
		end)

		pcall(function()
			writefile("UwUHub_Keybinds.json", HttpService:JSONEncode(tbl2))
		end)

		pcall(function()
			UwUHubMM2:Save()
		end)
	end
end

local function fn2()
	if readfile and isfile then
		if isfile("UwUHub_ButtonPositions.json") then
			pcall(function()
				tbl = HttpService:JSONDecode(readfile("UwUHub_ButtonPositions.json"))
			end)
		end

		if isfile("UwUHub_Keybinds.json") then
			pcall(function()
				tbl2 = HttpService:JSONDecode(readfile("UwUHub_Keybinds.json"))
			end)
		end

		pcall(function()
			UwUHubMM2:Load()
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
	if gameProcessed then
		return
	end

	if flag then
		return
	end

	if input.UserInputType ~= Enum.UserInputType.Keyboard then
		return
	end
	local name = input.KeyCode.Name

	for k, v2 in pairs(tbl3) do
		if v2.active and tbl2[k] == name then
			pcall(v2.action)
		end
	end
end)

task.spawn(function()
	pcall(function()
		if game.PlaceId ~= 142823291 then
			return
		end
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
					Title = "UwU Hub",
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

local function fn3()
	local character = localPlayer.Character
	if not character then
		return true
	end
	local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	if not humanoidRootPart then
		return true
	end
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
	if flag10 then
		return
	end
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
	if not CurrentRoundClient then
		return
	end
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
		if not gameplay then
			return
		end
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

	if flag5 then
		flag11 = v2
	end

	if flag11 then
		return v2
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Knife") then
			return player
		end
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		if not player.Character then
			continue
		end

		if player.Character:FindFirstChild("Knife") then
			return player
		end
	end

	return nil
end

local function fn7()
	local flag11 = false

	if flag5 then
		flag11 = v3
	end

	if flag11 then
		return v3
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Gun") then
			return player
		end
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		if not player.Character then
			continue
		end

		if player.Character:FindFirstChild("Gun") then
			return player
		end
	end

	return nil
end

local function fn8()
	local flag11 = false

	if flag5 then
		flag11 = v3
	end

	if flag11 and v3 ~= localPlayer then
		return v3
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end
		local backpack = player:FindFirstChild("Backpack")
		if backpack and backpack:FindFirstChild("Gun") then
			return player
		end
	end

	for _, player in ipairs(game.Players:GetPlayers()) do
		if player == localPlayer then
			continue
		end

		if not player.Character then
			continue
		end

		if player.Character:FindFirstChild("Gun") then
			return player
		end
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

local function fn12(arg, arg2)
	pcall(function()
		arg = arg.Character
	end)

	if not arg then
		return Vector3.zero
	end
	local upperTorso = arg:FindFirstChild("UpperTorso") or arg:FindFirstChild("HumanoidRootPart")
	local humanoid = arg:FindFirstChild("Humanoid")
	if not upperTorso or not humanoid then
		return Vector3.zero
	end
	return upperTorso.Position + upperTorso.AssemblyLinearVelocity * Vector3.new(0.75, 0.5, 0.75) * arg2 / 15 + humanoid.MoveDirection * arg2
end

local function fn13(arg)
	pcall(function()
		arg = arg.Character
	end)

	if not arg then
		return Vector3.zero
	end
	local humanoidRootPart = arg:FindFirstChild("HumanoidRootPart")
	local humanoid = arg:FindFirstChild("Humanoid")
	if not humanoidRootPart or not humanoid then
		return Vector3.zero
	end
	local position = humanoidRootPart.Position
	local assemblyLinearVelocity = humanoidRootPart.AssemblyLinearVelocity
	local moveDirection = humanoid.MoveDirection
	local lookVector = humanoidRootPart.CFrame.LookVector
	local magnitude = Vector3.new(assemblyLinearVelocity.X, 0, assemblyLinearVelocity.Z).Magnitude
	local y = assemblyLinearVelocity.Y
	local flag11 = magnitude > 1 or moveDirection.Magnitude > 0.1
	local flag12 = y > 2
	local flag13 = y < -2
	if flag12 then
		return position + Vector3.new(0, 3, 0) + lookVector * (magnitude > 1 and 2 or 0)
	end

	if flag13 then
		return position + Vector3.new(0, -4, 0) + lookVector * (magnitude > 1 and 2 or 0)
	end

	if flag11 then
		return position + (moveDirection.Magnitude > 0.1 and moveDirection.Unit or lookVector) * 3
	end
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

	if not v5.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
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

	if flag6 then
		flag11 = humanoid
	end

	if flag11 then
		humanoid:UnequipTools()
	end
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
	if not v5 or not v5.Character then
		return
	end

	if not v5.Character:FindFirstChild("HumanoidRootPart") then
		return
	end
	local cframe = CFrame.new
	local n6 = n + 1
	local tbl8 = { CFrame.new(localPlayer.Character.RightHand.Position), cframe(fn12(v5, n6)) }
	localPlayer.Character:WaitForChild("Knife"):WaitForChild("Events"):WaitForChild("KnifeThrown"):FireServer(unpack(tbl8))
end

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
	if not character then
		return
	end
	local pivot = character:GetPivot()
	character:PivotTo(v5:FindFirstChild("GunDrop"):GetPivot())
	localPlayer.Backpack.ChildAdded:Wait()
	character:PivotTo(pivot)
	lib:Notify({ Title = "Info", Content = "Dropped gun has been get", Duration = 3, Icon = "info" })
end

workspace.DescendantAdded:Connect(function(descendant)
	if descendant.Name == "GunDrop" then
		if flag2 then
			if fn10() then
				return
			end

			if fn3() then
				return
			end

			task.spawn(function()
				local v5 = fn11()
				if not v5 or not v5:FindFirstChild("GunDrop") then
					return
				end
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
	if gameProcessed then
		return
	end

	if flag7 and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		if localPlayer.Character and localPlayer.Character:FindFirstChild("Gun") then
			local v5 = fn6() or fn8()
			if not v5 then
				return
			end

			if not (v5.Character and v5.Character:FindFirstChild("HumanoidRootPart")) then
				return
			end
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
	if not humanoid then
		return
	end

	if connection2 then
		connection2:Disconnect()
	end

	n3 = -1
	n4 = -1

	connection2 = RunService.Heartbeat:Connect(function()
		if not humanoid or not humanoid.Parent then
			return
		end
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

	if connection2 then
		connection2:Disconnect()
		connection2 = nil
	end

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

local UserInputService = game:GetService("UserInputService")
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
		if flag11 then
			return
		end

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

	arg.MouseButton1Click:Connect(function()
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == v5 and flag12 then
			local n7 = input.Position - position
			vector2 = Vector2.new(math.abs(n7.X) + math.abs(n7.Y), 0)

			if n6 <= vector2.X then
				flag13 = true
			end

			if flag13 then
				arg2.Position = UDim2.new(position2.X.Scale, position2.X.Offset + n7.X, position2.Y.Scale, position2.Y.Offset + n7.Y)
			end
		end
	end)

	return { getWasDragged = function()
		return flag13
	end }
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

		lib:Notify({
			Title = "Info",
			Content = "Keybind Set / " .. v5 .. " / " .. arg2,
			Duration = 3,
			Icon = "info",
		})
	end
end

local function createScreenGui(name, text, arg, arg2, arg3)
	local screenGui2 = Instance.new("ScreenGui")
	screenGui2.Name = name
	screenGui2.ResetOnSpawn = false
	screenGui2.Parent = game.CoreGui
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
		local v6
		TweenService:Create(uiStroke, tweenInfo, { Color = v6 }):Play()
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
		if not flag12 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
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
		if v5.getWasDragged() then
			return
		end
		arg3()
	end)

	return screenGui2
end

local ShootMurdererGui = nil

local function fn20()
	if ShootMurdererGui then
		return
	end

	ShootMurdererGui = createScreenGui("ShootMurdererGui", "Shoot Murderer", "ShootMurderer", -22, function()
		shootMurdererAction()
	end)
end

local function fn21()
	if ShootMurdererGui then
		ShootMurdererGui:Destroy()
		ShootMurdererGui = nil
	end

	if tbl3.ShootMurderer then
		tbl3.ShootMurderer.active = false
	end
end

local ThrowKnifeGui = nil

local function fn22()
	if ThrowKnifeGui then
		return
	end

	ThrowKnifeGui = createScreenGui("ThrowKnifeGui", "Throw Knife", "ThrowKnife", -80, function()
		knifeThrowFunc(false)
	end)
end

local function fn23()
	if ThrowKnifeGui then
		ThrowKnifeGui:Destroy()
		ThrowKnifeGui = nil
	end

	if tbl3.ThrowKnife then
		tbl3.ThrowKnife.active = false
	end
end

local GetDroppedGunGui = nil

local function fn24()
	if GetDroppedGunGui then
		return
	end

	GetDroppedGunGui = createScreenGui("GetDroppedGunGui", "Get Dropped Gun", "GetDroppedGun", 30, function()
		fn14()
	end)
end

local function fn25()
	if GetDroppedGunGui then
		GetDroppedGunGui:Destroy()
		GetDroppedGunGui = nil
	end

	if tbl3.GetDroppedGun then
		tbl3.GetDroppedGun.active = false
	end
end

local screenGui2 = nil
local textButton = nil
local textLabel = nil
local frame = nil

local function fn26(arg)
	if not textLabel then
		return
	end
	textLabel.TextColor3 = arg and Color3.fromRGB(0, 210, 70) or Color3.fromRGB(210, 0, 0)
end

local function fn27()
	if screenGui2 then
		return
	end
	screenGui2 = Instance.new("ScreenGui")
	screenGui2.Name = "SpeedGui"
	screenGui2.ResetOnSpawn = false
	screenGui2.Parent = game.CoreGui
	frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 160, 0, 45)
	frame.Position = UDim2.new(0.5, -80, 0.5, 88)
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
	textButton = Instance.new("TextButton")
	textButton.Size = UDim2.new(1, 0, 1, 0)
	textButton.BackgroundTransparency = 1
	textButton.Text = "         Speed Glitch"
	textButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton.Font = Enum.Font.GothamBold
	textButton.TextSize = 15
	textButton.TextXAlignment = Enum.TextXAlignment.Left
	textButton.Parent = frame
	textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(0, 20, 1, 0)
	textLabel.Position = UDim2.new(1, -45, 0, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = "●"
	textLabel.TextColor3 = Color3.fromRGB(210, 0, 0)
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextSize = 20
	textLabel.ZIndex = 2
	textLabel.Parent = frame
	local speedGlitch = fn18(textButton, frame, "SpeedGlitch")

	tbl3.SpeedGlitch = {
		active = true,
		action = function()
			flag4 = not flag4

			if flag4 then
				if localPlayer.Character then
					fn15(localPlayer.Character)
				end
			else
				fn16()
			end

			fn26(flag4)
		end,
	}

	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local color2 = Color3.fromRGB(50, 230, 110)
	local color3 = Color3.fromRGB(255, 255, 255)

	local function fn28(arg)
		TweenService:Create(textButton, tweenInfo, { TextColor3 = arg and color2 or color3 }):Play()
		local v5
		TweenService:Create(uiStroke, tweenInfo, { Color = v5 }):Play()
	end

	local flag12 = false

	textButton.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			flag12 = true
			fn28(true)
		end
	end)

	textButton.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if flag12 then
				if tbl2.SpeedGlitch then
					tbl2.SpeedGlitch = nil

					lib:Notify({
						Title = "Info",
						Content = "Keybind Removed / Speed Glitch",
						Duration = 3,
						Icon = "info",
					})
				end
			end

			flag12 = false
			fn28(false)
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if not flag12 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local name = input.KeyCode.Name
		flag = true
		flag12 = false
		fn28(false)
		fn19("SpeedGlitch", name)

		task.defer(function()
			flag = false
		end)
	end)

	textButton.MouseButton1Click:Connect(function()
		if speedGlitch.getWasDragged() then
			return
		end
		flag4 = not flag4

		if flag4 then
			if localPlayer.Character then
				fn15(localPlayer.Character)
			end
		else
			fn16()
		end

		fn26(flag4)
	end)
end

local function fn28()
	if screenGui2 then
		screenGui2:Destroy()
		screenGui2 = nil
	end

	textButton = nil
	textLabel = nil
	frame = nil
	fn16()

	if tbl3.SpeedGlitch then
		tbl3.SpeedGlitch.active = false
	end
end

local function fn29(arg)
	if arg:IsA("BasePart") then
		arg.Material = Enum.Material.SmoothPlastic
		arg.CastShadow = false
	elseif arg:IsA("Decal") or arg:IsA("Texture") or arg:IsA("ParticleEmitter") or arg:IsA("Trail") or arg:IsA("Smoke") or arg:IsA("Fire") or arg:IsA("Sparkles") then
		arg:Destroy()
	end
end

local function fn30()
	if flag9 then
		return
	end
	flag9 = true
	local Lighting = game:GetService("Lighting")
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 9e9
	Lighting.Brightness = 1

	for _, child in ipairs(Lighting:GetChildren()) do
		if child:IsA("BlurEffect") or child:IsA("SunRaysEffect") or child:IsA("ColorCorrectionEffect") or child:IsA("BloomEffect") or child:IsA("DepthOfFieldEffect") then
			child:Destroy()
		end
	end

	settings().Rendering.QualityLevel = 1

	for _, descendant in ipairs(workspace:GetDescendants()) do
		fn29(descendant)
	end

	tbl5[#tbl5 + 1] = workspace.DescendantAdded:Connect(function(descendant)
		fn29(descendant)
	end)
end

local cFrame = nil

local function fn31()
	flag3 = false
	if screenGui then
		return
	end
	screenGui = Instance.new("ScreenGui")
	screenGui.Name = "FlingStopGui"
	screenGui.Parent = game.CoreGui
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0, 160, 0, 45)
	frame2.Position = UDim2.new(0.5, -80, 1, -120)
	frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame2.BorderSizePixel = 0
	frame2.Active = true
	frame2.Draggable = false
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
	if screenGui then
		screenGui:Destroy()
		screenGui = nil
	end

	if cFrame then
		local character = localPlayer.Character
		local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")

		if humanoidRootPart then
			local now = tick()

			while true do
				humanoidRootPart.CFrame = cFrame * CFrame.new(0, 0.5, 0)
				character:SetPrimaryPartCFrame(cFrame * CFrame.new(0, 0.5, 0))

				if humanoid then
					humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
				end

				for _, child in ipairs(character:GetChildren()) do
					if child:IsA("BasePart") then
						child.Velocity = Vector3.zero
						child.RotVelocity = Vector3.zero
					end
				end

				task.wait()
				if not ((humanoidRootPart.Position - cFrame.p).Magnitude < 25 or tick() - now > 3) then
					continue
				end
				break
			end
		end

		cFrame = nil
	end

	workspace.FallenPartsDestroyHeight = getgenv().FPDH or -500
end

local function fn33(arg, arg2)
	if flag3 then
		return
	end
	local Players2 = game:GetService("Players")
	local localPlayer2 = Players2.LocalPlayer
	local flag12 = false

	local function fn34(arg3)
		local character = localPlayer2.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local rootPart = humanoid and humanoid.RootPart
		local character2 = arg3.Character
		local humanoid2 = nil
		local rootPart2 = nil

		if character2:FindFirstChildOfClass("Humanoid") then
			humanoid2 = character2:FindFirstChildOfClass("Humanoid")
		end

		if humanoid2 and humanoid2.RootPart then
			rootPart2 = humanoid2.RootPart
		end

		local head = nil

		if character2:FindFirstChild("Head") then
			head = character2.Head
		end

		local accessory = nil

		if character2:FindFirstChildOfClass("Accessory") then
			accessory = character2:FindFirstChildOfClass("Accessory")
		end

		local handle = accessory and accessory:FindFirstChild("Handle")
		local handle2 = nil

		if handle then
			handle2 = accessory.Handle
		end

		if character and humanoid and rootPart then
			if rootPart.Velocity.Magnitude < 50 then
				local cFrame2 = rootPart.CFrame
				getgenv().OldPos = cFrame2
			end

			if humanoid2 and humanoid2.Sit and not flag12 then
				return
			end

			if head then
				if head.Velocity.Magnitude > 500 then
					return
				end
			elseif not head and handle2 then
				if handle2.Velocity.Magnitude > 500 then
					return
				end
			end

			if head then
				workspace.CurrentCamera.CameraSubject = head
			elseif not head and handle2 then
				workspace.CurrentCamera.CameraSubject = handle2
			elseif humanoid2 and rootPart2 then
				workspace.CurrentCamera.CameraSubject = humanoid2
			end

			if not character2:FindFirstChildWhichIsA("BasePart") then
				return
			end

			local function fn35(arg4, arg5, arg6)
				rootPart.CFrame = CFrame.new(arg4.Position) * arg5 * arg6
				character:SetPrimaryPartCFrame(CFrame.new(arg4.Position) * arg5 * arg6)
				rootPart.Velocity = Vector3.new(90000000, 900000000, 90000000)
				rootPart.RotVelocity = Vector3.new(900000000, 900000000, 900000000)
			end

			local function fn36(arg4)
				local now = tick()
				local n6 = 0

				while not flag3 do
					if rootPart and humanoid2 then
						if arg4.Velocity.Magnitude < 50 then
							n6 += 100
							local n7 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe = CFrame.Angles
							fn35(arg4, CFrame.new(0, 3, 0) + n7, cframe(math.rad(n6), 0, 0))
							task.wait()
							local n8 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe2 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 1.5, 0) + n8, cframe2(math.rad(n6), 0, 0))
							task.wait()
							local n9 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe3 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 0, 0) + n9, cframe3(math.rad(n6), 0, 0))
							task.wait()
							local n10 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe4 = CFrame.Angles
							fn35(arg4, CFrame.new(2.25, 3, -2.25) + n10, cframe4(math.rad(n6), 0, 0))
							task.wait()
							local n11 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe5 = CFrame.Angles
							fn35(arg4, CFrame.new(1.125, 1.5, -1.125) + n11, cframe5(math.rad(n6), 0, 0))
							task.wait()
							local n12 = humanoid2.MoveDirection * arg4.Velocity.Magnitude / 1.25
							local cframe6 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 0, 0) + n12, cframe6(math.rad(n6), 0, 0))
							task.wait()
						else
							local cframe = CFrame.Angles
							fn35(arg4, CFrame.new(0, 3, humanoid2.WalkSpeed), cframe(1.5707963267948966, 0, 0))
							task.wait()
							local cframe2 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 1.5, humanoid2.WalkSpeed), cframe2(1.5707963267948966, 0, 0))
							task.wait()
							local cframe3 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 0, humanoid2.WalkSpeed), cframe3(1.5707963267948966, 0, 0))
							task.wait()
							local cframe4 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 3, rootPart2.Velocity.Magnitude / 1.25), cframe4(1.5707963267948966, 0, 0))
							task.wait()
							local cframe5 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 1.5, rootPart2.Velocity.Magnitude / 1.25), cframe5(1.5707963267948966, 0, 0))
							task.wait()
							local cframe6 = CFrame.Angles
							fn35(arg4, CFrame.new(0, 0, rootPart2.Velocity.Magnitude / 1.25), cframe6(1.5707963267948966, 0, 0))
							task.wait()
						end

						if not (arg4.Velocity.Magnitude > 500 or flag3 or arg4.Parent ~= arg3.Character or arg3.Parent ~= Players2 or arg3.Character ~= character2 or humanoid2.Sit or humanoid.Health <= 0 or tick() > now + 2) then
							continue
						end
					end

					break
				end
			end

			local fallenPartsDestroyHeight = workspace.FallenPartsDestroyHeight
			getgenv().FPDH = fallenPartsDestroyHeight
			workspace.FallenPartsDestroyHeight = (0/0)
			local bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Name = "EpixVel"
			bodyVelocity.Parent = rootPart
			bodyVelocity.Velocity = Vector3.new(900000000, 900000000, 900000000)
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

			if rootPart2 and head then
				if (rootPart2.CFrame.p - head.CFrame.p).Magnitude > 5 then
					fn36(head)
				else
					fn36(rootPart2)
				end
			elseif rootPart2 and not head then
				fn36(rootPart2)
			elseif not rootPart2 and head then
				fn36(head)
			else
				if not (not rootPart2 and not head and accessory and handle2) then
					return
				end
				fn36(handle2)
			end

			bodyVelocity:Destroy()
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
			workspace.CurrentCamera.CameraSubject = humanoid

			if not arg2 then
				local now = tick()

				while true do
					rootPart.CFrame = getgenv().OldPos * CFrame.new(0, 0.5, 0)
					character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, 0.5, 0))
					humanoid:ChangeState("GettingUp")

					for _, child in ipairs(character:GetChildren()) do
						if child:IsA("BasePart") then
							child.Velocity = Vector3.new()
							child.RotVelocity = Vector3.new()
						end
					end

					task.wait()
					if not ((rootPart.Position - getgenv().OldPos.p).Magnitude < 25 or tick() - now > 3 or flag3) then
						continue
					end
					break
				end
			end

			workspace.FallenPartsDestroyHeight = getgenv().FPDH
		end
	end

	fn34(({ arg })[1])
end

local screenGui3 = nil

local function fn34()
	if screenGui3 then
		return
	end
	screenGui3 = Instance.new("ScreenGui")
	screenGui3.Name = "FlingMurdererGui"
	screenGui3.ResetOnSpawn = false
	screenGui3.Parent = game.CoreGui
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0, 160, 0, 45)
	frame2.Position = UDim2.new(0.5, -80, 0.5, 150)
	frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame2.BorderSizePixel = 0
	frame2.Active = true
	frame2.Draggable = false
	frame2.Parent = screenGui3
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
	textButton2.Text = "Fling Murderer"
	textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 15
	textButton2.Parent = frame2
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local color2 = Color3.fromRGB(255, 255, 255)
	local color3 = Color3.fromRGB(50, 230, 110)

	local function fn35()
		TweenService:Create(textButton2, tweenInfo, { TextColor3 = color2 }):Play()
		TweenService:Create(uiStroke, tweenInfo, { Color = color2 }):Play()
	end

	local flingMurderer = fn18(textButton2, frame2, "FlingMurderer")

	local function fn36()
		local v5 = fn6()
		if not v5 or v5 == localPlayer then
			lib:Notify({ Title = "Error", Content = "Murderer not found", Duration = 3, Icon = "lock" })
			return
		end

		task.spawn(function()
			pcall(function()
				fn33(v5)
			end)

			fn35()
		end)
	end

	tbl3.FlingMurderer = { active = true, action = fn36 }
	local flag12 = false

	textButton2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			flag12 = true
			TweenService:Create(uiStroke, tweenInfo, { Color = color3 }):Play()
			TweenService:Create(textButton2, tweenInfo, { TextColor3 = color3 }):Play()
		end
	end)

	textButton2.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if flag12 then
				if tbl2.FlingMurderer then
					tbl2.FlingMurderer = nil

					lib:Notify({
						Title = "Info",
						Content = "Keybind Removed / Fling Murderer",
						Duration = 3,
						Icon = "info",
					})
				end
			end

			flag12 = false
			fn35()
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if not flag12 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local name = input.KeyCode.Name
		flag = true
		flag12 = false
		fn35()
		fn19("FlingMurderer", name)

		task.defer(function()
			flag = false
		end)
	end)

	textButton2.MouseButton1Click:Connect(function()
		if flingMurderer.getWasDragged() then
			return
		end
		fn36()
	end)
end

local function fn35()
	if screenGui3 then
		screenGui3:Destroy()
		screenGui3 = nil
	end

	if tbl3.FlingMurderer then
		tbl3.FlingMurderer.active = false
	end
end

local screenGui4 = nil

local function fn36()
	if screenGui4 then
		return
	end
	screenGui4 = Instance.new("ScreenGui")
	screenGui4.Name = "FlingSheriffGui"
	screenGui4.ResetOnSpawn = false
	screenGui4.Parent = game.CoreGui
	local frame2 = Instance.new("Frame")
	frame2.Size = UDim2.new(0, 160, 0, 45)
	frame2.Position = UDim2.new(0.5, -80, 0.5, 205)
	frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
	frame2.BorderSizePixel = 0
	frame2.Active = true
	frame2.Draggable = false
	frame2.Parent = screenGui4
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
	textButton2.Text = "Fling Sheriff"
	textButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	textButton2.Font = Enum.Font.GothamBold
	textButton2.TextSize = 15
	textButton2.Parent = frame2
	local TweenService = game:GetService("TweenService")
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	local color2 = Color3.fromRGB(255, 255, 255)
	local color3 = Color3.fromRGB(50, 230, 110)

	local function fn37()
		TweenService:Create(textButton2, tweenInfo, { TextColor3 = color2 }):Play()
		TweenService:Create(uiStroke, tweenInfo, { Color = color2 }):Play()
	end

	local flingSheriff = fn18(textButton2, frame2, "FlingSheriff")

	local function fn38()
		local v5 = fn7()
		if not v5 or v5 == localPlayer then
			lib:Notify({ Title = "Error", Content = "Sheriff not found", Duration = 3, Icon = "lock" })
			return
		end

		task.spawn(function()
			pcall(function()
				fn33(v5)
			end)

			fn37()
		end)
	end

	tbl3.FlingSheriff = { active = true, action = fn38 }
	local flag12 = false

	textButton2.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			flag12 = true
			TweenService:Create(uiStroke, tweenInfo, { Color = color3 }):Play()
			TweenService:Create(textButton2, tweenInfo, { TextColor3 = color3 }):Play()
		end
	end)

	textButton2.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton2 then
			if flag12 then
				if tbl2.FlingSheriff then
					tbl2.FlingSheriff = nil

					lib:Notify({
						Title = "Info",
						Content = "Keybind Removed / Fling Sheriff",
						Duration = 3,
						Icon = "info",
					})
				end
			end

			flag12 = false
			fn37()
		end
	end)

	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if not flag12 then
			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end
		local name = input.KeyCode.Name
		flag = true
		flag12 = false
		fn37()
		fn19("FlingSheriff", name)

		task.defer(function()
			flag = false
		end)
	end)

	textButton2.MouseButton1Click:Connect(function()
		if flingSheriff.getWasDragged() then
			return
		end
		fn38()
	end)
end

local function fn37()
	if screenGui4 then
		screenGui4:Destroy()
		screenGui4 = nil
	end

	if tbl3.FlingSheriff then
		tbl3.FlingSheriff.active = false
	end
end

local v5 = v:Tab({ Title = "Main", Icon = "box", Locked = false })

v5:Toggle({
	Title = "Shoot Murderer",
	Flag = "ScreenShootFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn20()
		else
			fn21()
		end
	end,
})

v5:Toggle({
	Title = "Silent Aim",
	Flag = "SilentAimFlag",
	Value = false,
	Callback = function(arg)
		flag7 = arg
	end,
})

v5:Divider()

v5:Toggle({
	Title = "Throw Knife",
	Flag = "ScreenThrowFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn22()
		else
			fn23()
		end
	end,
})

v5:Button({
	Title = "Kill All",
	Callback = function()
		killAllAction()
	end,
})

v5:Divider()

v5:Button({
	Title = "Get Dropped Gun",
	Callback = function()
		fn14()
	end,
})

v5:Toggle({
	Title = "Auto Get Dropped Gun",
	Flag = "AutoGetDroppedGunFlag",
	Value = false,
	Callback = function(arg)
		flag2 = arg

		if arg then
			if fn10() then
				return
			end

			if fn3() then
				return
			end
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

v5:Toggle({
	Title = "Get Dropped Gun Button",
	Flag = "ScreenDroppedGunFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn24()
		else
			fn25()
		end
	end,
})

v5:Divider()

v5:Slider({
	Title = "Speed Value",
	Flag = "SpeedValueFlag",
	Step = 1,
	Value = { Min = 16, Max = 500, Default = 200 },
	Callback = function(arg)
		n2 = arg
	end,
})

v5:Toggle({
	Title = "Speed Glitch",
	Flag = "SpeedGlitchDirectFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn27()
		else
			fn28()
		end
	end,
})

local flag12 = false
local flag13 = false
local flag14 = false
local flag15 = false
local tbl8 = {}
local tbl9 = {}
local n6 = 1500
local highlight = Instance.new("Highlight")
highlight.Parent = game.CoreGui
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
	if not currentCamera then
		return false
	end
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
					highlight2.Enabled = flag12 and not v6

					if flag12 and not v6 then
						local v7 = fn40(player, character)
						local roleLabel = v7:FindFirstChild("RoleLabel")

						if roleLabel then
							roleLabel.Text = "Murderer"
							roleLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
						end

						v7.Enabled = true
					else
						local v7 = tbl9[player]

						if v7 then
							v7.Enabled = false
						end
					end
				elseif flag18 then
					highlight2.FillColor = Color3.fromRGB(0, 0, 255)
					highlight2.Enabled = flag13 and not v6

					if flag13 and not v6 then
						local v7 = fn40(player, character)
						local roleLabel = v7:FindFirstChild("RoleLabel")

						if roleLabel then
							roleLabel.Text = "Sheriff"
							roleLabel.TextColor3 = Color3.fromRGB(0, 0, 255)
						end

						v7.Enabled = true
					else
						local v7 = tbl9[player]

						if v7 then
							v7.Enabled = false
						end
					end
				else
					highlight2.FillColor = Color3.fromRGB(255, 255, 255)
					highlight2.Enabled = flag14 and not v6
					local v7 = tbl9[player]

					if v7 then
						v7.Enabled = false
					end
				end
			else
				if highlight2 then
					highlight2.Enabled = false
					highlight2.Adornee = nil
				end

				local v6 = tbl9[player]

				if v6 then
					v6.Enabled = false
				end
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

	if flag15 then
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

			if not flag16 then
				flag16 = true
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

local v6 = v:Tab({ Title = "Highlight", Icon = "eye", Locked = false })

v6:Toggle({
	Title = "Show Murderer",
	Flag = "ShowMurdererFlag",
	Value = false,
	Callback = function(arg)
		flag12 = arg
	end,
})

v6:Toggle({
	Title = "Show Sheriff",
	Flag = "ShowSheriffFlag",
	Value = false,
	Callback = function(arg)
		flag13 = arg
	end,
})

v6:Toggle({
	Title = "Show Innocent",
	Flag = "ShowInnocentFlag",
	Value = false,
	Callback = function(arg)
		flag14 = arg
	end,
})

v6:Toggle({
	Title = "Show Dropped Gun",
	Flag = "ShowDroppedGunFlag",
	Value = false,
	Callback = function(arg)
		flag15 = arg

		if not arg then
			fn39()
		end
	end,
})

local v7 = v:Tab({ Title = "Fling", Icon = "zap", Locked = false })

v7:Toggle({
	Title = "Fling Murderer Button",
	Flag = "FlingMurdererButtonFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn34()
		else
			fn35()
		end
	end,
})

v7:Toggle({
	Title = "Fling Sheriff Button",
	Flag = "FlingSheriffButtonFlag",
	Value = false,
	Callback = function(arg)
		if arg then
			fn36()
		else
			fn37()
		end
	end,
})

v7:Divider()

v7:Button({
	Title = "Fling Murderer",
	Callback = function()
		local v8 = fn6()
		if not v8 or v8 == localPlayer then
			lib:Notify({ Title = "Error", Content = "Murderer not found", Duration = 3, Icon = "lock" })
			return
		end

		task.spawn(function()
			pcall(function()
				fn33(v8)
			end)
		end)
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

		task.spawn(function()
			pcall(function()
				fn33(v8)
			end)
		end)
	end,
})

v7:Divider()
local str2 = ""

local v8 = v7:Dropdown({
	Title = "Select Player",
	Flag = "FlingPlayerDropdown",
	Values = tbl6,
	Value = "",
	Callback = function(arg)
		str2 = arg
	end,
})

table.insert(tbl7, v8)

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

		task.spawn(function()
			pcall(function()
				fn33(v9)
			end)
		end)
	end,
})

v7:Button({
	Title = "Fling All",
	Callback = function()
		local character = localPlayer.Character
		character = character and character:FindFirstChild("HumanoidRootPart")

		if character then
			cFrame = character.CFrame
		end

		fn31()

		task.spawn(function()
			for _, player in ipairs(game.Players:GetPlayers()) do
				if not flag3 then
					if player ~= localPlayer then
						pcall(function()
							fn33(player, true)
						end)
					end

					continue
				end

				break
			end

			fn32()
		end)
	end,
})

local v9 = v:Tab({ Title = "Utilities", Icon = "wrench", Locked = false })

v9:Toggle({
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

			if localPlayer.Character and localPlayer.Character:FindFirstChild("Teleport Tool") then
				localPlayer.Character:FindFirstChild("Teleport Tool"):Destroy()
			end
		end
	end,
})

local connection3 = nil

v9:Toggle({
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
				if connection3 then
					connection3:Disconnect()
					connection3 = nil
				end

				if localPlayer.Character then
					for _, descendant in pairs(localPlayer.Character:GetDescendants()) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = true
						end
					end
				end
			end)

			tool.Parent = localPlayer.Backpack
		else
			if connection3 then
				connection3:Disconnect()
				connection3 = nil
			end

			if localPlayer.Backpack:FindFirstChild("Noclip Tool") then
				localPlayer.Backpack:FindFirstChild("Noclip Tool"):Destroy()
			end

			if localPlayer.Character and localPlayer.Character:FindFirstChild("Noclip Tool") then
				localPlayer.Character:FindFirstChild("Noclip Tool"):Destroy()
			end
		end
	end,
})

v9:Toggle({
	Title = "Anti Fling",
	Flag = "antiflingflag",
	Value = false,
	Callback = function(arg)
		if arg then
			connection = RunService.Stepped:Connect(function()
				local character = localPlayer.Character
				if not character then
					return
				end
				local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
				if not humanoidRootPart then
					return
				end
				local position = humanoidRootPart.Position

				for _, player in pairs(game.Players:GetPlayers()) do
					if player ~= localPlayer and player.Character then
						local humanoidRootPart2 = player.Character:FindFirstChild("HumanoidRootPart")

						if humanoidRootPart2 and (humanoidRootPart2.Position - position).Magnitude <= 15 then
							for _, descendant in pairs(player.Character:GetDescendants()) do
								if descendant:IsA("BasePart") then
									descendant.CanCollide = false
								end
							end
						end
					end
				end
			end)
		elseif connection then
			connection:Disconnect()
			connection = nil
		end
	end,
})

v9:Toggle({
	Title = "Infınıte Jump",
	Flag = "infjumpflag",
	Value = false,
	Callback = function(arg)
		flag8 = arg
	end,
})

v9:Divider()

v9:Button({
	Title = "FPS Boost",
	Callback = function()
		fn30()
	end,
})

v9:Button({
	Title = "Infinite Yield",
	Callback = function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
	end,
})

local v10 = v:Tab({ Title = "Settings", Icon = "settings", Locked = false })

v10:Button({
	Title = "Save Config",
	Callback = function()
		v:Dialog({
			Title = "Save Config",
			Content = "Do you want to save the config?",
			Buttons = {
				{
					Title = "Cancel",
					Callback = function()
					end,
					Variant = "Secondary",
				},
				{
					Title = "Save",
					Callback = function()
						fn()
						lib:Notify({ Title = "Info", Content = "Config Saved", Duration = 3, Icon = "save" })
					end,
					Variant = "Primary",
				},
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
				{
					Title = "Cancel",
					Callback = function()
					end,
					Variant = "Secondary",
				},
				{
					Title = "Load",
					Callback = function()
						fn2()
						lib:Notify({ Title = "Info", Content = "Config Loaded", Duration = 3, Icon = "save" })
					end,
					Variant = "Primary",
				},
			},
		})
	end,
})

v:Tab({ Title = "Unkown", Icon = "info", Locked = false, Hidden = true }):Paragraph({
	Title = "UwU Studios",
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

print("i")
