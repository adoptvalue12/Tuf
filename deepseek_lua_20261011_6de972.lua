-- ============================================================
-- ADOPT ME ULTIMATE AUTOFARM v4
-- Ailments + Hauntlet (smart) + Pets + Quêtes
-- ============================================================
print("[Autofarm v4] Init...")

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
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

print("[v4] Ailments:", AilmentsManager ~= nil, "| Interiors:", InteriorsM ~= nil, "| Data:", ClientDataModule ~= nil)

-- ============================================================
-- REMOTES
-- ============================================================
local api = RS:WaitForChild("API", 15)

local function R(path)
    if not api then return nil end
    local parts = string.split(path, "/")
    local current = api
    for _, p in ipairs(parts) do
        current = current:FindFirstChild(p)
        if not current then return nil end
    end
    return current
end

local REMOTES = {
    -- Hauntlet
    MiniAttemptJoin = R("MinigameAPI/AttemptJoin"),
    MiniMessageServer = R("MinigameAPI/MessageServer"),
    MiniLobbyLeave = R("MinigameAPI/LobbyLeave"),
    HauntletJournal = R("Halloween2026API/UnlockHauntletJournalPage"),
    CommitCollection = R("JournalAPI/CommitCollection"),
    -- Achievements
    CompleteAchievement = R("AchievementsAPI/CompleteAchievement"),
    -- Pets
    FocusPet = R("PetAPI/FocusPet"),
    UnfocusPet = R("PetAPI/UnfocusPet"),
    ConsumeFood = R("PetAPI/ConsumeFoodObject"),
    CreatePetObject = R("PetObjectAPI/CreatePetObject"),
    -- Housing / furniture
    ActivateFurniture = R("HousingAPI/ActivateFurniture"),
    -- Shop (pour sick)
    BuyItem = R("ShopAPI/BuyItem"),
}

local function fire(remote, ...)
    if not remote then return false end
    local args = {...}
    local ok = pcall(function()
        if remote.ClassName == "RemoteEvent" or remote.ClassName == "UnreliableRemoteEvent" then
            remote:FireServer(unpack(args))
        elseif remote.ClassName == "RemoteFunction" then
            remote:InvokeServer(unpack(args))
        end
    end)
    return ok
end

-- ============================================================
-- UI
-- ============================================================
local sg = Instance.new("ScreenGui")
sg.Name = "AMAutofarmV4_" .. math.random(10000, 99999)
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

local fbtn = Instance.new("TextButton")
fbtn.Size = UDim2.new(0, 50, 0, 50)
fbtn.Position = UDim2.new(0, 15, 0, 100)
fbtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
fbtn.Text = "🐾"
fbtn.TextSize = 24
fbtn.Font = Enum.Font.GothamBold
fbtn.TextColor3 = Color3.new(1, 1, 1)
fbtn.AutoButtonColor = false
fbtn.Parent = sg
Instance.new("UICorner", fbtn).CornerRadius = UDim.new(0, 25)
local fbs = Instance.new("UIStroke", fbtn)
fbs.Color = Color3.fromRGB(230, 90, 150); fbs.Thickness = 2

local win = Instance.new("Frame")
win.Size = UDim2.new(0, 400, 0, 540)
win.Position = UDim2.new(0.5, -200, 0.5, -270)
win.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = sg
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 14)
local ws = Instance.new("UIStroke", win)
ws.Color = Color3.fromRGB(255, 130, 190); ws.Thickness = 2

local hd = Instance.new("Frame", win)
hd.Size = UDim2.new(1, 0, 0, 40)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.BorderSizePixel = 0
Instance.new("UICorner", hd).CornerRadius = UDim.new(0, 14)
local hdfix = Instance.new("Frame", hd)
hdfix.Size = UDim2.new(1, 0, 0, 14)
hdfix.Position = UDim2.new(0, 0, 1, -14)
hdfix.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hdfix.BorderSizePixel = 0

local title = Instance.new("TextLabel", hd)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐾 AUTOFARM v4"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", hd)
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundTransparency = 0.7
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

-- Tabs
local tabBar = Instance.new("Frame", win)
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
tabBar.BorderSizePixel = 0
Instance.new("UICorner", tabBar).CornerRadius = UDim.new(0, 8)
local tbl = Instance.new("UIListLayout", tabBar)
tbl.FillDirection = Enum.FillDirection.Horizontal; tbl.Padding = UDim.new(0, 4)
local tbp = Instance.new("UIPadding", tabBar)
tbp.PaddingTop = UDim.new(0, 4); tbp.PaddingBottom = UDim.new(0, 4)
tbp.PaddingLeft = UDim.new(0, 4); tbp.PaddingRight = UDim.new(0, 4)

local content = Instance.new("ScrollingFrame", win)
content.Size = UDim2.new(1, -20, 1, -100)
content.Position = UDim2.new(0, 10, 0, 88)
content.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
content.BorderSizePixel = 0
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UICorner", content).CornerRadius = UDim.new(0, 10)
local cl = Instance.new("UIListLayout", content)
cl.Padding = UDim.new(0, 6); cl.SortOrder = Enum.SortOrder.LayoutOrder
local cp = Instance.new("UIPadding", content)
cp.PaddingTop = UDim.new(0, 8); cp.PaddingBottom = UDim.new(0, 8)
cp.PaddingLeft = UDim.new(0, 8); cp.PaddingRight = UDim.new(0, 8)

local status = Instance.new("TextLabel", win)
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 1, -28)
status.BackgroundTransparency = 1
status.Text = "Prêt"
status.TextColor3 = Color3.fromRGB(120, 220, 150)
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left

-- Helpers
local function clearContent()
    for _, c in ipairs(content:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
end

local function mkLabel(text, order, bg)
    local l = Instance.new("TextLabel", content)
    l.Size = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundColor3 = bg or Color3.fromRGB(60, 60, 80)
    l.BorderSizePixel = 0
    l.Text = "  " .. text
    l.TextColor3 = Color3.fromRGB(220, 220, 240)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.LayoutOrder = order
    Instance.new("UICorner", l).CornerRadius = UDim.new(0, 6)
    local p = Instance.new("UIPadding", l)
    p.PaddingTop = UDim.new(0, 6); p.PaddingBottom = UDim.new(0, 6)
    p.PaddingLeft = UDim.new(0, 8); p.PaddingRight = UDim.new(0, 8)
end

local function mkToggle(text, order, def, cb)
    local h = Instance.new("Frame", content)
    h.Size = UDim2.new(1, 0, 0, 34)
    h.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    h.BorderSizePixel = 0
    h.LayoutOrder = order
    Instance.new("UICorner", h).CornerRadius = UDim.new(0, 8)

    local l = Instance.new("TextLabel", h)
    l.Size = UDim2.new(1, -80, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(220, 220, 240)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left

    local state = def
    local b = Instance.new("TextButton", h)
    b.Size = UDim2.new(0, 55, 0, 24)
    b.Position = UDim2.new(1, -62, 0.5, -12)
    b.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
    b.Text = state and "ON" or "OFF"
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)

    b.MouseButton1Click:Connect(function()
        state = not state
        b.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
        b.Text = state and "ON" or "OFF"
        if cb then cb(state) end
    end)
end

local function mkBtn(text, color, order, cb)
    local b = Instance.new("TextButton", content)
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = color or Color3.fromRGB(180, 140, 240)
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.AutoButtonColor = false
    b.LayoutOrder = order
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
    b.MouseButton1Click:Connect(function() if cb then cb() end end)
    return b
end

-- Loops
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
-- TAB 1 : AILMENTS (reprend ton ancien script)
-- ============================================================
local AilmentPlatform = nil
local activeAilments = {}
local processingAilment = false

local function createAilmentPlatform()
    if AilmentPlatform and AilmentPlatform.Parent then return end
    AilmentPlatform = Instance.new("Part")
    AilmentPlatform.Name = "AilmentPlatformV4"
    AilmentPlatform.Anchored = true
    AilmentPlatform.CanCollide = true
    AilmentPlatform.Size = Vector3.new(2048, 4, 2048)
    AilmentPlatform.CFrame = CFrame.new(-100000, 1000, -100000)
    AilmentPlatform.Color = Color3.fromRGB(80, 200, 120)
    AilmentPlatform.Parent = Workspace
end

local function getFirstPetModel()
    local petsFolder = Workspace:FindFirstChild("Pets")
    if petsFolder then
        for _, p in ipairs(petsFolder:GetChildren()) do
            if p:IsA("Model") then return p end
        end
    end
    return nil
end

local function findDeep(parent, name)
    for _, c in ipairs(parent:GetChildren()) do
        if c.Name == name then return c end
        if c:IsA("Folder") or c:IsA("Model") then
            local f = findDeep(c, name)
            if f then return f end
        end
    end
    return nil
end

-- Handler générique basé sur ton ancien script
local FURNITURE_MAP = {
    hungry = "PetFoodBowl",
    thirsty = "PetWaterBowl",
    dirty = "CheapPetBathtub",
    sleepy = "BasicCrib",
    toilet = "Toilet",
}

local function handleAilment(ailmentInstance, entityKey)
    if processingAilment then return end
    processingAilment = true
    local kind = ailmentInstance.kind or "unknown"
    status.Text = "🩺 Traitement: " .. kind

    local ok, err = pcall(function()
        createAilmentPlatform()

        local char = LP.Character or LP.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not hrp then processingAilment = false; return end

        -- TP sur la plateforme
        local target = AilmentPlatform.CFrame * CFrame.new(0, 5, 0)
        hrp.CFrame = target

        task.wait(0.5)

        local furnitureName = FURNITURE_MAP[kind]
        if furnitureName then
            local furn = Workspace:FindFirstChild("HouseInteriors")
            if furn then furn = furn:FindFirstChild("furniture") end
            local item = furn and findDeep(furn, furnitureName)
            if item and item.Parent then
                local parts = string.split(item.Parent.Name, "/")
                local fid = parts[#parts]
                local head = char:FindFirstChild("Head")
                if head and REMOTES.ActivateFurniture then
                    REMOTES.ActivateFurniture:InvokeServer(
                        LP, fid, "UseBlock",
                        {cframe = head.CFrame},
                        getFirstPetModel()
                    )
                end
            end
        end

        task.wait(2)
    end)

    if not ok then warn("[Ailment] " .. tostring(err)) end
    processingAilment = false
end

local function renderAilments()
    mkLabel("🩺 AILMENTS (besoins des pets)", 1, Color3.fromRGB(255, 200, 240))
    mkLabel("Auto-détecte et règle: faim, soif, sale, fatigué, toilettes, jeu", 2, Color3.fromRGB(60, 60, 80))

    mkToggle("🩺 Auto-fix ailments (via ton ancien script)", 3, false, function(v)
        if v then
            if not AilmentsManager then
                status.Text = "❌ AilmentsManager non chargé"
                return
            end
            createAilmentPlatform()
            local conn = AilmentsManager.get_ailment_created_signal():Connect(function(inst, key)
                task.spawn(handleAilment, inst, key)
            end)
            loops["ailments_conn"] = conn
            status.Text = "🩺 Auto-ailments activé"
        else
            local c = loops["ailments_conn"]
            if c and typeof(c) == "RBXScriptConnection" then c:Disconnect() end
            loops["ailments_conn"] = nil
            if AilmentPlatform then AilmentPlatform:Destroy(); AilmentPlatform = nil end
            status.Text = "🩺 Auto-ailments arrêté"
        end
    end)

    mkBtn("🧹 Détruire la plateforme", Color3.fromRGB(255, 120, 130), 4, function()
        if AilmentPlatform then AilmentPlatform:Destroy(); AilmentPlatform = nil end
        status.Text = "🧹 Plateforme détruite"
    end)

    mkLabel("Statut modules:", 5, Color3.fromRGB(60, 60, 80))
    mkLabel("Ailments: " .. (AilmentsManager and "✅" or "❌") .. " | Interiors: " .. (InteriorsM and "✅" or "❌") .. " | Data: " .. (ClientDataModule and "✅" or "❌"), 6, Color3.fromRGB(60, 60, 80))
end

-- ============================================================
-- TAB 2 : HAUNTLET (smart door picker)
-- ============================================================
local sessionID = nil
local badDoors = {} -- { doorNumber = true }
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
            -- On vient de perdre de la vie → la dernière porte était mauvaise
            local lastPicked = doorCycle == 1 and 3 or (doorCycle - 1)
            badDoors[lastPicked] = true
            status.Text = "⚠️ Porte " .. lastPicked .. " = MAUVAISE (ajoutée au skip)"
        end
        lastHealth = h
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(1)
    initHealthTracker()
end)
initHealthTracker()

local function getNextGoodDoor()
    for i = 1, 3 do
        local d = doorCycle
        doorCycle = doorCycle % 3 + 1
        if not badDoors[d] then return d end
    end
    -- Toutes mauvaises → reset (session a probablement changé)
    badDoors = {}
    return 1
end

local function renderHauntlet()
    mkLabel("🎃 HAUNTLET 2026", 1, Color3.fromRGB(255, 180, 220))
    mkLabel("Session: " .. tostring(sessionID or "aucune"), 2, Color3.fromRGB(60, 60, 80))
    mkLabel("Mauvaises portes trouvées: " .. tostring((function() local n=0 for _ in pairs(badDoors) do n=n+1 end return n end)()), 3, Color3.fromRGB(60, 60, 80))

    mkBtn("🎮 Rejoindre le Hauntlet", Color3.fromRGB(180, 140, 240), 4, function()
        fire(REMOTES.MiniAttemptJoin, "hauntlet", true)
        status.Text = "🎮 Tentative de rejoindre..."
    end)

    mkToggle("🚪 Auto-pick door INTELLIGENT (évite les mauvaises)", 5, false, function(v)
        if v then
            startLoop("hauntlet_doors", 1.2, function()
                if not sessionID then
                    fire(REMOTES.MiniAttemptJoin, "hauntlet", true)
                    return
                end
                local d = getNextGoodDoor()
                fire(REMOTES.MiniMessageServer, sessionID, "try_pick_door", d)
            end)
            status.Text = "🚪 Smart door picker activé"
        else
            stopLoop("hauntlet_doors")
            status.Text = "🚪 Smart door picker arrêté"
        end
    end)

    mkToggle("🧪 Auto-use items (ghost_potion / cell_phone)", 6, false, function(v)
        if v then
            local items = {"ghost_potion", "cell_phone"}
            local idx = 1
            startLoop("hauntlet_items", 5, function()
                if not sessionID then return end
                fire(REMOTES.MiniMessageServer, sessionID, "try_use_item", items[idx])
                idx = idx % #items + 1
            end)
            status.Text = "🧪 Auto-items activé"
        else
            stopLoop("hauntlet_items")
            status.Text = "🧪 Auto-items arrêté"
        end
    end)

    mkToggle("📖 Auto-claim journal page", 7, false, function(v)
        if v then
            startLoop("hauntlet_journal", 10, function()
                fire(REMOTES.HauntletJournal)
                fire(REMOTES.CommitCollection)
            end)
            status.Text = "📖 Journal activé"
        else
            stopLoop("hauntlet_journal")
            status.Text = "📖 Journal arrêté"
        end
    end)

    mkBtn("🔄 Reset les mauvaises portes", Color3.fromRGB(255, 200, 100), 8, function()
        badDoors = {}
        doorCycle = 1
        status.Text = "🔄 Bad doors reset"
    end)

    mkBtn("🚪 Quitter le Hauntlet", Color3.fromRGB(255, 120, 130), 9, function()
        if sessionID then fire(REMOTES.MiniLobbyLeave, sessionID) end
        fire(REMOTES.MiniLobbyLeave)
        sessionID = nil
        badDoors = {}
        status.Text = "🚪 Quitté le Hauntlet"
    end)
end

-- Hook pour capter sessionID automatiquement
local hasGetRawMeta = type(getrawmetatable) == "function"
local hasGetNamecall = type(getnamecallmethod) == "function"
if hasGetRawMeta then
    pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end
        local old = mt.__namecall
        if type(setreadonly) == "function" then setreadonly(mt, false) end
        mt.__namecall = function(self, ...)
            local method = hasGetNamecall and getnamecallmethod() or ""
            if method == "FireServer" or method == "InvokeServer" then
                if typeof(self) == "Instance" then
                    local args = {...}
                    if self.Name == "MinigameAPI/MessageServer" or self.Name == "MinigameAPI/AttemptJoin" then
                        if args[1] and type(args[1]) == "string" and args[1]:find("^hauntlet::") then
                            if sessionID ~= args[1] then
                                sessionID = args[1]
                                badDoors = {} -- nouvelle session → reset
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
-- TAB 3 : PETS
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
    mkLabel("🐾 PETS", 1, Color3.fromRGB(255, 200, 240))

    mkToggle("🎯 Auto-focus pets en boucle", 2, false, function(v)
        if v then
            startLoop("pets_focus", 5, function()
                for _, p in ipairs(getPets()) do
                    fire(REMOTES.FocusPet, p)
                end
            end)
            status.Text = "🎯 Auto-focus activé"
        else
            stopLoop("pets_focus")
            status.Text = "🎯 Auto-focus arrêté"
        end
    end)

    mkBtn("💔 Unfocus TOUS les pets", Color3.fromRGB(255, 120, 130), 3, function()
        for _, p in ipairs(getPets()) do
            fire(REMOTES.UnfocusPet, p)
        end
        status.Text = "💔 Pets unfocus"
    end)
end

-- ============================================================
-- TAB 4 : QUÊTES
-- ============================================================
local function renderQuests()
    mkLabel("🎁 QUÊTES", 1, Color3.fromRGB(255, 200, 240))

    mkToggle("✅ Auto-complete achievements", 2, false, function(v)
        if v then
            local list = {"open_backpack", "open_taskboard", "open_journal", "check_dailies"}
            local idx = 1
            startLoop("quests_ach", 8, function()
                fire(REMOTES.CompleteAchievement, list[idx])
                idx = idx % #list + 1
            end)
            status.Text = "✅ Auto-achievements activé"
        else
            stopLoop("quests_ach")
            status.Text = "✅ Auto-achievements arrêté"
        end
    end)

    mkToggle("📖 Auto-commit journal", 3, false, function(v)
        if v then
            startLoop("quests_commit", 5, function()
                fire(REMOTES.CommitCollection)
            end)
            status.Text = "📖 Auto-commit activé"
        else
            stopLoop("quests_commit")
            status.Text = "📖 Auto-commit arrêté"
        end
    end)
end

-- ============================================================
-- TAB 5 : CONFIG
-- ============================================================
local function renderConfig()
    mkLabel("⚙️ CONFIG", 1, Color3.fromRGB(255, 200, 240))

    mkBtn("⏹ Arrêter tous les loops", Color3.fromRGB(255, 120, 130), 2, function()
        stopAll()
        if AilmentPlatform then AilmentPlatform:Destroy(); AilmentPlatform = nil end
        status.Text = "⏹ Tout arrêté"
    end)

    mkBtn("🗑 Détruire l'UI", Color3.fromRGB(200, 80, 90), 3, function()
        stopAll()
        if AilmentPlatform then AilmentPlatform:Destroy() end
        sg:Destroy()
    end)
end

-- ============================================================
-- TAB SYSTEM
-- ============================================================
local tabs = {}
local function createTab(id, label, w, cb)
    local b = Instance.new("TextButton", tabBar)
    b.Size = UDim2.new(0, w, 1, 0)
    b.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    b.Text = label
    b.TextColor3 = Color3.fromRGB(200, 200, 220)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.AutoButtonColor = false
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 6)
    tabs[id] = {btn = b, cb = cb}
    b.MouseButton1Click:Connect(function()
        for tid, t in pairs(tabs) do
            if tid == id then
                t.btn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
                t.btn.TextColor3 = Color3.new(1, 1, 1)
            else
                t.btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
                t.btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            end
        end
        clearContent()
        cb()
    end)
end

createTab("ailments", "🩺", 50, renderAilments)
createTab("hauntlet", "🎃 Hauntlet", 90, renderHauntlet)
createTab("pets", "🐾 Pets", 70, renderPets)
createTab("quests", "🎁 Quêtes", 75, renderQuests)
createTab("config", "⚙️", 50, renderConfig)

tabs.ailments.btn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
tabs.ailments.btn.TextColor3 = Color3.new(1, 1, 1)
renderAilments()

-- ============================================================
-- Float btn
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
    game:GetService("UserInputService").InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            fbtn.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
        end
    end)
end

print("[Autofarm v4] ✅ PRÊT")
status.Text = "✅ Prêt"