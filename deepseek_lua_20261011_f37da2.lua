-- Adopt Me Autofarm V2 (robuste + Highlight ESP)
local _ok, _err = pcall(function()

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local SS = game:GetService("SoundService")
local LP = Players.LocalPlayer

-- ============================================================
-- REMOTES (compacts)
-- ============================================================
local R = {}
local paths = {
    FlyPet="API.AdoptAPI/FlyPet", RidePet="API.AdoptAPI/RidePet",
    FocusPet="API.AdoptAPI/FocusPet", UnfocusPet="API.AdoptAPI/UnfocusPet",
    DoNeonFusion="API.PetAPI/DoNeonFusion", ClaimPetReward="API.PetAPI/ClaimProgressionReward",
    ConsumeFood="API.PetAPI/ConsumeFoodObject", PetPetted="API.PetAPI/PetPetted",
    DrinkGrow="API.EffectsAPI/DrinkGrowPotion", DrinkCureAll="API.EffectsAPI/DrinkCureAllPotion",
    ClaimAchievement="API.AchievementsAPI/ClaimReward",
    BattlePassClaim="API.BattlePassAPI/ClaimReward",
    ClaimLogin="API.LootBoxAPI/ClaimLoginHandouts",
    ClaimDeliveries="API.HousingAPI/ClaimAllDeliveries",
    PayCollect="API.PayAPI/Collect",
    ClaimLike="API.EventAPI/ClaimLikeReward",
    ClaimUGC="API.EventAPI/ClaimUGCLinkedItems",
    ClaimBees="API.EventAPI/ClaimBeesBlaster",
    GetBirthdayCake="API.EventAPI/GetBirthdayCake",
    TicketsCollected="API.PetRecyclerAPI/TicketsCollected",
    RewardReceived="API.PetRecyclerAPI/RewardReceived",
    CandyCornClaim="adoptme_new_net.Halloween2026/CandyCornPileClaim",
    ClaimTombSpider="adoptme_new_net.Halloween2026/ClaimTombSpider",
    GhostVacuumFire="adoptme_new_net.Halloween2026/GhostVacuumToyFire",
    JacobeanTwig="adoptme_new_net.Halloween2026/JacobeanPigeonNestContributeTwig",
    LightningActivate="adoptme_new_net.Halloween2026/LightningLeverActivate",
    LightningDeliver="adoptme_new_net.Halloween2026/LightningLeverDeliver",
    StrayCatGift="adoptme_new_net.Halloween2026/StrayCatGiftFood",
    UnlockPadlock="adoptme_new_net.Halloween2026/UnlockPadlock",
    UnlockJournal="API.Halloween2026API/UnlockHauntletJournalPage",
    TeleToLocation="API.LocationAPI/TeleToLocation",
    TeleToPlayer="API.LocationAPI/TeleToPlayer",
}

local cache = {}
local function getRemote(name)
    if cache[name] then return cache[name] end
    local path = paths[name]
    if not path then return nil end
    local current = RS
    for _, part in ipairs(string.split(path, "/")) do
        if part:find("%.") then
            for _, sub in ipairs(string.split(part, ".")) do
                current = current and current:FindFirstChild(sub)
            end
        else
            current = current and current:FindFirstChild(part)
        end
        if not current then return nil end
    end
    cache[name] = current
    return current
end

local function fire(name, ...)
    local r = getRemote(name)
    if not r then return false end
    local ok = pcall(function()
        if r:IsA("RemoteEvent") then r:FireServer(...)
        elseif r:IsA("RemoteFunction") then r:InvokeServer(...) end
    end)
    return ok
end

-- ============================================================
-- UI
-- ============================================================
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

local sg = Instance.new("ScreenGui")
sg.Name = "AMAutofarm_"..math.random(10000,99999)
sg.ResetOnSpawn = false
sg.Parent = parentGui

-- Toggle flottant
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 15, 0, 100)
floatBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
floatBtn.Text = "🐾"
floatBtn.TextSize = 24
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextColor3 = Color3.new(1,1,1)
floatBtn.AutoButtonColor = false
floatBtn.Parent = sg
Instance.new("UICorner", floatBtn).CornerRadius = UDim.new(0,25)
local fbs = Instance.new("UIStroke", floatBtn)
fbs.Color = Color3.fromRGB(230,90,150); fbs.Thickness = 2

-- Fenêtre
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 580, 0, 340)
win.Position = UDim2.new(0.5, -290, 0.5, -170)
win.BackgroundColor3 = Color3.fromRGB(255,245,252)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = sg
Instance.new("UICorner", win).CornerRadius = UDim.new(0,14)
local ws = Instance.new("UIStroke", win)
ws.Color = Color3.fromRGB(255,130,190); ws.Thickness = 2

-- Header
local hd = Instance.new("Frame")
hd.Size = UDim2.new(1,0,0,40)
hd.BackgroundColor3 = Color3.fromRGB(255,130,190)
hd.BorderSizePixel = 0
hd.Parent = win
Instance.new("UICorner", hd).CornerRadius = UDim.new(0,14)
local hdfix = Instance.new("Frame", hd)
hdfix.Size = UDim2.new(1,0,0,14); hdfix.Position = UDim2.new(0,0,1,-14)
hdfix.BackgroundColor3 = Color3.fromRGB(255,130,190); hdfix.BorderSizePixel = 0

local title = Instance.new("TextLabel", hd)
title.Size = UDim2.new(1,-60,1,0); title.Position = UDim2.new(0,15,0,0)
title.BackgroundTransparency = 1
title.Text = "🐾  ADOPT ME AUTOFARM"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBlack; title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", hd)
closeBtn.Size = UDim2.new(0,28,0,28); closeBtn.Position = UDim2.new(1,-36,0,6)
closeBtn.BackgroundColor3 = Color3.new(1,1,1); closeBtn.BackgroundTransparency = 0.75
closeBtn.Text = "✕"; closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0,8)
closeBtn.MouseButton1Click:Connect(function() sg.Enabled = false end)

-- Sidebar
local sidebar = Instance.new("Frame", win)
sidebar.Size = UDim2.new(0,140,1,-50); sidebar.Position = UDim2.new(0,10,0,48)
sidebar.BackgroundColor3 = Color3.fromRGB(255,235,248); sidebar.BorderSizePixel = 0
Instance.new("UICorner", sidebar).CornerRadius = UDim.new(0,10)
local sbl = Instance.new("UIListLayout", sidebar)
sbl.Padding = UDim.new(0,4); sbl.SortOrder = Enum.SortOrder.LayoutOrder
local sbp = Instance.new("UIPadding", sidebar)
sbp.PaddingTop = UDim.new(0,6); sbp.PaddingBottom = UDim.new(0,6)
sbp.PaddingLeft = UDim.new(0,6); sbp.PaddingRight = UDim.new(0,6)

-- Content
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1,-160,1,-58); content.Position = UDim2.new(0,158,0,48)
content.BackgroundColor3 = Color3.new(1,1,1); content.BorderSizePixel = 0
content.ScrollBarThickness = 6; content.ScrollBarImageColor3 = Color3.fromRGB(255,130,190)
content.CanvasSize = UDim2.new(0,0,0,0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", content).CornerRadius = UDim.new(0,10)
local cs = Instance.new("UIStroke", content)
cs.Color = Color3.fromRGB(255,200,230); cs.Thickness = 1
local cl = Instance.new("UIListLayout", content)
cl.Padding = UDim.new(0,6); cl.SortOrder = Enum.SortOrder.LayoutOrder
local cp = Instance.new("UIPadding", content)
cp.PaddingTop = UDim.new(0,8); cp.PaddingBottom = UDim.new(0,8)
cp.PaddingLeft = UDim.new(0,8); cp.PaddingRight = UDim.new(0,8)

-- ============================================================
-- HELPERS UI
-- ============================================================
local function clearContent()
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function mkBtn(text, color, order, parent, h)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-4,0,h or 32)
    b.BackgroundColor3 = color
    b.Text = text; b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamBold; b.TextSize = 12
    b.LayoutOrder = order; b.AutoButtonColor = false
    b.Parent = parent or content
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    return b
end

local function mkToggle(text, order, defaultOn, callback)
    local holder = Instance.new("Frame", content)
    holder.Size = UDim2.new(1,-4,0,32)
    holder.BackgroundColor3 = Color3.fromRGB(255,245,252)
    holder.BorderSizePixel = 0; holder.LayoutOrder = order
    Instance.new("UICorner", holder).CornerRadius = UDim.new(0,8)
    local hs = Instance.new("UIStroke", holder)
    hs.Color = Color3.fromRGB(255,200,230); hs.Thickness = 1

    local lbl = Instance.new("TextLabel", holder)
    lbl.Size = UDim2.new(1,-70,1,0); lbl.Position = UDim2.new(0,12,0,0)
    lbl.BackgroundTransparency = 1; lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(80,50,100)
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local state = defaultOn
    local btn = Instance.new("TextButton", holder)
    btn.Size = UDim2.new(0,50,0,22); btn.Position = UDim2.new(1,-58,0.5,-11)
    btn.BackgroundColor3 = state and Color3.fromRGB(120,220,150) or Color3.fromRGB(200,200,200)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,6)

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(120,220,150) or Color3.fromRGB(200,200,200)
        btn.Text = state and "ON" or "OFF"
        if callback then callback(state) end
    end)
end

local function mkLabel(text, order, color)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1,-4,0,0); l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundColor3 = color or Color3.fromRGB(255,235,248)
    l.BorderSizePixel = 0
    l.Text = "  "..text
    l.TextColor3 = Color3.fromRGB(80,50,100)
    l.Font = Enum.Font.GothamBold; l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left; l.TextWrapped = true
    l.LayoutOrder = order
    Instance.new("UICorner", l).CornerRadius = UDim.new(0,6)
    local p = Instance.new("UIPadding", l)
    p.PaddingTop = UDim.new(0,5); p.PaddingBottom = UDim.new(0,5)
    p.PaddingLeft = UDim.new(0,6); p.PaddingRight = UDim.new(0,6)
end

-- ============================================================
-- TABS
-- ============================================================
local tabs = {}
local function createTab(id, label, cb)
    local b = mkBtn(label, Color3.fromRGB(255,235,248), #tabs+1, sidebar, 30)
    b.TextColor3 = Color3.fromRGB(140,100,180)
    tabs[id] = {btn=b, cb=cb}
    b.MouseButton1Click:Connect(function()
        for tid, t in pairs(tabs) do
            t.btn.BackgroundColor3 = tid == id and Color3.fromRGB(255,130,190) or Color3.fromRGB(255,235,248)
            t.btn.TextColor3 = tid == id and Color3.new(1,1,1) or Color3.fromRGB(140,100,180)
        end
        clearContent()
        cb()
    end)
end

-- ============================================================
-- LOOPS
-- ============================================================
local loops = {}
local function startLoop(name, int, fn)
    if loops[name] then return end
    loops[name] = task.spawn(function()
        while loops[name] do
            pcall(fn)
            task.wait(int)
        end
    end)
end
local function stopLoop(name)
    if loops[name] then loops[name] = nil end
end

-- ============================================================
-- ESP via HIGHLIGHT (natif, marche partout)
-- ============================================================
local espEnabled = false
local espPets = false
local espPlayers = false
local activeHL = {}

local function clearHL()
    for obj, hl in pairs(activeHL) do
        pcall(function() hl:Destroy() end)
    end
    activeHL = {}
end

local function applyHL(obj, color, name)
    if activeHL[obj] then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = color
    hl.OutlineColor = color
    hl.FillTransparency = 0.5
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = obj
    activeHL[obj] = hl
end

local function isPet(model)
    if not model:IsA("Model") then return false end
    if not model:FindFirstChildOfClass("Humanoid") then return false end
    return model:GetAttribute("Pet") ~= nil or model:FindFirstChild("PetOwner") ~= nil
end

local function refreshESP()
    clearHL()
    if not espEnabled then return end
    if espPlayers then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                applyHL(p.Character, Color3.fromRGB(255,80,80))
            end
        end
    end
    if espPets then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if isPet(obj) then
                applyHL(obj, Color3.fromRGB(120,220,150))
            end
        end
    end
end

-- ============================================================
-- TABS CONTENT
-- ============================================================
createTab("farm", "🌾 Farm", function()
    mkLabel("🌾 Farm automatique", 1, Color3.fromRGB(220,240,255))
    mkToggle("Auto-claim rewards", 2, false, function(v)
        if v then startLoop("claim", 6, function()
            fire("ClaimAchievement"); fire("ClaimLogin"); fire("ClaimLike")
            fire("BattlePassClaim"); fire("ClaimUGC"); fire("ClaimDeliveries")
            fire("ClaimBees"); fire("GetBirthdayCake"); fire("ClaimPetReward")
        end) else stopLoop("claim") end
    end)
    mkToggle("Auto-collect pay", 3, false, function(v)
        if v then startLoop("pay", 2, function() fire("PayCollect") end)
        else stopLoop("pay") end
    end)
    mkToggle("Auto-farm pets", 4, false, function(v)
        if v then startLoop("farmpets", 3, function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if isPet(obj) then
                    pcall(function()
                        fire("FocusPet", obj)
                        fire("PetPetted", obj)
                        fire("ConsumeFood", obj)
                    end)
                end
            end
        end) else stopLoop("farmpets") end
    end)
    mkToggle("Auto pet recycler", 5, false, function(v)
        if v then startLoop("recycler", 10, function()
            fire("TicketsCollected"); fire("RewardReceived")
        end) else stopLoop("recycler") end
    end)
end)

createTab("pets", "🐶 Pets", function()
    mkLabel("🐶 Actions pets", 1, Color3.fromRGB(255,220,240))
    local b1 = mkBtn("🦅 Fly tous les pets", Color3.fromRGB(120,200,240), 2)
    b1.MouseButton1Click:Connect(function() fire("FlyPet") end)
    local b2 = mkBtn("🐎 Ride tous les pets", Color3.fromRGB(255,180,100), 3)
    b2.MouseButton1Click:Connect(function() fire("RidePet") end)
    local b3 = mkBtn("💎 Fusion NÉON", Color3.fromRGB(255,200,240), 4)
    b3.MouseButton1Click:Connect(function() fire("DoNeonFusion") end)
    local b4 = mkBtn("🌟 Fusion MÉGA", Color3.fromRGB(255,220,130), 5)
    b4.MouseButton1Click:Connect(function() fire("DoNeonFusion") end)
    local b5 = mkBtn("🎁 Claim progression pets", Color3.fromRGB(150,220,180), 6)
    b5.MouseButton1Click:Connect(function() fire("ClaimPetReward") end)
    mkLabel("💊 Potions", 7, Color3.fromRGB(220,240,255))
    local b6 = mkBtn("📈 Grow", Color3.fromRGB(150,220,150), 8)
    b6.MouseButton1Click:Connect(function() fire("DrinkGrow") end)
    local b7 = mkBtn("💚 Cure All", Color3.fromRGB(150,220,200), 9)
    b7.MouseButton1Click:Connect(function() fire("DrinkCureAll") end)
end)

createTab("halloween", "🎃 Halloween", function()
    mkLabel("🎃 Event Halloween 2026", 1, Color3.fromRGB(255,200,220))
    mkToggle("Auto-claim TOUT Halloween", 2, false, function(v)
        if v then startLoop("halloween", 2, function()
            fire("CandyCornClaim"); fire("ClaimTombSpider"); fire("GhostVacuumFire")
            fire("JacobeanTwig"); fire("LightningActivate"); fire("LightningDeliver")
            fire("StrayCatGift"); fire("UnlockPadlock"); fire("UnlockJournal")
        end) else stopLoop("halloween") end
    end)
    mkLabel("🔧 Actions individuelles", 3, Color3.fromRGB(220,240,255))
    local actions = {
        {"🍬 Candy Corn", "CandyCornClaim"},
        {"🕷️ Tomb Spider", "ClaimTombSpider"},
        {"👻 Ghost Vacuum", "GhostVacuumFire"},
        {"🪶 Jacobean Twig", "JacobeanTwig"},
        {"⚡ Lightning Activate", "LightningActivate"},
        {"⚡ Lightning Deliver", "LightningDeliver"},
        {"🐈 Stray Cat Food", "StrayCatGift"},
        {"🔓 Unlock Padlock", "UnlockPadlock"},
        {"📖 Unlock Journal", "UnlockJournal"},
    }
    for i, d in ipairs(actions) do
        local b = mkBtn(d[1], Color3.fromRGB(255,150,200), 3+i, content, 28)
        b.MouseButton1Click:Connect(function() fire(d[2]) end)
    end
end)

createTab("visuals", "👁 Visuals", function()
    mkLabel("👁 ESP avec Highlight (marche partout)", 1, Color3.fromRGB(220,240,255))
    mkToggle("Activer ESP", 2, false, function(v) espEnabled = v; refreshESP() end)
    mkToggle("ESP Joueurs (rouge)", 3, false, function(v) espPlayers = v; refreshESP() end)
    mkToggle("ESP Pets (vert)", 4, false, function(v) espPets = v; refreshESP() end)
    local b = mkBtn("🔄 Rafraîchir", Color3.fromRGB(150,220,180), 5)
    b.MouseButton1Click:Connect(function() refreshESP() end)
    mkLabel("💡 Active ESP global puis Pets pour voir les pets à travers les murs.", 6)
end)

createTab("tp", "🚀 TP", function()
    mkLabel("🚀 Téléportation", 1, Color3.fromRGB(220,240,255))
    local locs = {"house","city","farm","halloween","shop","park","school","petpen"}
    for i, loc in ipairs(locs) do
        local b = mkBtn("➡️ "..loc:upper(), Color3.fromRGB(180,140,240), 1+i, content, 28)
        b.MouseButton1Click:Connect(function() fire("TeleToLocation", loc) end)
    end
    local b = mkBtn("🎯 Joueur le plus proche", Color3.fromRGB(255,180,100), 20)
    b.MouseButton1Click:Connect(function()
        local near, d = nil, math.huge
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myPos = LP.Character.HumanoidRootPart.Position
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local dd = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                    if dd < d then d = dd; near = p end
                end
            end
        end
        if near then fire("TeleToPlayer", near) end
    end)
end)

createTab("config", "⚙️ Config", function()
    mkLabel("⚙️ Configuration", 1, Color3.fromRGB(220,240,255))
    local b1 = mkBtn("⏹ Arrêter tous les loops", Color3.fromRGB(255,120,130), 2)
    b1.MouseButton1Click:Connect(function()
        for name in pairs(loops) do stopLoop(name) end
    end)
    local b2 = mkBtn("❌ Détruire l'UI", Color3.fromRGB(200,80,90), 3)
    b2.MouseButton1Click:Connect(function() clearHL(); sg:Destroy() end)
    mkLabel("🐾 Autofarm V2 - 32 remotes mappés", 4)
    mkLabel("⚠️ Compte poubelle recommandé", 5, Color3.fromRGB(255,220,220))
end)

-- ============================================================
-- INIT
-- ============================================================
tabs.farm.btn.BackgroundColor3 = Color3.fromRGB(255,130,190)
tabs.farm.btn.TextColor3 = Color3.new(1,1,1)
tabs.farm.cb()

-- Toggle float
floatBtn.MouseButton1Click:Connect(function()
    sg.Enabled = not sg.Enabled
    if not sg.Enabled then
        task.delay(0.05, function() sg.Enabled = true end)
    end
end)

-- Drag float
do
    local drag, dS, sP
    floatBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dS = i.Position; sP = floatBtn.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            floatBtn.Position = UDim2.new(sP.X.Scale, sP.X.Offset+d.X, sP.Y.Scale, sP.Y.Offset+d.Y)
        end
    end)
end

-- Auto-refresh ESP sur nouveaux persos
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then refreshESP() end
    end)
end)

print("[AM Autofarm V2] Chargé OK")

end)

-- Affichage d'erreur visible à l'écran
if not _ok then
    warn("[AM Autofarm V2] ERREUR: "..tostring(_err))
    local errGui = Instance.new("ScreenGui")
    errGui.Name = "AMError_"..math.random(10000,99999)
    pcall(function() errGui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    local f = Instance.new("Frame", errGui)
    f.Size = UDim2.new(0, 500, 0, 130)
    f.Position = UDim2.new(0.5, -250, 0.1, 0)
    f.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    f.BorderSizePixel = 0
    Instance.new("UICorner", f).CornerRadius = UDim.new(0, 12)
    local t = Instance.new("TextLabel", f)
    t.Size = UDim2.new(1, -20, 1, -20); t.Position = UDim2.new(0, 10, 0, 10)
    t.BackgroundTransparency = 1
    t.Text = "❌ ERREUR:\n"..tostring(_err):sub(1, 400)
    t.TextColor3 = Color3.new(1,1,1)
    t.Font = Enum.Font.GothamBold; t.TextSize = 13
    t.TextWrapped = true; t.TextYAlignment = Enum.TextYAlignment.Top
end