-- ============================================================
-- LOGGER ADOPT ME v3 - ULTRA ROBUSTE (testé pour Delta mobile)
-- ============================================================

print("[Logger] Démarrage...")

local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

print("[Logger] Services OK")

-- Parent GUI - CoreGui direct (marche sur Delta)
local sg = Instance.new("ScreenGui")
sg.Name = "AMLoggerV3"
sg.ResetOnSpawn = false
sg.Parent = CoreGui
print("[Logger] ScreenGui créé")

-- ============================================================
-- UI
-- ============================================================
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 380, 0, 540)
win.Position = UDim2.new(0.5, -190, 0.5, -270)
win.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
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
hd.Size = UDim2.new(1, 0, 0, 40)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.BorderSizePixel = 0
hd.Parent = win
local hc = Instance.new("UICorner")
hc.CornerRadius = UDim.new(0, 14)
hc.Parent = hd
local hdfix = Instance.new("Frame")
hdfix.Size = UDim2.new(1, 0, 0, 14)
hdfix.Position = UDim2.new(0, 0, 1, -14)
hdfix.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hdfix.BorderSizePixel = 0
hdfix.Parent = hd

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎃 Logger Adopt Me v3"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 15
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = hd

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
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

-- ============================================================
-- INSTRUCTIONS (scroll)
-- ============================================================
local instr = Instance.new("ScrollingFrame")
instr.Size = UDim2.new(1, -20, 0, 240)
instr.Position = UDim2.new(0, 10, 0, 50)
instr.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
instr.BorderSizePixel = 0
instr.ScrollBarThickness = 5
instr.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
instr.CanvasSize = UDim2.new(0, 0, 0, 0)
instr.AutomaticCanvasSize = Enum.AutomaticSize.Y
instr.Parent = win
local ic = Instance.new("UICorner")
ic.CornerRadius = UDim.new(0, 10)
ic.Parent = instr
local il = Instance.new("UIListLayout")
il.Padding = UDim.new(0, 4)
il.SortOrder = Enum.SortOrder.LayoutOrder
il.Parent = instr
local ip = Instance.new("UIPadding")
ip.PaddingTop = UDim.new(0, 10)
ip.PaddingBottom = UDim.new(0, 10)
ip.PaddingLeft = UDim.new(0, 10)
ip.PaddingRight = UDim.new(0, 10)
ip.Parent = instr

local function addInstr(text, color, size, order)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = color or Color3.fromRGB(220, 220, 240)
    l.Font = Enum.Font.Gotham
    l.TextSize = size or 12
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.TextWrapped = true
    l.LayoutOrder = order
    l.Parent = instr
    return l
end

addInstr("📋 INSTRUCTIONS", Color3.fromRGB(255, 130, 190), 14, 1)
addInstr("Le logger enregistre TOUT automatiquement.", Color3.fromRGB(200, 200, 220), 11, 2)
addInstr("Fais ces actions dans Adopt Me :", Color3.fromRGB(255, 200, 100), 12, 3)
addInstr("🎃 1. Va au Hauntlet (Halloween)", nil, 11, 4)
addInstr("🍬 2. Ramasse du candy corn", nil, 11, 5)
addInstr("🕷️ 3. Ouvre un Tomb Spider", nil, 11, 6)
addInstr("👻 4. Utilise le Ghost Vacuum", nil, 11, 7)
addInstr("🪶 5. Pigeon Jacobean - donne branche", nil, 11, 8)
addInstr("⚡ 6. Active le Lightning Lever", nil, 11, 9)
addInstr("⚡ 7. Livre la Lightning", nil, 11, 10)
addInstr("🐈 8. Donne à manger au Stray Cat", nil, 11, 11)
addInstr("🔓 9. Déverrouille un Padlock", nil, 11, 12)
addInstr("📖 10. Débloque une page du journal", nil, 11, 13)
addInstr("🎮 11. Joue à UN mini-jeu complet", nil, 11, 14)
addInstr("🐾 12. Nourris/lave/joue avec UN pet", nil, 11, 15)
addInstr("🔄 13. Fais un trade rapide", nil, 11, 16)
addInstr("", nil, 6, 17)
addInstr("Puis clique sur le bouton vert en bas.", Color3.fromRGB(120, 220, 150), 12, 18)

-- ============================================================
-- COMPTEUR + STATUS
-- ============================================================
local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, -20, 0, 26)
counter.Position = UDim2.new(0, 10, 0, 298)
counter.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
counter.BorderSizePixel = 0
counter.Text = "📊 0 logs capturés"
counter.TextColor3 = Color3.fromRGB(255, 200, 100)
counter.Font = Enum.Font.GothamBold
counter.TextSize = 12
counter.Parent = win
local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(0, 8)
cc.Parent = counter

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 0, 328)
status.BackgroundTransparency = 1
status.Text = "✅ Logger actif - fais les actions !"
status.TextColor3 = Color3.fromRGB(120, 220, 150)
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = win

-- ============================================================
-- APERÇU DES LOGS (5 dernières lignes)
-- ============================================================
local preview = Instance.new("ScrollingFrame")
preview.Size = UDim2.new(1, -20, 0, 80)
preview.Position = UDim2.new(0, 10, 0, 354)
preview.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
preview.BorderSizePixel = 0
preview.ScrollBarThickness = 4
preview.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
preview.CanvasSize = UDim2.new(0, 0, 0, 0)
preview.AutomaticCanvasSize = Enum.AutomaticSize.Y
preview.Parent = win
local pc = Instance.new("UICorner")
pc.CornerRadius = UDim.new(0, 8)
pc.Parent = preview
local pl = Instance.new("UIListLayout")
pl.Padding = UDim.new(0, 2)
pl.SortOrder = Enum.SortOrder.LayoutOrder
pl.Parent = preview
local pp = Instance.new("UIPadding")
pp.PaddingTop = UDim.new(0, 6)
pp.PaddingBottom = UDim.new(0, 6)
pp.PaddingLeft = UDim.new(0, 8)
pp.PaddingRight = UDim.new(0, 8)
pp.Parent = preview

-- ============================================================
-- BOUTONS
-- ============================================================
local doneBtn = Instance.new("TextButton")
doneBtn.Size = UDim2.new(1, -20, 0, 48)
doneBtn.Position = UDim2.new(0, 10, 1, -108)
doneBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
doneBtn.Text = "✅  TERMINÉ - Copier tout"
doneBtn.TextColor3 = Color3.new(1, 1, 1)
doneBtn.Font = Enum.Font.GothamBold
doneBtn.TextSize = 14
doneBtn.AutoButtonColor = false
doneBtn.Parent = win
local dbc = Instance.new("UICorner")
dbc.CornerRadius = UDim.new(0, 10)
dbc.Parent = doneBtn

local clearBtn = Instance.new("TextButton")
clearBtn.Size = UDim2.new(1, -20, 0, 34)
clearBtn.Position = UDim2.new(0, 10, 1, -54)
clearBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 130)
clearBtn.Text = "🗑 Effacer les logs"
clearBtn.TextColor3 = Color3.new(1, 1, 1)
clearBtn.Font = Enum.Font.GothamBold
clearBtn.TextSize = 12
clearBtn.AutoButtonColor = false
clearBtn.Parent = win
local clc = Instance.new("UICorner")
clc.CornerRadius = UDim.new(0, 8)
clc.Parent = clearBtn

-- ============================================================
-- LOGIQUE DE LOGGING
-- ============================================================
local logs = {}
local MAX_LOGS = 5000
local logCount = 0

-- WATCHLIST : noms de remotes intéressants
local WATCH = {
    -- Halloween
    ["CandyCornPileClaim"]=true, ["ClaimTombSpider"]=true, ["GhostVacuumToyFire"]=true,
    ["JacobeanPigeonNestContributeTwig"]=true, ["LightningLeverActivate"]=true,
    ["LightningLeverDeliver"]=true, ["StrayCatGiftFood"]=true, ["UnlockPadlock"]=true,
    ["UnlockHauntletJournalPage"]=true, ["GrantMysteryKey"]=true, ["UnlockDoor"]=true,
    -- Mini-jeux
    ["AttemptStart"]=true, ["FinishObby"]=true, ["Leave"]=true,
    ["MessageClient"]=true, ["MessageServer"]=true,
    ["RequestClient"]=true, ["RequestServer"]=true,
    ["LobbyJoin"]=true, ["LobbyCreate"]=true, ["LobbyStart"]=true,
    ["AttemptJoin"]=true, ["LobbyGetId"]=true, ["LobbyInvite"]=true, ["LobbyLeave"]=true,
    -- Pets
    ["PetPetted"]=true, ["PetHatched"]=true, ["MarkHatched"]=true,
    ["ConsumeFoodObject"]=true, ["ClaimProgressionReward"]=true,
    ["DoNeonFusion"]=true, ["FocusPet"]=true, ["UnfocusPet"]=true,
    ["FlyPet"]=true, ["RidePet"]=true, ["EquipPetLeash"]=true, ["UnequipPetLeash"]=true,
    ["CreatePetObject"]=true, ["DropPetObject"]=true, ["GrabPetObject"]=true,
    ["SpawnInFrontOfPet"]=true, ["TriggerSqueakEffect"]=true,
    -- Ailments (faim, soif, sale...)
    ["ProgressDirtyAilment"]=true, ["ProgressPetMeAilment"]=true,
    ["PetAilmentCompleted"]=true, ["BabyAilmentCompleted"]=true,
    ["ChooseMysteryAilment"]=true, ["ShowHealingEffect"]=true,
    -- Potions
    ["DrinkGrowPotion"]=true, ["DrinkBigHeadPotion"]=true, ["DrinkCureAllPotion"]=true,
    ["DrinkHeartPotion"]=true, ["DrinkLevitatePotion"]=true,
    -- Trade
    ["AddItemToOffer"]=true, ["RemoveItemFromOffer"]=true, ["ConfirmTrade"]=true,
    ["SendTradeRequest"]=true, ["AcceptOrDeclineTradeRequest"]=true,
    ["BeginQuiz"]=true, ["EndQuiz"]=true, ["AnswerQuizQuestion"]=true,
    -- Housing/furniture
    ["ActivateFurniture"]=true, ["ActivateInteriorFurniture"]=true,
    -- Quêtes
    ["ClaimReward"]=true, ["ClaimLoginHandouts"]=true, ["ClaimLikeReward"]=true,
    ["ClaimCollectorReward"]=true, ["ClaimUGCLinkedItems"]=true, ["ClaimBeesBlaster"]=true,
    -- Pet Recycler
    ["TicketsCollected"]=true, ["PetsReleased"]=true, ["RewardReceived"]=true,
}

-- Formatter les args pour affichage
local function fmt(v)
    local t = typeof(v)
    if t == "Instance" then
        return v:GetFullName()
    elseif t == "Vector3" then
        return string.format("V3(%.1f, %.1f, %.1f)", v.X, v.Y, v.Z)
    elseif t == "CFrame" then
        local p = v.Position
        return string.format("CF(%.1f, %.1f, %.1f)", p.X, p.Y, p.Z)
    elseif t == "table" then
        local parts = {}
        local count = 0
        for k, vv in pairs(v) do
            count = count + 1
            if count > 8 then
                table.insert(parts, "...")
                break
            end
            local vs
            if type(vv) == "table" then
                vs = "{...}"
            else
                vs = tostring(vv)
            end
            table.insert(parts, tostring(k).."="..vs)
        end
        return "{"..table.concat(parts, ", ").."}"
    elseif t == "EnumItem" then
        return tostring(v)
    else
        return tostring(v)
    end
end

-- Mettre à jour le compteur
local function updateCounter()
    counter.Text = "📊 "..logCount.." logs capturés"
end

-- Ajouter un log
local function addLog(tag, name, args)
    local parts = {}
    for i, a in ipairs(args) do
        parts[i] = fmt(a)
    end
    local line = string.format("[%s] %s(%s)", tag, name, table.concat(parts, ", "))
    table.insert(logs, line)
    if #logs > MAX_LOGS then
        table.remove(logs, 1)
    end
    logCount = logCount + 1
    updateCounter()
    
    -- Aperçu (dernières lignes)
    if logCount % 1 == 0 then
        local pLine = Instance.new("TextLabel")
        pLine.Size = UDim2.new(1, 0, 0, 0)
        pLine.AutomaticSize = Enum.AutomaticSize.Y
        pLine.BackgroundTransparency = 1
        pLine.Text = line
        pLine.TextColor3 = Color3.fromRGB(180, 220, 255)
        pLine.Font = Enum.Font.Code
        pLine.TextSize = 10
        pLine.TextXAlignment = Enum.TextXAlignment.Left
        pLine.TextWrapped = true
        pLine.Parent = preview
        
        -- Garder seulement les 20 dernières
        local all = preview:GetChildren()
        local textLabels = {}
        for _, c in ipairs(all) do
            if c:IsA("TextLabel") then
                table.insert(textLabels, c)
            end
        end
        if #textLabels > 20 then
            textLabels[1]:Destroy()
        end
        
        -- Auto-scroll en bas
        task.defer(function()
            preview.CanvasPosition = Vector2.new(0, preview.AbsoluteCanvasSize.Y)
        end)
    end
end

-- Hook un remote
local function hookRemote(remote)
    if not remote then return end
    if remote:GetAttribute("__logged") then return end
    remote:SetAttribute("__logged", true)
    
    local name = remote.Name
    if not WATCH[name] then return end
    
    local className = remote.ClassName
    
    if className == "RemoteEvent" or className == "UnreliableRemoteEvent" then
        local oldFire = remote.FireServer
        remote.FireServer = function(self, ...)
            local ok, err = pcall(addLog, "SEND", name, {...})
            return oldFire(self, ...)
        end
        pcall(function()
            remote.OnClientEvent:Connect(function(...)
                pcall(addLog, "RECV", name, {...})
            end)
        end)
    elseif className == "RemoteFunction" then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = function(self, ...)
            pcall(addLog, "INVOKE", name, {...})
            return oldInvoke(self, ...)
        end
    end
end

-- Scanner tous les remotes
local function scanAll()
    local count = 0
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") then
            if WATCH[obj.Name] then
                hookRemote(obj)
                count = count + 1
            end
        end
    end
    return count
end

local hookedCount = scanAll()
print("[Logger] "..hookedCount.." remotes hookés")
status.Text = "✅ "..hookedCount.." remotes hookés - fais les actions !"

-- Re-scan périodique (au cas où le jeu charge de nouveaux remotes)
task.spawn(function()
    while sg.Parent do
        task.wait(10)
        pcall(scanAll)
    end
end)

-- ============================================================
-- BOUTON TERMINÉ → ACCOMPLI + COPIE
-- ============================================================
doneBtn.MouseButton1Click:Connect(function()
    -- Format final
    local output = "=== ADOPT ME LOGS - "..os.date("%Y-%m-%d %H:%M:%S").." ===\n"
    output = output .. "Total: "..logCount.." logs\n\n"
    output = output .. table.concat(logs, "\n")
    
    -- Copier
    local copied = false
    if type(setclipboard) == "function" then
        local ok = pcall(setclipboard, output)
        copied = ok
    end
    
    -- Afficher ACCOMPLI
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 10
    overlay.Parent = sg
    
    local bigBox = Instance.new("Frame")
    bigBox.Size = UDim2.new(0, 340, 0, 200)
    bigBox.Position = UDim2.new(0.5, -170, 0.5, -100)
    bigBox.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
    bigBox.BorderSizePixel = 0
    bigBox.ZIndex = 11
    bigBox.Parent = overlay
    local bbc = Instance.new("UICorner")
    bbc.CornerRadius = UDim.new(0, 18)
    bbc.Parent = bigBox
    
    local bigTitle = Instance.new("TextLabel")
    bigTitle.Size = UDim2.new(1, 0, 0, 60)
    bigTitle.Position = UDim2.new(0, 0, 0, 20)
    bigTitle.BackgroundTransparency = 1
    bigTitle.Text = "✅ ACCOMPLI !"
    bigTitle.TextColor3 = Color3.new(1, 1, 1)
    bigTitle.Font = Enum.Font.GothamBlack
    bigTitle.TextSize = 32
    bigTitle.ZIndex = 12
    bigTitle.Parent = bigBox
    
    local bigInfo = Instance.new("TextLabel")
    bigInfo.Size = UDim2.new(1, -40, 0, 60)
    bigInfo.Position = UDim2.new(0, 20, 0, 85)
    bigInfo.BackgroundTransparency = 1
    bigInfo.Text = copied
        and ("📋 "..logCount.." logs COPIÉS !\nColle-les dans le chat du dev.")
        or ("⚠️ setclipboard indisponible.\nFais un screenshot (F9).")
    bigInfo.TextColor3 = Color3.new(1, 1, 1)
    bigInfo.Font = Enum.Font.GothamBold
    bigInfo.TextSize = 13
    bigInfo.TextWrapped = true
    bigInfo.ZIndex = 12
    bigInfo.Parent = bigBox
    
    local closeOverlay = Instance.new("TextButton")
    closeOverlay.Size = UDim2.new(1, -40, 0, 36)
    closeOverlay.Position = UDim2.new(0, 20, 1, -46)
    closeOverlay.BackgroundColor3 = Color3.new(1, 1, 1)
    closeOverlay.Text = "OK - Fermer"
    closeOverlay.TextColor3 = Color3.fromRGB(120, 220, 150)
    closeOverlay.Font = Enum.Font.GothamBold
    closeOverlay.TextSize = 14
    closeOverlay.ZIndex = 12
    closeOverlay.Parent = bigBox
    local coc = Instance.new("UICorner")
    coc.CornerRadius = UDim.new(0, 10)
    coc.Parent = closeOverlay
    closeOverlay.MouseButton1Click:Connect(function()
        overlay:Destroy()
    end)
    
    -- Son
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9118823103"
        s.Volume = 0.7
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
    
    print("[Logger] ✅ ACCOMPLI - "..logCount.." logs capturés")
    print("[Logger] Copié: "..tostring(copied))
end)

-- ============================================================
-- BOUTON CLEAR
-- ============================================================
clearBtn.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    updateCounter()
    for _, c in ipairs(preview:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    status.Text = "🗑 Logs effacés - reprends !"
end)

-- ============================================================
-- DÉMARRAGE
-- ============================================================
print("[Logger] ✅ PRÊT - "..hookedCount.." remotes surveillés")
print("[Logger] Fais les 13 actions puis clique TERMINÉ")