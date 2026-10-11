-- ============================================================
-- ADOPT ME ULTIMATE AUTOFARM v5
-- Fix tab state + Meilleure UI + Plus de quêtes
-- ============================================================
print("[v5] Init...")

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UIS = game:GetService("UserInputService")
local LP = Players.LocalPlayer

-- Modules
local AilmentsManager, InteriorsM, ClientDataModule
pcall(function()
    local m = RS:FindFirstChild("new")
    if m then m = m:FindFirstChild("modules") end
    if m then m = m:FindFirstChild("Ailments") end
    if m then m = m:FindFirstChild("AilmentsClient") end
    if m then AilmentsManager = require(m) end
end)
pcall(function()
    local m = RS:FindFirstChild("ClientModules")
    if m then m = m:FindFirstChild("Core") end
    if m then m = m:FindFirstChild("InteriorsM") end
    if m then m = m:FindFirstChild("InteriorsM") end
    if m then InteriorsM = require(m) end
end)
pcall(function()
    local m = RS:FindFirstChild("ClientModules")
    if m then m = m:FindFirstChild("Core") end
    if m then m = m:FindFirstChild("ClientData") end
    if m then ClientDataModule = require(m) end
end)

-- ============================================================
-- REMOTES
-- ============================================================
local api = RS:WaitForChild("API", 15)

local function R(path)
    if not api then return nil end
    local current = api
    for _, p in ipairs(string.split(path, "/")) do
        current = current:FindFirstChild(p)
        if not current then return nil end
    end
    return current
end

local REMOTES = {
    MiniAttemptJoin = R("MinigameAPI/AttemptJoin"),
    MiniMessageServer = R("MinigameAPI/MessageServer"),
    MiniLobbyLeave = R("MinigameAPI/LobbyLeave"),
    HauntletJournal = R("Halloween2026API/UnlockHauntletJournalPage"),
    CommitCollection = R("JournalAPI/CommitCollection"),
    CompleteAchievement = R("AchievementsAPI/CompleteAchievement"),
    ClaimAchievement = R("AchievementsAPI/ClaimReward"),
    FocusPet = R("PetAPI/FocusPet"),
    UnfocusPet = R("PetAPI/UnfocusPet"),
    ClaimProgression = R("PetAPI/ClaimProgressionReward"),
    ConsumeFood = R("PetAPI/ConsumeFoodObject"),
    CreatePetObject = R("PetObjectAPI/CreatePetObject"),
    PetHatched = R("PetAPI/PetHatched"),
    MarkHatched = R("PetAPI/MarkHatched"),
    TicketsCollected = R("PetRecyclerAPI/TicketsCollected"),
    RewardReceived = R("PetRecyclerAPI/RewardReceived"),
    ClaimLogin = R("LootBoxAPI/ClaimLoginHandouts"),
    BattlePassClaim = R("BattlePassAPI/ClaimReward"),
    ActivateFurniture = R("HousingAPI/ActivateFurniture"),
    ClaimDeliveries = R("HousingAPI/ClaimAllDeliveries"),
    PayCollect = R("PayAPI/Collect"),
    ClaimLike = R("EventAPI/ClaimLikeReward"),
    ClaimUGC = R("EventAPI/ClaimUGCLinkedItems"),
    ClaimBees = R("EventAPI/ClaimBeesBlaster"),
    GetBirthdayCake = R("EventAPI/GetBirthdayCake"),
    RedeemCode = R("CodeRedemptionAPI/AttemptRedeemCode"),
}

local function fire(remote, ...)
    if not remote then return false end
    local args = {...}
    return pcall(function()
        if remote.ClassName == "RemoteEvent" or remote.ClassName == "UnreliableRemoteEvent" then
            remote:FireServer(unpack(args))
        elseif remote.ClassName == "RemoteFunction" then
            remote:InvokeServer(unpack(args))
        end
    end)
end

-- ============================================================
-- UI — DESIGN AMÉLIORÉ
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "AMAutofarmV5_" .. math.random(10000, 99999)
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

-- Palette Adopt Me
local C = {
    Bg = Color3.fromRGB(28, 24, 42),
    Panel = Color3.fromRGB(38, 32, 56),
    Card = Color3.fromRGB(48, 42, 68),
    CardLight = Color3.fromRGB(58, 50, 82),
    Pink = Color3.fromRGB(255, 130, 190),
    PinkDark = Color3.fromRGB(230, 90, 150),
    Purple = Color3.fromRGB(180, 140, 240),
    Mint = Color3.fromRGB(140, 230, 190),
    Yellow = Color3.fromRGB(255, 210, 130),
    Red = Color3.fromRGB(255, 120, 130),
    Text = Color3.fromRGB(240, 238, 255),
    TextDim = Color3.fromRGB(170, 165, 195),
    Border = Color3.fromRGB(80, 70, 110),
}

local function corner(p, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r or 10); c.Parent = p end
local function stroke(p, c, t, tr) local s = Instance.new("UIStroke"); s.Color = c or C.Border; s.Thickness = t or 1.5; s.Transparency = tr or 0; s.Parent = p end
local function pad(p, a, t, b, l, r) local u = Instance.new("UIPadding"); u.PaddingTop = UDim.new(0, t or a or 0); u.PaddingBottom = UDim.new(0, b or a or 0); u.PaddingLeft = UDim.new(0, l or a or 0); u.PaddingRight = UDim.new(0, r or a or 0); u.Parent = p end
local function grad(p, c1, c2, rot) local g = Instance.new("UIGradient"); g.Color = ColorSequence.new(c1, c2); g.Rotation = rot or 0; g.Parent = p end

-- Bouton flottant
local fbtn = Instance.new("TextButton", sg)
fbtn.Size = UDim2.new(0, 54, 0, 54)
fbtn.Position = UDim2.new(0, 15, 0, 100)
fbtn.BackgroundColor3 = C.Pink
fbtn.Text = "🐾"
fbtn.TextSize = 26
fbtn.Font = Enum.Font.GothamBlack
fbtn.TextColor3 = Color3.new(1, 1, 1)
fbtn.AutoButtonColor = false
corner(fbtn, 27)
stroke(fbtn, C.PinkDark, 2)
grad(fbtn, C.Pink, C.Purple, 45)

-- Fenêtre
local win = Instance.new("Frame", sg)
win.Size = UDim2.new(0, 420, 0, 560)
win.Position = UDim2.new(0.5, -210, 0.5, -280)
win.BackgroundColor3 = C.Bg
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
corner(win, 16)
stroke(win, C.Pink, 2, 0.4)

-- Header avec gradient
local hd = Instance.new("Frame", win)
hd.Size = UDim2.new(1, 0, 0, 50)
hd.BackgroundColor3 = C.Pink
hd.BorderSizePixel = 0
corner(hd, 16)
local hdfix = Instance.new("Frame", hd)
hdfix.Size = UDim2.new(1, 0, 0, 20)
hdfix.Position = UDim2.new(0, 0, 1, -20)
hdfix.BackgroundColor3 = C.Pink
hdfix.BorderSizePixel = 0
grad(hd, C.Pink, C.Purple, 15)

local title = Instance.new("TextLabel", hd)
title.Size = UDim2.new(1, -60, 0, 24)
title.Position = UDim2.new(0, 15, 0, 6)
title.BackgroundTransparency = 1
title.Text = "🐾  ADOPT ME AUTOFARM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left

local subtitle = Instance.new("TextLabel", hd)
subtitle.Size = UDim2.new(1, -60, 0, 16)
subtitle.Position = UDim2.new(0, 15, 0, 28)
subtitle.BackgroundTransparency = 1
subtitle.Text = "v5 · Ailments + Hauntlet + Pets + Quêtes"
subtitle.TextColor3 = Color3.fromRGB(255, 240, 250)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 10
subtitle.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", hd)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 11)
closeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundTransparency = 0.75
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 13
closeBtn.AutoButtonColor = false
corner(closeBtn, 8)

-- Tab bar
local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1, -20, 0, 38)
tabBar.Position = UDim2.new(0, 10, 0, 60)
tabBar.BackgroundColor3 = C.Panel
tabBar.BorderSizePixel = 0
corner(tabBar, 10)
local tbl = Instance.new("UIListLayout", tabBar)
tbl.FillDirection = Enum.FillDirection.Horizontal
tbl.Padding = UDim.new(0, 4)
tbl.SortOrder = Enum.SortOrder.LayoutOrder
pad(tabBar, 4)

-- Content
local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -20, 1, -140)
content.Position = UDim2.new(0, 10, 0, 104)
content.BackgroundColor3 = C.Panel
content.BorderSizePixel = 0
content.ScrollBarThickness = 5
content.ScrollBarImageColor3 = C.Pink
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
corner(content, 10)
stroke(content, C.Border, 1, 0.5)
local cl = Instance.new("UIListLayout", content)
cl.Padding = UDim.new(0, 5)
cl.SortOrder = Enum.SortOrder.LayoutOrder
pad(content, 8)

-- Status bar bottom
local statusBar = Instance.new("Frame", win)
statusBar.Size = UDim2.new(1, -20, 0, 28)
statusBar.Position = UDim2.new(0, 10, 1, -34)
statusBar.BackgroundColor3 = C.Panel
statusBar.BorderSizePixel = 0
corner(statusBar, 8)
local statusLbl = Instance.new("TextLabel", statusBar)
statusLbl.Size = UDim2.new(1, -16, 1, 0)
statusLbl.Position = UDim2.new(0, 8, 0, 0)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "✅ Prêt"
statusLbl.TextColor3 = C.Mint
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 11
statusLbl.TextXAlignment = Enum.TextXAlignment.Left

-- ============================================================
-- STATE PERSISTENCE (FIX le bug des toggles qui reviennent à OFF)
-- ============================================================
local state = {} -- toutes les valeurs des toggles

local function setStatus(txt, color)
    statusLbl.Text = txt
    statusLbl.TextColor3 = color or C.Mint
end

-- ============================================================
-- UI HELPERS
-- ============================================================
local function clearContent()
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function mkSection(text, order)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, 0, 0, 24)
    l.BackgroundColor3 = C.CardLight
    l.BorderSizePixel = 0
    l.Text = "  " .. text
    l.TextColor3 = C.Pink
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = order
    corner(l, 6)
    local s = Instance.new("UIStroke", l)
    s.Color = C.Pink
    s.Thickness = 1
    s.Transparency = 0.7
end

local function mkInfo(text, order)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundColor3 = C.Card
    l.BorderSizePixel = 0
    l.Text = "  " .. text
    l.TextColor3 = C.TextDim
    l.Font = Enum.Font.Gotham
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.LayoutOrder = order
    corner(l, 6)
    pad(l, 6)
end

-- Toggle avec STATE PERSISTANT
local function mkToggle(id, text, order, def, cb)
    if state[id] == nil then state[id] = def end
    local current = state[id]

    local h = Instance.new("Frame", content)
    h.Size = UDim2.new(1, 0, 0, 36)
    h.BackgroundColor3 = C.Card
    h.BorderSizePixel = 0
    h.LayoutOrder = order
    corner(h, 8)
    local st = Instance.new("UIStroke", h)
    st.Color = current and C.Mint or C.Border
    st.Thickness = 1.5
    st.Transparency = current and 0 or 0.5

    local l = Instance.new("TextLabel", h)
    l.Size = UDim2.new(1, -80, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = current and C.Text or C.TextDim
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left

    local b = Instance.new("TextButton", h)
    b.Size = UDim2.new(0, 55, 0, 24)
    b.Position = UDim2.new(1, -62, 0.5, -12)
    b.BackgroundColor3 = current and C.Mint or Color3.fromRGB(80, 75, 100)
    b.Text = current and "ON" or "OFF"
    b.TextColor3 = current and C.Bg or C.TextDim
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    corner(b, 6)

    b.MouseButton1Click:Connect(function()
        state[id] = not state[id]
        local v = state[id]
        b.BackgroundColor3 = v and C.Mint or Color3.fromRGB(80, 75, 100)
        b.Text = v and "ON" or "OFF"
        b.TextColor3 = v and C.Bg or C.TextDim
        l.TextColor3 = v and C.Text or C.TextDim
        st.Color = v and C.Mint or C.Border
        st.Transparency = v and 0 or 0.5
        if cb then cb(v) end
    end)

    -- Restaure automatiquement l'état au moment de l'affichage
    if current and cb then
        task.defer(function() cb(true) end)
    end
end

local function mkBtn(text, color, order, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 36)
    b.BackgroundColor3 = color or C.Purple
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.LayoutOrder = order
    corner(b, 8)
    local g = Instance.new("UIGradient")
    g.Color = ColorSequence.new(color or C.Purple, Color3.new(math.min(1, (color or C.Purple).R + 0.08), math.min(1, (color or C.Purple).G + 0.05), math.min(1, (color or C.Purple).B + 0.1)))
    g.Parent = b

    b.MouseButton1Click:Connect(function()
        if cb then cb() end
    end)
    return b
end

-- ============================================================
-- LOOPS
-- ============================================================
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
local function stopLoop(name) loops[name] = nil end
local function stopAll() for n in pairs(loops) do loops[n] = nil end end

-- ============================================================
-- AILMENTS ENGINE
-- ============================================================
local AilmentPlatform = nil
local activeAilments = {}
local processingAilment = false
local ailmentQueue = {}

local function createAilmentPlatform()
    if AilmentPlatform and AilmentPlatform.Parent then return end
    AilmentPlatform = Instance.new("Part")
    AilmentPlatform.Name = "AilmentPlatformV5"
    AilmentPlatform.Anchored = true
    AilmentPlatform.CanCollide = true
    AilmentPlatform.Size = Vector3.new(2048, 4, 2048)
    AilmentPlatform.CFrame = CFrame.new(-100000, 1000, -100000)
    AilmentPlatform.Color = Color3.fromRGB(80, 200, 120)
    AilmentPlatform.Parent = Workspace
end

local function destroyAilmentPlatform()
    if AilmentPlatform and AilmentPlatform.Parent then
        AilmentPlatform:Destroy()
        AilmentPlatform = nil
    end
end

local function getFirstPetModel()
    local pf = Workspace:FindFirstChild("Pets")
    if pf then
        for _, p in ipairs(pf:GetChildren()) do
            if p:IsA("Model") then return p end
        end
    end
end

local function findDeep(parent, name)
    for _, c in ipairs(parent:GetChildren()) do
        if c.Name == name then return c end
        if c:IsA("Folder") or c:IsA("Model") then
            local f = findDeep(c, name)
            if f then return f end
        end
    end
end

local FURNITURE = {
    hungry = "PetFoodBowl", thirsty = "PetWaterBowl",
    dirty = "CheapPetBathtub", sleepy = "BasicCrib", toilet = "Toilet",
}

local function handleAilment(inst, key)
    if processingAilment then
        table.insert(ailmentQueue, {inst, key})
        return
    end
    processingAilment = true
    local kind = inst.kind or "?"
    setStatus("🩺 Traitement: " .. kind, C.Yellow)

    pcall(function()
        createAilmentPlatform()
        local char = LP.Character or LP.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then return end

        hrp.CFrame = AilmentPlatform.CFrame * CFrame.new(0, 5, 0)
        task.wait(0.4)

        local furnName = FURNITURE[kind]
        if furnName then
            local folder = Workspace:FindFirstChild("HouseInteriors")
            folder = folder and folder:FindFirstChild("furniture")
            local item = folder and findDeep(folder, furnName)
            if item and item.Parent then
                local parts = string.split(item.Parent.Name, "/")
                local fid = parts[#parts]
                local head = char:FindFirstChild("Head")
                if head and REMOTES.ActivateFurniture then
                    REMOTES.ActivateFurniture:InvokeServer(LP, fid, "UseBlock", {cframe = head.CFrame}, getFirstPetModel())
                end
            end
        end
        task.wait(2)
    end)

    processingAilment = false
    if #ailmentQueue > 0 then
        local next_ = table.remove(ailmentQueue, 1)
        task.spawn(handleAilment, next_[1], next_[2])
    end
end

-- ============================================================
-- HAUNTLET SMART DOOR
-- ============================================================
local sessionID = nil
local badDoors = {}
local doorCycle = 1
local lastHealth = 100
local healthConn = nil

local function initHealthTracker()
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    lastHealth = hum.Health
    if healthConn then healthConn:Disconnect() end
    healthConn = hum.HealthChanged:Connect(function(h)
        if sessionID and h < lastHealth - 3 then
            local lastPicked = doorCycle == 1 and 3 or (doorCycle - 1)
            badDoors[lastPicked] = true
            setStatus("⚠️ Porte " .. lastPicked .. " = mauvaise", C.Red)
        end
        lastHealth = h
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    initHealthTracker()
end)
initHealthTracker()

local function getNextDoor()
    for i = 1, 3 do
        local d = doorCycle
        doorCycle = doorCycle % 3 + 1
        if not badDoors[d] then return d end
    end
    badDoors = {}
    return 1
end

-- Hook passif pour capter sessionID
if type(getrawmetatable) == "function" then
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        local old = mt.__namecall
        if type(setreadonly) == "function" then setreadonly(mt, false) end
        mt.__namecall = function(self, ...)
            if type(getnamecallmethod) == "function" then
                local m = getnamecallmethod()
                if (m == "FireServer" or m == "InvokeServer") and typeof(self) == "Instance" then
                    local args = {...}
                    if (self.Name == "MinigameAPI/MessageServer" or self.Name == "MinigameAPI/AttemptJoin") then
                        if args[1] and type(args[1]) == "string" and args[1]:find("^hauntlet::") then
                            if sessionID ~= args[1] then
                                sessionID = args[1]
                                badDoors = {}
                                doorCycle = 1
                            end
                        end
                    end
                end
            end
            return old(self, ...)
        end
        if type(setreadonly) == "function" then setreadonly(mt, true) end
    end)
end

-- ============================================================
-- TAB : AILMENTS
-- ============================================================
local function renderAilments()
    mkSection("🩺 BESOINS DES PETS", 1)
    mkInfo("Détecte automatiquement quand un pet a faim, soif, est sale, fatigué, malade ou a besoin de jouer. Le pet est téléporté sur une plateforme isolée et le besoin est résolu.", 2)

    mkToggle("ailments_enabled", "🩺 Activer l'auto-fix", 3, false, function(v)
        if v then
            if not AilmentsManager then
                setStatus("❌ AilmentsManager non chargé", C.Red)
                return
            end
            createAilmentPlatform()
            local conn = AilmentsManager.get_ailment_created_signal():Connect(function(inst, key)
                task.spawn(handleAilment, inst, key)
            end)
            loops["ailments_conn"] = conn
            setStatus("🩺 Auto-ailments actif")
        else
            local c = loops["ailments_conn"]
            if c and typeof(c) == "RBXScriptConnection" then c:Disconnect() end
            loops["ailments_conn"] = nil
            destroyAilmentPlatform()
            setStatus("🩺 Auto-ailments arrêté")
        end
    end)

    mkSection("🛠️ OUTILS", 4)
    mkBtn("🧹 Détruire la plateforme", C.Red, 5, function()
        destroyAilmentPlatform()
        setStatus("🧹 Plateforme détruite")
    end)

    mkInfo("Modules: Ailments=" .. (AilmentsManager and "✅" or "❌") .. "  Interiors=" .. (InteriorsM and "✅" or "❌") .. "  Data=" .. (ClientDataModule and "✅" or "❌"), 6)
end

-- ============================================================
-- TAB : HAUNTLET
-- ============================================================
local function renderHauntlet()
    mkSection("🎃 HAUNTLET 2026", 1)
    local badCount = 0
    for _ in pairs(badDoors) do badCount = badCount + 1 end
    mkInfo("Session: " .. tostring(sessionID or "aucune") .. "\nMauvaises portes: " .. badCount, 2)

    mkBtn("🎮 Rejoindre le Hauntlet", C.Purple, 3, function()
        fire(REMOTES.MiniAttemptJoin, "hauntlet", true)
        setStatus("🎮 Tentative de rejoindre...", C.Yellow)
    end)

    mkToggle("hauntlet_doors", "🚪 Smart Door Picker (évite mauvaises portes)", 4, false, function(v)
        if v then
            startLoop("hauntlet_doors", 1.2, function()
                if not sessionID then fire(REMOTES.MiniAttemptJoin, "hauntlet", true); return end
                local d = getNextDoor()
                fire(REMOTES.MiniMessageServer, sessionID, "try_pick_door", d)
            end)
            setStatus("🚪 Smart door picker ACTIF")
        else
            stopLoop("hauntlet_doors")
            setStatus("🚪 Smart door picker arrêté")
        end
    end)

    mkToggle("hauntlet_items", "🧪 Auto-use items (ghost_potion / cell_phone)", 5, false, function(v)
        if v then
            local items = {"ghost_potion", "cell_phone"}
            local idx = 1
            startLoop("hauntlet_items", 5, function()
                if not sessionID then return end
                fire(REMOTES.MiniMessageServer, sessionID, "try_use_item", items[idx])
                idx = idx % #items + 1
            end)
            setStatus("🧪 Auto-items actif")
        else
            stopLoop("hauntlet_items")
            setStatus("🧪 Auto-items arrêté")
        end
    end)

    mkToggle("hauntlet_journal", "📖 Auto-claim journal page", 6, false, function(v)
        if v then
            startLoop("hauntlet_journal", 10, function()
                fire(REMOTES.HauntletJournal)
                fire(REMOTES.CommitCollection)
            end)
            setStatus("📖 Journal actif")
        else
            stopLoop("hauntlet_journal")
            setStatus("📖 Journal arrêté")
        end
    end)

    mkSection("🛠️ OUTILS HAUNTLET", 7)
    mkBtn("🔄 Reset les mauvaises portes", C.Yellow, 8, function()
        badDoors = {}
        doorCycle = 1
        setStatus("🔄 Reset OK")
    end)
    mkBtn("🚪 Quitter le Hauntlet", C.Red, 9, function()
        if sessionID then fire(REMOTES.MiniLobbyLeave, sessionID) end
        fire(REMOTES.MiniLobbyLeave)
        sessionID = nil
        badDoors = {}
        setStatus("🚪 Quitté")
    end)
end

-- ============================================================
-- TAB : PETS
-- ============================================================
local function getPets()
    local pets = {}
    local pf = Workspace:FindFirstChild("Pets")
    if pf then
        for _, p in ipairs(pf:GetChildren()) do
            if p:IsA("Model") then table.insert(pets, p) end
        end
    end
    return pets
end

local function renderPets()
    mkSection("🐾 FOCUS PETS", 1)
    mkToggle("pets_focus", "🎯 Auto-focus pets en boucle", 2, false, function(v)
        if v then
            startLoop("pets_focus", 5, function()
                for _, p in ipairs(getPets()) do fire(REMOTES.FocusPet, p) end
            end)
            setStatus("🎯 Auto-focus actif")
        else
            stopLoop("pets_focus")
            setStatus("🎯 Auto-focus arrêté")
        end
    end)

    mkBtn("💔 Unfocus TOUS les pets", C.Red, 3, function()
        for _, p in ipairs(getPets()) do fire(REMOTES.UnfocusPet, p) end
        setStatus("💔 Pets unfocus")
    end)

    mkSection("🎁 PROGRESSION PETS", 4)
    mkToggle("pets_progression", "📈 Auto-claim progression rewards (age up)", 5, false, function(v)
        if v then
            startLoop("pets_prog", 15, function()
                fire(REMOTES.ClaimProgression)
            end)
            setStatus("📈 Progression claim actif")
        else
            stopLoop("pets_prog")
            setStatus("📈 Progression claim arrêté")
        end
    end)

    mkToggle("pets_recycler", "♻️ Auto-claim Pet Recycler tickets", 6, false, function(v)
        if v then
            startLoop("pets_recycler", 20, function()
                fire(REMOTES.TicketsCollected)
                fire(REMOTES.RewardReceived)
            end)
            setStatus("♻️ Recycler actif")
        else
            stopLoop("pets_recycler")
            setStatus("♻️ Recycler arrêté")
        end
    end)
end

-- ============================================================
-- TAB : QUÊTES
-- ============================================================
local function renderQuests()
    mkSection("🎁 QUÊTES & RÉCOMPENSES", 1)

    mkToggle("quests_ach", "✅ Auto-complete achievements", 2, false, function(v)
        if v then
            local list = {"open_backpack", "open_taskboard", "open_journal", "check_dailies", "check_pass"}
            local idx = 1
            startLoop("quests_ach", 10, function()
                fire(REMOTES.CompleteAchievement, list[idx])
                idx = idx % #list + 1
            end)
            setStatus("✅ Auto-achievements actif")
        else
            stopLoop("quests_ach")
            setStatus("✅ Auto-achievements arrêté")
        end
    end)

    mkToggle("quests_claim", "🎯 Auto-claim achievement rewards", 3, false, function(v)
        if v then
            startLoop("quests_claim", 12, function()
                fire(REMOTES.ClaimAchievement)
            end)
            setStatus("🎯 Claim rewards actif")
        else
            stopLoop("quests_claim")
            setStatus("🎯 Claim rewards arrêté")
        end
    end)

    mkToggle("quests_commit", "📖 Auto-commit journal collection", 4, false, function(v)
        if v then
            startLoop("quests_commit", 5, function() fire(REMOTES.CommitCollection) end)
            setStatus("📖 Commit actif")
        else
            stopLoop("quests_commit")
            setStatus("📖 Commit arrêté")
        end
    end)

    mkSection("📅 DAILY & LOGIN", 5)
    mkToggle("quests_login", "🎁 Auto-claim login handouts", 6, false, function(v)
        if v then
            startLoop("quests_login", 30, function() fire(REMOTES.ClaimLogin) end)
            setStatus("🎁 Login claim actif")
        else
            stopLoop("quests_login")
            setStatus("🎁 Login claim arrêté")
        end
    end)

    mkToggle("quests_bp", "🏆 Auto-claim Battle Pass rewards", 7, false, function(v)
        if v then
            startLoop("quests_bp", 20, function() fire(REMOTES.BattlePassClaim) end)
            setStatus("🏆 Battle Pass actif")
        else
            stopLoop("quests_bp")
            setStatus("🏆 Battle Pass arrêté")
        end
    end)

    mkSection("🎉 ÉVÉNEMENTS", 8)
    mkToggle("quests_events", "🎊 Auto-claim événements (like, UGC, bees, cake)", 9, false, function(v)
        if v then
            startLoop("quests_events", 15, function()
                fire(REMOTES.ClaimLike)
                fire(REMOTES.ClaimUGC)
                fire(REMOTES.ClaimBees)
                fire(REMOTES.GetBirthdayCake)
            end)
            setStatus("🎊 Événements actif")
        else
            stopLoop("quests_events")
            setStatus("🎊 Événements arrêté")
        end
    end)

    mkSection("💰 ARGENT & MAISON", 10)
    mkToggle("quests_pay", "💰 Auto-collect pay (argent au sol)", 11, false, function(v)
        if v then
            startLoop("quests_pay", 3, function() fire(REMOTES.PayCollect) end)
            setStatus("💰 Auto-pay actif")
        else
            stopLoop("quests_pay")
            setStatus("💰 Auto-pay arrêté")
        end
    end)

    mkToggle("quests_deliveries", "📦 Auto-claim deliveries (boîte aux lettres)", 12, false, function(v)
        if v then
            startLoop("quests_deliv", 20, function() fire(REMOTES.ClaimDeliveries) end)
            setStatus("📦 Deliveries actif")
        else
            stopLoop("quests_deliv")
            setStatus("📦 Deliveries arrêté")
        end
    end)
end

-- ============================================================
-- TAB : CONFIG
-- ============================================================
local function renderConfig()
    mkSection("⚙️ CONTRÔLE GÉNÉRAL", 1)

    mkBtn("⏹ Arrêter TOUS les loops", C.Red, 2, function()
        stopAll()
        destroyAilmentPlatform()
        -- Reset tous les états
        for k in pairs(state) do state[k] = false end
        clearContent()
        renderConfig()
        setStatus("⏹ Tout arrêté", C.Red)
    end)

    mkBtn("🗑 Détruire l'UI complètement", Color3.fromRGB(200, 80, 90), 3, function()
        stopAll()
        destroyAilmentPlatform()
        sg:Destroy()
    end)

    mkSection("ℹ️ INFOS", 4)
    mkInfo("Ailments=" .. (AilmentsManager and "✅" or "❌") .. "  Interiors=" .. (InteriorsM and "✅" or "❌"), 5)
    mkInfo("Session Hauntlet: " .. tostring(sessionID or "aucune"), 6)

    mkSection("💡 ACTIONS QUI MANQUENT", 7)
    mkInfo("Pour compléter l'autofarm, je dois logger ces actions Halloween :\n\n• 🍬 Candy corn pile\n• 🕷️ Tomb Spider\n• 👻 Ghost Vacuum\n• 🪶 Pigeon Jacobean\n• ⚡ Lightning Lever\n• 🐈 Stray Cat\n• 🔓 Padlock\n\nFais-les en jeu et envoie-moi le log !", 8)
end

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local tabs = {}
local function createTab(id, label, w, cb)
    local b = Instance.new("TextButton", tabBar)
    b.Size = UDim2.new(0, w, 1, 0)
    b.BackgroundColor3 = C.Card
    b.Text = label
    b.TextColor3 = C.TextDim
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    corner(b, 8)
    tabs[id] = {btn = b, cb = cb}

    b.MouseButton1Click:Connect(function()
        for tid, t in pairs(tabs) do
            if tid == id then
                t.btn.BackgroundColor3 = C.Pink
                t.btn.TextColor3 = Color3.new(1, 1, 1)
            else
                t.btn.BackgroundColor3 = C.Card
                t.btn.TextColor3 = C.TextDim
            end
        end
        clearContent()
        cb()
    end)
end

createTab("ailments", "🩺 Ailments", 88, renderAilments)
createTab("hauntlet", "🎃 Hauntlet", 82, renderHauntlet)
createTab("pets", "🐾 Pets", 60, renderPets)
createTab("quests", "🎁 Quêtes", 72, renderQuests)
createTab("config", "⚙️", 42, renderConfig)

tabs.ailments.btn.BackgroundColor3 = C.Pink
tabs.ailments.btn.TextColor3 = Color3.new(1, 1, 1)
renderAilments()

-- ============================================================
-- BOUTONS
-- ============================================================
fbtn.MouseButton1Click:Connect(function() win.Visible = not win.Visible end)
closeBtn.MouseButton1Click:Connect(function() stopAll(); win.Visible = false end)

do
    local drag, dS, sP
    fbtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dS = i.Position; sP = fbtn.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            fbtn.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
        end
    end)
end

print("[v5] ✅ PRÊT")
setStatus("✅ Prêt - choisis un onglet")