print("[AM Farm] Démarrage...")

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.3)

local LP = Players.LocalPlayer
print("[AM Farm] Joueur:", LP and LP.Name)

-- Parent GUI le plus simple possible
local parent = game:GetService("CoreGui")
print("[AM Farm] Parent:", parent and parent.ClassName)

local sg = Instance.new("ScreenGui")
sg.Name = "AMFarm_" .. math.random(1000, 9999)
sg.ResetOnSpawn = false
sg.Parent = parent
print("[AM Farm] ScreenGui OK")

-- Fenêtre rectangulaire
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 360, 0, 500)
win.Position = UDim2.new(0.5, -180, 0.5, -250)
win.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = sg

local wc = Instance.new("UICorner")
wc.CornerRadius = UDim.new(0, 14)
wc.Parent = win

local ws = Instance.new("UIStroke")
ws.Color = Color3.fromRGB(255, 130, 190)
ws.Thickness = 2
ws.Parent = win

-- Header
local hd = Instance.new("Frame")
hd.Size = UDim2.new(1, 0, 0, 44)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.BorderSizePixel = 0
hd.Parent = win
local hdc = Instance.new("UICorner")
hdc.CornerRadius = UDim.new(0, 14)
hdc.Parent = hd
local hdfix = Instance.new("Frame")
hdfix.Size = UDim2.new(1, 0, 0, 15)
hdfix.Position = UDim2.new(0, 0, 1, -15)
hdfix.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hdfix.BorderSizePixel = 0
hdfix.Parent = hd

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐾 ADOPT ME AUTOFARM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = hd

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -38, 0, 7)
closeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundTransparency = 0.7
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = hd
local cbc = Instance.new("UICorner")
cbc.CornerRadius = UDim.new(0, 8)
cbc.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    sg:Destroy()
end)

-- Scroll content
local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -20, 1, -60)
scroll.Position = UDim2.new(0, 10, 0, 54)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 5
scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.Parent = win
local scl = Instance.new("UIListLayout")
scl.Padding = UDim.new(0, 6)
scl.SortOrder = Enum.SortOrder.LayoutOrder
scl.Parent = scroll

-- Status label (en bas)
local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 1, -28)
status.BackgroundTransparency = 1
status.Text = "✅ Chargé - clique un bouton"
status.TextColor3 = Color3.fromRGB(80, 50, 100)
status.Font = Enum.Font.Gotham
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = win

-- SECTION label
local function section(text, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 26)
    l.BackgroundColor3 = Color3.fromRGB(255, 220, 240)
    l.BorderSizePixel = 0
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(180, 60, 130)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    l.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 6)
    c.Parent = l
    return l
end

-- Toggle button
local function toggle(text, order, defaultOn, cb)
    local holder = Instance.new("TextButton")
    holder.Size = UDim2.new(1, 0, 0, 36)
    holder.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    holder.BorderSizePixel = 0
    holder.Text = ""
    holder.AutoButtonColor = false
    holder.LayoutOrder = order
    holder.Parent = scroll
    local hc = Instance.new("UICorner")
    hc.CornerRadius = UDim.new(0, 8)
    hc.Parent = holder
    local hs = Instance.new("UIStroke")
    hs.Color = Color3.fromRGB(255, 200, 230)
    hs.Thickness = 1
    hs.Parent = holder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -80, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(80, 50, 100)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local state = defaultOn
    local badge = Instance.new("TextLabel")
    badge.Size = UDim2.new(0, 50, 0, 22)
    badge.Position = UDim2.new(1, -60, 0.5, -11)
    badge.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
    badge.Text = state and "ON" or "OFF"
    badge.TextColor3 = Color3.new(1, 1, 1)
    badge.Font = Enum.Font.GothamBold
    badge.TextSize = 11
    badge.Parent = holder
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = badge

    holder.MouseButton1Click:Connect(function()
        state = not state
        badge.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
        badge.Text = state and "ON" or "OFF"
        if cb then cb(state) end
    end)
    return holder
end

-- Button
local function button(text, order, color, cb)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = color or Color3.fromRGB(180, 140, 240)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.Parent = scroll
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = b
    b.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
    return b
end

-- REMOTE FINDER
local cache = {}
local function getRemote(folder, name)
    local key = folder .. "/" .. name
    if cache[key] then return cache[key] end
    local f = RS:FindFirstChild(folder, true)
    if not f then return nil end
    local r = f:FindFirstChild(name)
    if r then cache[key] = r end
    return r
end

local function fire(remote)
    if not remote then return false end
    pcall(function()
        if remote.ClassName == "RemoteEvent" then
            remote:FireServer()
        elseif remote.ClassName == "RemoteFunction" then
            remote:InvokeServer()
        end
    end)
    return true
end

-- Find API folder path
local function findAPI(name)
    -- All API remotes are in ReplicatedStorage.API.<Name>API/<Remote>
    local api = RS:FindFirstChild("API")
    if not api then return nil end
    local sub = api:FindFirstChild(name)
    if not sub then return nil end
    return sub
end

local function getRemoteFromAPI(apiName, remoteName)
    local api = findAPI(apiName)
    if not api then return nil end
    return api:FindFirstChild(remoteName)
end

-- Find adoptme_new_net remote
local function getNewNet(folder, remoteName)
    local net = RS:FindFirstChild("adoptme_new_net")
    if not net then return nil end
    local f = net:FindFirstChild(folder)
    if not f then return nil end
    return f:FindFirstChild(remoteName)
end

print("[AM Farm] Recherche des remotes...")

-- Find specific remotes
local remotes = {
    PetPetted = getRemoteFromAPI("PetAPI", "PetPetted"),
    ClaimProgressionReward = getRemoteFromAPI("PetAPI", "ClaimProgressionReward"),
    ConsumeFoodObject = getRemoteFromAPI("PetAPI", "ConsumeFoodObject"),
    FocusPet = getRemoteFromAPI("AdoptAPI", "FocusPet"),
    UnfocusPet = getRemoteFromAPI("AdoptAPI", "UnfocusPet"),
    FlyPet = getRemoteFromAPI("AdoptAPI", "FlyPet"),
    RidePet = getRemoteFromAPI("AdoptAPI", "RidePet"),
    DrinkGrowPotion = getRemoteFromAPI("EffectsAPI", "DrinkGrowPotion"),
    ClaimAchievement = getRemoteFromAPI("AchievementsAPI", "ClaimReward"),
    ClaimLogin = getRemoteFromAPI("LootBoxAPI", "ClaimLoginHandouts"),
    ClaimLikeReward = getRemoteFromAPI("EventAPI", "ClaimLikeReward"),
    ClaimUGC = getRemoteFromAPI("EventAPI", "ClaimUGCLinkedItems"),
    ClaimBees = getRemoteFromAPI("EventAPI", "ClaimBeesBlaster"),
    GetBirthdayCake = getRemoteFromAPI("EventAPI", "GetBirthdayCake"),
    ClaimDeliveries = getRemoteFromAPI("HousingAPI", "ClaimAllDeliveries"),
    PayCollect = getRemoteFromAPI("PayAPI", "Collect"),
    BattlePassClaim = getRemoteFromAPI("BattlePassAPI", "ClaimReward"),
    TicketsCollected = getRemoteFromAPI("PetRecyclerAPI", "TicketsCollected"),
    RewardReceived = getRemoteFromAPI("PetRecyclerAPI", "RewardReceived"),
    CandyCorn = getNewNet("Halloween2026", "CandyCornPileClaim"),
    TombSpider = getNewNet("Halloween2026", "ClaimTombSpider"),
    GhostVacuum = getNewNet("Halloween2026", "GhostVacuumToyFire"),
    JacobeanTwig = getNewNet("Halloween2026", "JacobeanPigeonNestContributeTwig"),
    LightningActivate = getNewNet("Halloween2026", "LightningLeverActivate"),
    LightningDeliver = getNewNet("Halloween2026", "LightningLeverDeliver"),
    StrayCat = getNewNet("Halloween2026", "StrayCatGiftFood"),
    UnlockPadlock = getNewNet("Halloween2026", "UnlockPadlock"),
}

-- Count found
local found = 0
local missing = {}
for name, r in pairs(remotes) do
    if r then found = found + 1 else table.insert(missing, name) end
end
print("[AM Farm] Remotes trouvés:", found, "/", found + #missing)
if #missing > 0 then
    print("[AM Farm] Manquants:", table.concat(missing, ", "))
end

-- LOOPS
local loops = {}
local function startLoop(name, interval, fn)
    if loops[name] then return end
    loops[name] = true
    task.spawn(function()
        while loops[name] do
            pcall(fn)
            task.wait(interval)
        end
    end)
end
local function stopLoop(name)
    loops[name] = nil
end

-- Get all player's pets
local function getMyPets()
    local pets = {}
    local char = LP.Character
    if not char then return pets end
    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
            local isPet = obj:GetAttribute("Pet") ~= nil
                or obj:FindFirstChild("PetOwner") ~= nil
                or obj.Name:lower():find("pet") ~= nil
                or obj:FindFirstChild("PetAccessory") ~= nil
            if isPet then
                table.insert(pets, obj)
            end
        end
    end
    return pets
end

-- ==============================
-- UI CONTENT
-- ==============================
local order = 0
local function nextOrder()
    order = order + 1
    return order
end

section("🐶 FARM PETS", nextOrder())

toggle("Auto-pet (spam PetPetted)", nextOrder(), false, function(v)
    if v then
        startLoop("petSpam", 0.15, function()
            local pets = getMyPets()
            for _, pet in ipairs(pets) do
                if remotes.PetPetted then
                    pcall(function() remotes.PetPetted:FireServer(pet) end)
                end
            end
        end)
        status.Text = "🟢 Auto-pet activé (" .. #getMyPets() .. " pets)"
    else
        stopLoop("petSpam")
        status.Text = "🔴 Auto-pet désactivé"
    end
end)

toggle("Auto-feed pets (ConsumeFoodObject)", nextOrder(), false, function(v)
    if v then
        startLoop("feedPet", 1.5, function()
            local pets = getMyPets()
            for _, pet in ipairs(pets) do
                if remotes.ConsumeFoodObject then
                    pcall(function() remotes.ConsumeFoodObject:FireServer(pet) end)
                end
            end
        end)
        status.Text = "🟢 Auto-feed activé"
    else
        stopLoop("feedPet")
        status.Text = "🔴 Auto-feed désactivé"
    end
end)

toggle("Auto-claim progression pets", nextOrder(), false, function(v)
    if v then
        startLoop("claimProg", 5, function()
            if remotes.ClaimProgressionReward then
                pcall(function() remotes.ClaimProgressionReward:FireServer() end)
            end
        end)
        status.Text = "🟢 Claim progression activé"
    else
        stopLoop("claimProg")
        status.Text = "🔴 Claim progression désactivé"
    end
end)

button("🦅 Fly tous mes pets", nextOrder(), Color3.fromRGB(120, 200, 240), function()
    local pets = getMyPets()
    for _, pet in ipairs(pets) do
        if remotes.FlyPet then
            pcall(function() remotes.FlyPet:InvokeServer(pet) end)
        end
    end
    status.Text = "🦅 Fly envoyé à " .. #pets .. " pets"
end)

button("🐎 Ride tous mes pets", nextOrder(), Color3.fromRGB(255, 180, 100), function()
    local pets = getMyPets()
    for _, pet in ipairs(pets) do
        if remotes.RidePet then
            pcall(function() remotes.RidePet:InvokeServer(pet) end)
        end
    end
    status.Text = "🐎 Ride envoyé à " .. #pets .. " pets"
end)

button("📈 Boire potion Grow (tous les pets)", nextOrder(), Color3.fromRGB(150, 220, 150), function()
    local pets = getMyPets()
    for _, pet in ipairs(pets) do
        if remotes.DrinkGrowPotion then
            pcall(function() remotes.DrinkGrowPotion:InvokeServer(pet) end)
        end
    end
    status.Text = "📈 Potion Grow envoyée"
end)

section("🎁 QUÊTES & RÉCOMPENSES", nextOrder())

toggle("Auto-claim TOUT (achievements, daily, events, UGC, battlepass)", nextOrder(), false, function(v)
    if v then
        startLoop("claimAll", 6, function()
            if remotes.ClaimAchievement then pcall(function() remotes.ClaimAchievement:FireServer() end) end
            if remotes.ClaimLogin then pcall(function() remotes.ClaimLogin:FireServer() end) end
            if remotes.ClaimLikeReward then pcall(function() remotes.ClaimLikeReward:InvokeServer() end) end
            if remotes.ClaimUGC then pcall(function() remotes.ClaimUGC:InvokeServer() end) end
            if remotes.ClaimBees then pcall(function() remotes.ClaimBees:InvokeServer() end) end
            if remotes.GetBirthdayCake then pcall(function() remotes.GetBirthdayCake:FireServer() end) end
            if remotes.ClaimDeliveries then pcall(function() remotes.ClaimDeliveries:FireServer() end) end
            if remotes.BattlePassClaim then pcall(function() remotes.BattlePassClaim:InvokeServer() end) end
        end)
        status.Text = "🟢 Claim TOUT activé"
    else
        stopLoop("claimAll")
        status.Text = "🔴 Claim TOUT désactivé"
    end
end)

toggle("Auto-collect argent (PayCollect)", nextOrder(), false, function(v)
    if v then
        startLoop("pay", 2, function()
            if remotes.PayCollect then pcall(function() remotes.PayCollect:FireServer() end) end
        end)
        status.Text = "🟢 Auto-pay activé"
    else
        stopLoop("pay")
        status.Text = "🔴 Auto-pay désactivé"
    end
end)

toggle("Auto-claim Pet Recycler tickets", nextOrder(), false, function(v)
    if v then
        startLoop("recycler", 10, function()
            if remotes.TicketsCollected then pcall(function() remotes.TicketsCollected:InvokeServer() end) end
            if remotes.RewardReceived then pcall(function() remotes.RewardReceived:FireServer() end) end
        end)
        status.Text = "🟢 Recycler activé"
    else
        stopLoop("recycler")
        status.Text = "🔴 Recycler désactivé"
    end
end)

section("🎃 HALLOWEEN 2026", nextOrder())

toggle("Auto-claim TOUT Halloween", nextOrder(), false, function(v)
    if v then
        startLoop("halloween", 2, function()
            if remotes.CandyCorn then pcall(function() remotes.CandyCorn:InvokeServer() end) end
            if remotes.TombSpider then pcall(function() remotes.TombSpider:InvokeServer() end) end
            if remotes.GhostVacuum then pcall(function() remotes.GhostVacuum:FireServer() end) end
            if remotes.JacobeanTwig then pcall(function() remotes.JacobeanTwig:InvokeServer() end) end
            if remotes.LightningActivate then pcall(function() remotes.LightningActivate:FireServer() end) end
            if remotes.LightningDeliver then pcall(function() remotes.LightningDeliver:InvokeServer() end) end
            if remotes.StrayCat then pcall(function() remotes.StrayCat:InvokeServer() end) end
            if remotes.UnlockPadlock then pcall(function() remotes.UnlockPadlock:InvokeServer() end) end
        end)
        status.Text = "🟢 Halloween TOUT activé"
    else
        stopLoop("halloween")
        status.Text = "🔴 Halloween désactivé"
    end
end)

section("⚙️ CONTRÔLE", nextOrder())

button("⏹ Arrêter tous les loops", nextOrder(), Color3.fromRGB(255, 120, 130), function()
    for name in pairs(loops) do
        loops[name] = nil
    end
    status.Text = "⏹ Tous les loops arrêtés"
end)

button("📊 Statut des remotes", nextOrder(), Color3.fromRGB(150, 200, 255), function()
    local s = "Remotes OK: " .. found .. "/" .. (found + #missing)
    if #missing > 0 then s = s .. " | Manquants: " .. table.concat(missing, ", ") end
    print("[AM Farm] " .. s)
    status.Text = s
end)

print("[AM Farm] UI affichée ! Regarde ton écran 🐾")