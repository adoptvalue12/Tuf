-- Adopt Me Ultimate Autofarm V1 (basé sur les remotes réels)
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local SS = game:GetService("SoundService")
local LP = Players.LocalPlayer

-- ================================================================
-- REMOTE CACHE (chemins réels du jeu)
-- ================================================================
local REMOTES = {
    -- PETS
    FlyPet           = "ReplicatedStorage.API.AdoptAPI/FlyPet",
    RidePet          = "ReplicatedStorage.API.AdoptAPI/RidePet",
    FocusPet         = "ReplicatedStorage.API.AdoptAPI/FocusPet",
    UnfocusPet       = "ReplicatedStorage.API.AdoptAPI/UnfocusPet",
    UseStroller      = "ReplicatedStorage.API.AdoptAPI/UseStroller",
    HoldBaby         = "ReplicatedStorage.API.AdoptAPI/HoldBaby",
    EquipPetLeash    = "ReplicatedStorage.API.PetAPI/EquipPetLeash",
    UnequipPetLeash  = "ReplicatedStorage.API.PetAPI/UnequipPetLeash",
    DoNeonFusion     = "ReplicatedStorage.API.PetAPI/DoNeonFusion",
    ClaimPetReward   = "ReplicatedStorage.API.PetAPI/ClaimProgressionReward",
    PetHatched       = "ReplicatedStorage.API.PetAPI/PetHatched",
    MarkHatched      = "ReplicatedStorage.API.PetAPI/MarkHatched",
    PetPetted        = "ReplicatedStorage.API.PetAPI/PetPetted",
    ConsumeFood      = "ReplicatedStorage.API.PetAPI/ConsumeFoodObject",
    -- POTIONS
    DrinkGrow        = "ReplicatedStorage.API.EffectsAPI/DrinkGrowPotion",
    DrinkBigHead     = "ReplicatedStorage.API.EffectsAPI/DrinkBigHeadPotion",
    DrinkCureAll     = "ReplicatedStorage.API.EffectsAPI/DrinkCureAllPotion",
    -- PET RECYCLER
    TicketsCollected = "ReplicatedStorage.API.PetRecyclerAPI/TicketsCollected",
    PetsReleased     = "ReplicatedStorage.API.PetRecyclerAPI/PetsReleased",
    RewardReceived   = "ReplicatedStorage.API.PetRecyclerAPI/RewardReceived",
    -- HALLOWEEN 2026
    CandyCornClaim   = "ReplicatedStorage.adoptme_new_net.Halloween2026/CandyCornPileClaim",
    ClaimTombSpider  = "ReplicatedStorage.adoptme_new_net.Halloween2026/ClaimTombSpider",
    GhostVacuumFire  = "ReplicatedStorage.adoptme_new_net.Halloween2026/GhostVacuumToyFire",
    JacobeanTwig     = "ReplicatedStorage.adoptme_new_net.Halloween2026/JacobeanPigeonNestContributeTwig",
    LightningActivate= "ReplicatedStorage.adoptme_new_net.Halloween2026/LightningLeverActivate",
    LightningDeliver = "ReplicatedStorage.adoptme_new_net.Halloween2026/LightningLeverDeliver",
    StrayCatGift     = "ReplicatedStorage.adoptme_new_net.Halloween2026/StrayCatGiftFood",
    UnlockPadlock    = "ReplicatedStorage.adoptme_new_net.Halloween2026/UnlockPadlock",
    UnlockJournal    = "ReplicatedStorage.API.Halloween2026API/UnlockHauntletJournalPage",
    -- HOUSING
    ClaimDeliveries  = "ReplicatedStorage.API.HousingAPI/ClaimAllDeliveries",
    ActivateFurniture= "ReplicatedStorage.API.HousingAPI/ActivateFurniture",
    BuyFurniture     = "ReplicatedStorage.API.HousingAPI/BuyFurnitures",
    -- ACHIEVEMENTS
    ClaimAchievement = "ReplicatedStorage.API.AchievementsAPI/ClaimReward",
    CompleteAchieve  = "ReplicatedStorage.API.AchievementsAPI/CompleteAchievement",
    -- BATTLE PASS
    BattlePassClaim  = "ReplicatedStorage.API.BattlePassAPI/ClaimReward",
    -- EVENT
    ClaimLike        = "ReplicatedStorage.API.EventAPI/ClaimLikeReward",
    ClaimUGC         = "ReplicatedStorage.API.EventAPI/ClaimUGCLinkedItems",
    ClaimBees        = "ReplicatedStorage.API.EventAPI/ClaimBeesBlaster",
    GetBirthdayCake  = "ReplicatedStorage.API.EventAPI/GetBirthdayCake",
    StartObby        = "ReplicatedStorage.API.EventAPI/StartObby",
    -- PAY
    PayCollect       = "ReplicatedStorage.API.PayAPI/Collect",
    -- SHOP
    BuyItem          = "ReplicatedStorage.API.ShopAPI/BuyItem",
    OpenGift         = "ReplicatedStorage.API.ShopAPI/OpenGift",
    -- UGC
    ClaimCollector   = "ReplicatedStorage.API.UGCAPI/ClaimCollectorReward",
    -- LOOT
    ClaimLogin       = "ReplicatedStorage.API.LootBoxAPI/ClaimLoginHandouts",
    ExchangeItem     = "ReplicatedStorage.API.LootBoxAPI/ExchangeItemForReward",
    -- CODE
    RedeemCode       = "ReplicatedStorage.API.CodeRedemptionAPI/AttemptRedeemCode",
    -- TRADE
    AddItemTrade     = "ReplicatedStorage.API.TradeAPI/AddItemToOffer",
    RemoveItemTrade  = "ReplicatedStorage.API.TradeAPI/RemoveItemFromOffer",
    ConfirmTrade     = "ReplicatedStorage.API.TradeAPI/ConfirmTrade",
    SendTradeRequest = "ReplicatedStorage.API.TradeAPI/SendTradeRequest",
    AcceptTrade      = "ReplicatedStorage.API.TradeAPI/AcceptOrDeclineTradeRequest",
    BeginQuiz        = "ReplicatedStorage.API.TradeAPI/BeginQuiz",
    EndQuiz          = "ReplicatedStorage.API.TradeAPI/EndQuiz",
    AnswerQuiz       = "ReplicatedStorage.API.TradeAPI/AnswerQuizQuestion",
    GetTradeHistory  = "ReplicatedStorage.API.TradeAPI/GetTradeHistory",
    -- TELEPORT
    TeleToLocation   = "ReplicatedStorage.API.LocationAPI/TeleToLocation",
    TeleToPlayer     = "ReplicatedStorage.API.LocationAPI/TeleToPlayer",
    SetLocation      = "ReplicatedStorage.API.LocationAPI/SetLocation",
    GetLocations     = "ReplicatedStorage.API.LocationAPI/GetLocations",
    GetPlayerCFrame  = "ReplicatedStorage.API.LocationAPI/GetPlayerCFrame",
    -- FAMILY
    CreateFamily     = "ReplicatedStorage.API.FamilyAPI/CreateFamily",
    InviteFamily     = "ReplicatedStorage.API.FamilyAPI/InvitePlayer",
    -- MICROGAME/MINIGAME
    LobbyJoin        = "ReplicatedStorage.API.MinigameAPI/LobbyJoin",
    LobbyCreate      = "ReplicatedStorage.API.MinigameAPI/LobbyCreate",
    FinishObby       = "ReplicatedStorage.API.MinigameAPI/FinishObby",
    -- MISC
    PlayEmote        = "ReplicatedStorage.API.EmotesAPI/PlayEmote",
    SetSetting       = "ReplicatedStorage.API.SettingsAPI/SetSetting",
}

local remoteCache = {}

local function findRemote(path)
    if remoteCache[path] then return remoteCache[path] end
    local current = RS
    local parts = string.split(path, ".")
    for i, part in ipairs(parts) do
        if i == 1 then
            if part ~= "ReplicatedStorage" then return nil end
        else
            local slashParts = string.split(part, "/")
            if #slashParts == 2 then
                local folder = current:FindFirstChild(slashParts[1])
                if not folder then return nil end
                local remote = folder:FindFirstChild(slashParts[2])
                if not remote then return nil end
                current = remote
            else
                local next_ = current:FindFirstChild(part)
                if not next_ then return nil end
                current = next_
            end
        end
    end
    remoteCache[path] = current
    return current
end

local function fire(name, ...)
    local path = REMOTES[name]
    if not path then return false, "remote inconnu: "..name end
    local remote = findRemote(path)
    if not remote then return false, "remote introuvable: "..path end
    local ok, err = pcall(function()
        if remote:IsA("RemoteEvent") then
            remote:FireServer(...)
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(...)
        end
    end)
    return ok, err
end

-- ================================================================
-- SONS
-- ================================================================
local SND = {
    Click="rbxassetid://6895086596", Success="rbxassetid://9118823103",
    Pop="rbxassetid://6042053627", Chime="rbxassetid://5873524714",
    Error="rbxassetid://5873524714",
}
local function playSnd(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 0.5; s.Parent = SS
        s:Play(); task.delay(3, function() s:Destroy() end)
    end)
end

-- ================================================================
-- UI RECTANGULAIRE
-- ================================================================
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local sg = Instance.new("ScreenGui")
sg.Name = "AMAutofarmV1_"..math.random(10000,99999)
sg.ResetOnSpawn = false
sg.Parent = parentGui

-- Toggle flottant
local floatBtn = Instance.new("TextButton")
floatBtn.Size = UDim2.new(0, 50, 0, 50)
floatBtn.Position = UDim2.new(0, 15, 0.5, -25)
floatBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
floatBtn.Text = "🐾"
floatBtn.TextSize = 24
floatBtn.Font = Enum.Font.GothamBold
floatBtn.TextColor3 = Color3.new(1, 1, 1)
floatBtn.AutoButtonColor = false
floatBtn.Parent = sg
local fbc = Instance.new("UICorner"); fbc.CornerRadius = UDim.new(0, 25); fbc.Parent = floatBtn
local fbs = Instance.new("UIStroke"); fbs.Color = Color3.fromRGB(230, 90, 150); fbs.Thickness = 2; fbs.Parent = floatBtn

-- Fenêtre RECTANGULAIRE (paysage)
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 620, 0, 340)
win.Position = UDim2.new(0.5, -310, 0.5, -170)
win.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = sg
local wc = Instance.new("UICorner"); wc.CornerRadius = UDim.new(0, 14); wc.Parent = win
local ws = Instance.new("UIStroke"); ws.Color = Color3.fromRGB(255, 130, 190); ws.Thickness = 2; ws.Parent = win

-- Header
local hd = Instance.new("Frame")
hd.Size = UDim2.new(1, 0, 0, 40)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.BorderSizePixel = 0
hd.Parent = win
local hdc = Instance.new("UICorner"); hdc.CornerRadius = UDim.new(0, 14); hdc.Parent = hd
local hdfix = Instance.new("Frame"); hdfix.Size = UDim2.new(1, 0, 0, 14); hdfix.Position = UDim2.new(0, 0, 1, -14); hdfix.BackgroundColor3 = Color3.fromRGB(255, 130, 190); hdfix.BorderSizePixel = 0; hdfix.Parent = hd

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🐾  ADOPT ME AUTOFARM"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBlack
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = hd

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -36, 0, 6)
closeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
closeBtn.BackgroundTransparency = 0.75
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = hd
local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 8); cbc.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function()
    sg.Enabled = false
end)

-- Sidebar (onglets verticaux)
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 150, 1, -50)
sidebar.Position = UDim2.new(0, 10, 0, 48)
sidebar.BackgroundColor3 = Color3.fromRGB(255, 235, 248)
sidebar.BorderSizePixel = 0
sidebar.Parent = win
local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0, 10); sbc.Parent = sidebar
local sbl = Instance.new("UIListLayout"); sbl.Padding = UDim.new(0, 4); sbl.SortOrder = Enum.SortOrder.LayoutOrder; sbl.Parent = sidebar
local sbp = Instance.new("UIPadding"); sbp.PaddingTop = UDim.new(0, 6); sbp.PaddingBottom = UDim.new(0, 6); sbp.PaddingLeft = UDim.new(0, 6); sbp.PaddingRight = UDim.new(0, 6); sbp.Parent = sidebar

-- Content area
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -172, 1, -58)
content.Position = UDim2.new(0, 162, 0, 48)
content.BackgroundColor3 = Color3.new(1, 1, 1)
content.BorderSizePixel = 0
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = win
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 10); cc.Parent = content
local cs = Instance.new("UIStroke"); cs.Color = Color3.fromRGB(255, 200, 230); cs.Thickness = 1; cs.Parent = content
local cl = Instance.new("UIListLayout"); cl.Padding = UDim.new(0, 6); cl.SortOrder = Enum.SortOrder.LayoutOrder; cl.Parent = content
local cp = Instance.new("UIPadding"); cp.PaddingTop = UDim.new(0, 8); cp.PaddingBottom = UDim.new(0, 8); cp.PaddingLeft = UDim.new(0, 8); cp.PaddingRight = UDim.new(0, 8); cp.Parent = content

-- Helpers UI
local function makeBtn(text, color, order, parent, height)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, -4, 0, height or 32)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.LayoutOrder = order
    b.AutoButtonColor = false
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
    return b
end

local function makeToggle(text, order, defaultState, callback)
    local holder = Instance.new("Frame")
    holder.Size = UDim2.new(1, -4, 0, 32)
    holder.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
    holder.BorderSizePixel = 0
    holder.LayoutOrder = order
    holder.Parent = content
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 8); hc.Parent = holder
    local hs = Instance.new("UIStroke"); hs.Color = Color3.fromRGB(255, 200, 230); hs.Thickness = 1; hs.Parent = holder

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -70, 1, 0)
    lbl.Position = UDim2.new(0, 12, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(80, 50, 100)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = holder

    local state = defaultState
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 50, 0, 22)
    btn.Position = UDim2.new(1, -58, 0.5, -11)
    btn.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
    btn.Text = state and "ON" or "OFF"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.Parent = holder
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn

    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(200, 200, 200)
        btn.Text = state and "ON" or "OFF"
        playSnd(SND.Click, 0.2)
        if callback then callback(state) end
    end)
    return holder
end

local function makeLabel(text, color, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -4, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundColor3 = color or Color3.fromRGB(255, 235, 248)
    l.BorderSizePixel = 0
    l.Text = "  "..text
    l.TextColor3 = Color3.fromRGB(80, 50, 100)
    l.Font = Enum.Font.GothamBold
    l.TextSize = 11
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.LayoutOrder = order
    l.Parent = content
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = l
    local p = Instance.new("UIPadding"); p.PaddingTop = UDim.new(0, 5); p.PaddingBottom = UDim.new(0, 5); p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6); p.Parent = l
    return l
end

-- ================================================================
-- TABS SYSTEM
-- ================================================================
local tabs = {}
local currentTab = nil
local function clearContent()
    for _, ch in ipairs(content:GetChildren()) do
        if ch:IsA("GuiObject") then ch:Destroy() end
    end
end

local function createTab(id, label, callback)
    local btn = makeBtn(label, Color3.fromRGB(255, 235, 248), #tabs+1, sidebar, 30)
    btn.TextColor3 = Color3.fromRGB(140, 100, 180)
    tabs[id] = {btn = btn, callback = callback}
    btn.MouseButton1Click:Connect(function()
        currentTab = id
        for tid, t in pairs(tabs) do
            if tid == id then
                t.btn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
                t.btn.TextColor3 = Color3.new(1, 1, 1)
            else
                t.btn.BackgroundColor3 = Color3.fromRGB(255, 235, 248)
                t.btn.TextColor3 = Color3.fromRGB(140, 100, 180)
            end
        end
        clearContent()
        playSnd(SND.Click, 0.2)
        callback()
    end)
    return btn
end

-- ================================================================
-- ESP SYSTEM (client-side, toujours fonctionnel)
-- ================================================================
local espEnabled = false
local espPetsEnabled = false
local espPlayersEnabled = false
local espBoxEnabled = false
local espDrawings = {}

local function clearEsp()
    for _, d in ipairs(espDrawings) do
        pcall(function() d:Remove() end)
    end
    espDrawings = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local h = p.Character:FindFirstChild("Humanoid")
            if h then pcall(function() h.NameDisplayDistance = 0 end) end
            local hl = p.Character:FindFirstChild("AMESP_HL")
            if hl then hl:Destroy() end
        end
    end
end

local function createEspFor(part, color, name, isPet)
    if not part then return end
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Color = color
    box.Filled = false
    box.Transparency = 1
    table.insert(espDrawings, box)

    local lbl = Drawing.new("Text")
    lbl.Size = 13
    lbl.Center = true
    lbl.Outline = true
    lbl.OutlineColor = Color3.new(0, 0, 0)
    lbl.Color = color
    lbl.Text = name or ""
    lbl.Transparency = 1
    table.insert(espDrawings, lbl)

    local conn
    conn = RunService.RenderStepped:Connect(function()
        if not espEnabled then
            box.Visible = false; lbl.Visible = false; return
        end
        if not part.Parent then
            box.Visible = false; lbl.Visible = false
            if conn then conn:Disconnect() end
            return
        end
        local pos, onScreen = game:GetService("Workspace").CurrentCamera:WorldToViewportPoint(part.Position)
        if onScreen then
            local scale = 1 / pos.Z * 100
            local size = Vector2.new(scale * 1.2, scale * 1.8)
            box.Size = size
            box.Position = Vector2.new(pos.X - size.X/2, pos.Y - size.Y/2)
            box.Visible = espBoxEnabled
            lbl.Position = Vector2.new(pos.X, pos.Y - size.Y/2 - 14)
            lbl.Visible = true
        else
            box.Visible = false; lbl.Visible = false
        end
    end)
end

local function isPetModel(model)
    if not model:FindFirstChild("Humanoid") then return false end
    local name = model.Name:lower()
    -- Pets in Adopt Me typically have a "Pet" attribute or specific tag
    return model:GetAttribute("Pet") ~= nil or name:find("pet") or model:FindFirstChild("PetOwner")
end

local function refreshEsp()
    clearEsp()
    if not espEnabled then return end
    -- Players
    if espPlayersEnabled then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                if hrp then createEspFor(hrp, Color3.fromRGB(255, 80, 80), p.Name, false) end
            end
        end
    end
    -- Pets
    if espPetsEnabled then
        for _, obj in ipairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and isPetModel(obj) then
                local hrp = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                if hrp then createEspFor(hrp, Color3.fromRGB(120, 220, 150), obj.Name, true) end
            end
        end
    end
end

-- ================================================================
-- FARM LOOPS
-- ================================================================
local loops = {}

local function startLoop(name, interval, fn)
    if loops[name] then return end
    loops[name] = task.spawn(function()
        while loops[name] do
            pcall(fn)
            task.wait(interval)
        end
    end)
end

local function stopLoop(name)
    if loops[name] then
        loops[name] = nil
    end
end

-- ================================================================
-- TAB 1 : FARM
-- ================================================================
local autoClaim, autoFarmPets, autoHalloween, autoRecycler, autoTrade

createTab("farm", "🌾 Farm", function()
    makeLabel("🌾 Farm automatique", Color3.fromRGB(220, 240, 255), 1)

    makeToggle("Auto-claim rewards (achievements/events/daily)", 2, false, function(v)
        autoClaim = v
        if v then
            startLoop("claim", 5, function()
                fire("ClaimAchievement")
                fire("ClaimLogin")
                fire("ClaimLike")
                fire("BattlePassClaim")
                fire("ClaimUGC")
                fire("ClaimCollector")
                fire("ClaimDeliveries")
            end)
            playSnd(SND.Success, 0.5)
        else
            stopLoop("claim")
        end
    end)

    makeToggle("Auto-collect pay (argent sur le sol)", 3, false, function(v)
        if v then
            startLoop("pay", 2, function()
                fire("PayCollect")
            end)
        else
            stopLoop("pay")
        end
    end)

    makeToggle("Auto-farm pets (feed, pet, progression)", 4, false, function(v)
        autoFarmPets = v
        if v then
            startLoop("farmpets", 3, function()
                -- Focus tous les pets proches
                for _, obj in ipairs(workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj:GetAttribute("Pet") then
                        pcall(function()
                            fire("FocusPet", obj)
                            fire("PetPetted", obj)
                            fire("ConsumeFood", obj)
                        end)
                    end
                end
                fire("ClaimPetReward")
            end)
        else
            stopLoop("farmpets")
        end
    end)

    makeToggle("Auto pet recycler (tickets)", 5, false, function(v)
        if v then
            startLoop("recycler", 10, function()
                fire("TicketsCollected")
                fire("RewardReceived")
            end)
        else
            stopLoop("recycler")
        end
    end)

    makeButton = nil
    local refreshBtn = makeBtn("🔄 Lancer un scan complet", Color3.fromRGB(180, 140, 240), 6, content, 34)
    refreshBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.5)
        makeLabel("✅ Scan OK - "..#(function()
            local c = {}
            for _, p in pairs(REMOTES) do table.insert(c, p) end
            return c
        end)().." remotes mappés", Color3.fromRGB(220, 240, 255), 6)
    end)
end)

-- ================================================================
-- TAB 2 : PETS
-- ================================================================
createTab("pets", "🐶 Pets", function()
    makeLabel("🐶 Actions sur les pets", Color3.fromRGB(255, 220, 240), 1)

    local flyBtn = makeBtn("🦅 Fly tous les pets équipés", Color3.fromRGB(120, 200, 240), 2, content, 32)
    flyBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("FlyPet")
        makeLabel("🦅 FlyPet envoyé", Color3.fromRGB(220, 240, 255), 2)
    end)

    local rideBtn = makeBtn("🐎 Ride tous les pets équipés", Color3.fromRGB(255, 180, 100), 3, content, 32)
    rideBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("RidePet")
        makeLabel("🐎 RidePet envoyé", Color3.fromRGB(220, 240, 255), 3)
    end)

    local neonBtn = makeBtn("💎 Fusion NÉON (4 pets identiques)", Color3.fromRGB(255, 200, 240), 4, content, 32)
    neonBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("DoNeonFusion")
        makeLabel("💎 Fusion NÉON envoyée", Color3.fromRGB(220, 240, 255), 4)
    end)

    local megaBtn = makeBtn("🌟 Fusion MÉGA (16 pets identiques)", Color3.fromRGB(255, 220, 130), 5, content, 32)
    megaBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("DoNeonFusion") -- souvent même remote avec flag
        makeLabel("🌟 Fusion MÉGA envoyée", Color3.fromRGB(220, 240, 255), 5)
    end)

    local claimPetBtn = makeBtn("🎁 Claim progression reward des pets", Color3.fromRGB(150, 220, 180), 6, content, 32)
    claimPetBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("ClaimPetReward")
        makeLabel("🎁 Claim envoyé", Color3.fromRGB(220, 240, 255), 6)
    end)

    makeLabel("💊 Potions", Color3.fromRGB(220, 240, 255), 7)
    local growBtn = makeBtn("📈 Boire potion Grow", Color3.fromRGB(150, 220, 150), 8, content, 30)
    growBtn.MouseButton1Click:Connect(function() fire("DrinkGrow") end)

    local cureBtn = makeBtn("💚 Boire potion Cure All", Color3.fromRGB(150, 220, 200), 9, content, 30)
    cureBtn.MouseButton1Click:Connect(function() fire("DrinkCureAll") end)

    local bigBtn = makeBtn("🎈 Boire potion Big Head", Color3.fromRGB(255, 180, 220), 10, content, 30)
    bigBtn.MouseButton1Click:Connect(function() fire("DrinkBigHead") end)
end)

-- ================================================================
-- TAB 3 : HALLOWEEN
-- ================================================================
createTab("halloween", "🎃 Halloween", function()
    makeLabel("🎃 Event Halloween 2026 (Hauntlet)", Color3.fromRGB(255, 200, 220), 1)
    makeLabel("Candy, Tomb Spider, Ghost Vacuum, Jacobean, Lightning, Stray Cat, Padlocks", Color3.fromRGB(255, 235, 248), 2)

    makeToggle("🎃 Auto-claim TOUT Halloween", 3, false, function(v)
        autoHalloween = v
        if v then
            startLoop("halloween", 2, function()
                fire("CandyCornClaim")
                fire("ClaimTombSpider")
                fire("GhostVacuumFire")
                fire("JacobeanTwig")
                fire("LightningActivate")
                fire("LightningDeliver")
                fire("StrayCatGift")
                fire("UnlockPadlock")
                fire("UnlockJournal")
            end)
            playSnd(SND.Success, 0.6)
        else
            stopLoop("halloween")
        end
    end)

    makeLabel("🔧 Actions individuelles", Color3.fromRGB(220, 240, 255), 4)

    local actions = {
        {"🍬 Candy Corn Pile Claim", "CandyCornClaim"},
        {"🕷️ Claim Tomb Spider", "ClaimTombSpider"},
        {"👻 Ghost Vacuum Fire", "GhostVacuumFire"},
        {"🪶 Jacobean Twig Contribute", "JacobeanTwig"},
        {"⚡ Lightning Lever Activate", "LightningActivate"},
        {"⚡ Lightning Lever Deliver", "LightningDeliver"},
        {"🐈 Stray Cat Gift Food", "StrayCatGift"},
        {"🔓 Unlock Padlock", "UnlockPadlock"},
        {"📖 Unlock Journal Page", "UnlockJournal"},
    }
    local order = 5
    for _, data in ipairs(actions) do
        local b = makeBtn(data[1], Color3.fromRGB(255, 150, 200), order, content, 28)
        b.MouseButton1Click:Connect(function()
            playSnd(SND.Click, 0.3)
            fire(data[2])
        end)
        order = order + 1
    end
end)

-- ================================================================
-- TAB 4 : VISUALS
-- ================================================================
createTab("visuals", "👁 Visuals", function()
    makeLabel("👁 Visuals (ESP)", Color3.fromRGB(220, 240, 255), 1)

    makeToggle("Activer l'ESP global", 2, false, function(v)
        espEnabled = v
        refreshEsp()
    end)

    makeToggle("ESP joueurs (rouge)", 3, false, function(v)
        espPlayersEnabled = v
        refreshEsp()
    end)

    makeToggle("ESP pets (vert)", 4, false, function(v)
        espPetsEnabled = v
        refreshEsp()
    end)

    makeToggle("Afficher les boîtes (box)", 5, false, function(v)
        espBoxEnabled = v
    end)

    local refreshBtn = makeBtn("🔄 Rafraîchir l'ESP", Color3.fromRGB(150, 220, 180), 6, content, 32)
    refreshBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        refreshEsp()
    end)

    makeLabel("💡 Active 'ESP global' puis 'ESP pets' pour voir les pets à travers les murs.", Color3.fromRGB(255, 235, 248), 7)
end)

-- ================================================================
-- TAB 5 : TRADE
-- ================================================================
createTab("trade", "🔄 Trade", function()
    makeLabel("🔄 Trade", Color3.fromRGB(220, 240, 255), 1)

    local quizBtn = makeBtn("🧠 Skip le quiz de trade", Color3.fromRGB(180, 140, 240), 2, content, 32)
    quizBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        fire("BeginQuiz")
        task.wait(0.2)
        for i = 1, 5 do
            fire("AnswerQuiz", i, 0)
            task.wait(0.1)
        end
        fire("EndQuiz")
        makeLabel("🧠 Quiz skippé (essai)", Color3.fromRGB(220, 240, 255), 2)
    end)

    local histBtn = makeBtn("📜 Voir l'historique de trade", Color3.fromRGB(150, 220, 200), 3, content, 32)
    histBtn.MouseButton1Click:Connect(function()
        local ok, hist = pcall(function()
            local remote = findRemote(REMOTES.GetTradeHistory)
            if remote then return remote:InvokeServer() end
        end)
        if ok and hist then
            print("[Trade History]", hist)
            makeLabel("📜 Historique affiché en console (F9)", Color3.fromRGB(220, 240, 255), 3)
        else
            makeLabel("❌ Impossible d'invoquer GetTradeHistory", Color3.fromRGB(255, 200, 200), 3)
        end
    end)

    makeLabel("⚠️ Les remotes trade ont besoin d'arguments précis (item, joueur). Utilise le logger pour capturer.", Color3.fromRGB(255, 235, 248), 4)
end)

-- ================================================================
-- TAB 6 : TÉLÉPORT
-- ================================================================
createTab("tp", "🚀 TP", function()
    makeLabel("🚀 Téléportation", Color3.fromRGB(220, 240, 255), 1)

    local locations = {
        {"🏠 Maison (House)", "house"},
        {"🏙️ Downtown", "city"},
        {"🌾 Ferme / Farm", "farm"},
        {"🎃 Halloween 2026", "halloween"},
        {"🛒 Boutique", "shop"},
        {"🎡 Parc", "park"},
        {"🏫 École", "school"},
        {"🐾 Pet Pen", "petpen"},
    }
    local order = 2
    for _, data in ipairs(locations) do
        local b = makeBtn(data[1], Color3.fromRGB(180, 140, 240), order, content, 28)
        b.MouseButton1Click:Connect(function()
            playSnd(SND.Success, 0.4)
            fire("TeleToLocation", data[2])
        end)
        order = order + 1
    end

    makeLabel("🎯 Téléport au joueur le plus proche", Color3.fromRGB(220, 240, 255), order)
    order = order + 1

    local nearestBtn = makeBtn("➡️ Aller au joueur le plus proche", Color3.fromRGB(255, 180, 100), order, content, 30)
    nearestBtn.MouseButton1Click:Connect(function()
        playSnd(SND.Success, 0.4)
        local nearest, dist = nil, math.huge
        local myChar = LP.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local myPos = myChar.HumanoidRootPart.Position
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - myPos).Magnitude
                    if d < dist then dist = d; nearest = p end
                end
            end
        end
        if nearest then
            fire("TeleToPlayer", nearest)
            makeLabel("➡️ TP vers "..nearest.Name, Color3.fromRGB(220, 240, 255), order)
        end
    end)
end)

-- ================================================================
-- TAB 7 : LOGGER (capture args)
-- ================================================================
createTab("logger", "📝 Logger", function()
    makeLabel("📝 Logger intégré — capture les arguments réels", Color3.fromRGB(220, 240, 255), 1)
    makeLabel("Active le logger, joue normalement, puis regarde la console (F9) pour voir les args exacts de chaque remote.", Color3.fromRGB(255, 235, 248), 2)

    local hookActive = false
    local hooked = {}

    makeToggle("▶ Activer le hook des remotes", 3, false, function(v)
        hookActive = v
        if v then
            playSnd(SND.Success, 0.4)
            -- Hook tous les remotes connus
            for name, path in pairs(REMOTES) do
                local remote = findRemote(path)
                if remote and not hooked[remote] then
                    hooked[remote] = true
                    if remote:IsA("RemoteEvent") then
                        local old = remote.FireServer
                        remote.FireServer = function(self, ...)
                            if hookActive then
                                local args = {...}
                                local s = {}
                                for i, a in ipairs(args) do
                                    s[i] = typeof(a) == "Instance" and a:GetFullName() or tostring(a)
                                end
                                print("[SEND] "..name.."("..table.concat(s, ", ")..")")
                            end
                            return old(self, ...)
                        end
                    elseif remote:IsA("RemoteFunction") then
                        local old = remote.InvokeServer
                        remote.InvokeServer = function(self, ...)
                            if hookActive then
                                local args = {...}
                                local s = {}
                                for i, a in ipairs(args) do
                                    s[i] = typeof(a) == "Instance" and a:GetFullName() or tostring(a)
                                end
                                print("[INVOKE] "..name.."("..table.concat(s, ", ")..")")
                            end
                            return old(self, ...)
                        end
                    end
                end
            end
            makeLabel("▶ Logger actif - voir console (F9)", Color3.fromRGB(220, 240, 255), 3)
        else
            playSnd(SND.Pop, 0.4)
            makeLabel("⏸ Logger arrêté", Color3.fromRGB(255, 235, 248), 3)
        end
    end)
end)

-- ================================================================
-- TAB 8 : SETTINGS
-- ================================================================
createTab("settings", "⚙️ Config", function()
    makeLabel("⚙️ Configuration", Color3.fromRGB(220, 240, 255), 1)

    local closeAllBtn = makeBtn("⏹ Arrêter tous les loops", Color3.fromRGB(255, 120, 130), 2, content, 34)
    closeAllBtn.MouseButton1Click:Connect(function()
        for name, _ in pairs(loops) do stopLoop(name) end
        playSnd(SND.Pop, 0.5)
        makeLabel("⏹ Tous les loops arrêtés", Color3.fromRGB(255, 235, 248), 2)
    end)

    local destroyBtn = makeBtn("❌ Détruire l'UI", Color3.fromRGB(200, 80, 90), 3, content, 34)
    destroyBtn.MouseButton1Click:Connect(function()
        clearEsp()
        sg:Destroy()
    end)

    makeLabel("🐾 Adopt Me Autofarm V1", Color3.fromRGB(255, 235, 248), 4)
    makeLabel("Basé sur les 603 remotes réels du jeu", Color3.fromRGB(255, 235, 248), 5)
    makeLabel("⚠️ Compte poubelle recommandé", Color3.fromRGB(255, 220, 220), 6)
end)

-- ================================================================
-- INIT : ouvrir Farm par défaut
-- ================================================================
currentTab = "farm"
tabs.farm.btn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
tabs.farm.btn.TextColor3 = Color3.new(1, 1, 1)
tabs.farm.callback()

-- Toggle float button
floatBtn.MouseButton1Click:Connect(function()
    sg.Enabled = not sg.Enabled
    if not sg.Enabled then
        task.delay(0.05, function() sg.Enabled = true end)
        floatBtn.Visible = true
    end
end)

-- Drag float button
do
    local drag, dS, sP
    floatBtn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            drag = true; dS = i.Position; sP = floatBtn.Position
            i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local d = i.Position - dS
            floatBtn.Position = UDim2.new(sP.X.Scale, sP.X.Offset + d.X, sP.Y.Scale, sP.Y.Offset + d.Y)
        end
    end)
end

-- ================================================================
-- REFRESH ESP automatique sur nouveaux persos
-- ================================================================
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        task.wait(1)
        if espEnabled then refreshEsp() end
    end)
end)

print("[AM Autofarm V1] Chargé - "..(function()
    local n = 0
    for _ in pairs(REMOTES) do n = n + 1 end
    return n
end)().." remotes mappés")