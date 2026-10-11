-- ============================================================
-- LOGGER ADOPT ME v4 - Hook __namecall (fiable)
-- ============================================================
print("[Logger] Démarrage...")

local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

-- Vérifie les fonctions disponibles
local hasGetRawMeta = type(getrawmetatable) == "function"
local hasSetReadonly = type(setreadonly) == "function"
local hasNewcclosure = type(newcclosure) == "function"
local hasGetNamecall = type(getnamecallmethod) == "function"
local hasSetClipboard = type(setclipboard) == "function"

print("[Logger] getrawmetatable:", hasGetRawMeta, "| newcclosure:", hasNewcclosure)

local sg = Instance.new("ScreenGui")
sg.Name = "AMLoggerV4"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

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
local wc = Instance.new("UICorner"); wc.CornerRadius = UDim.new(0, 14); wc.Parent = win
local ws = Instance.new("UIStroke"); ws.Color = Color3.fromRGB(255, 130, 190); ws.Thickness = 2; ws.Parent = win

-- Header
local hd = Instance.new("Frame")
hd.Size = UDim2.new(1, 0, 0, 40)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.BorderSizePixel = 0
hd.Parent = win
local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 14); hc.Parent = hd
local hdfix = Instance.new("Frame")
hdfix.Size = UDim2.new(1, 0, 0, 14); hdfix.Position = UDim2.new(0, 0, 1, -14)
hdfix.BackgroundColor3 = Color3.fromRGB(255, 130, 190); hdfix.BorderSizePixel = 0; hdfix.Parent = hd

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "🎃 Logger v4 - "..(hasGetRawMeta and "OK" or "FALLBACK")
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
local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 8); cbc.Parent = closeBtn
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- Mode toggle
local modeBtn = Instance.new("TextButton")
modeBtn.Size = UDim2.new(1, -20, 0, 26)
modeBtn.Position = UDim2.new(0, 10, 0, 48)
modeBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 240)
modeBtn.Text = "📡 Mode: TOUT (capture tous les remotes)"
modeBtn.TextColor3 = Color3.new(1, 1, 1)
modeBtn.Font = Enum.Font.GothamBold
modeBtn.TextSize = 11
modeBtn.AutoButtonColor = false
modeBtn.Parent = win
local mbc = Instance.new("UICorner"); mbc.CornerRadius = UDim.new(0, 8); mbc.Parent = modeBtn

local LOG_ALL = true -- TOUT par défaut

-- ============================================================
-- INSTRUCTIONS (avec popup détaillé)
-- ============================================================
local instr = Instance.new("ScrollingFrame")
instr.Size = UDim2.new(1, -20, 0, 200)
instr.Position = UDim2.new(0, 10, 0, 80)
instr.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
instr.BorderSizePixel = 0
instr.ScrollBarThickness = 5
instr.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
instr.CanvasSize = UDim2.new(0, 0, 0, 0)
instr.AutomaticCanvasSize = Enum.AutomaticSize.Y
instr.Parent = win
local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0, 10); ic.Parent = instr
local il = Instance.new("UIListLayout")
il.Padding = UDim.new(0, 4); il.SortOrder = Enum.SortOrder.LayoutOrder; il.Parent = instr
local ip = Instance.new("UIPadding")
ip.PaddingTop = UDim.new(0, 8); ip.PaddingBottom = UDim.new(0, 8)
ip.PaddingLeft = UDim.new(0, 8); ip.PaddingRight = UDim.new(0, 8)
ip.Parent = instr

-- Détails des instructions (pour popup)
local INSTRUCTIONS = {
    {title="🎃 Hauntlet", detail="Vas au portail Halloween. Cherche un portail violet/vert près du spawn ou dans le menu 'Events'. Entre dedans."},
    {title="🍬 Candy Corn", detail="Dans le Hauntlet, cherche des tas de bonbons oranges qui brillent au sol. Marche dessus / clique dessus pour les ramasser."},
    {title="🕷️ Tomb Spider", detail="Cherche une tombe avec une araignée dessus dans le Hauntlet. Clique dessus pour la réclamer."},
    {title="👻 Ghost Vacuum", detail="Équipe le 'Ghost Vacuum' (aspirateur à fantômes). Va près d'un fantôme qui flotte et clique sur le bouton 'Aspirer'."},
    {title="🪶 Pigeon Jacobean", detail="Cherche le nid du pigeon Jacobean (grand nid haut perché). Ramasse une branche au sol puis clique sur le nid pour la déposer."},
    {title="⚡ Lightning Lever", detail="Cherche un GRAND levier en métal (comme un interrupteur Frankenstein). Marche dessus / clique pour l'activer."},
    {title="⚡ Livrer Lightning", detail="Après avoir activé le levier, une éclair / un orbe apparaît. Ramasse-le et porte-le au point de livraison indiqué."},
    {title="🐈 Stray Cat", detail="Cherche un chat errant dans le Hauntlet. Achète de la nourriture pour chat et clique sur le chat avec la nourriture."},
    {title="🔓 Padlock", detail="Cherche un cadenas doré sur une porte/coffre. Clique dessus et suis la mini-résolution de puzzle."},
    {title="📖 Journal Hauntlet", detail="Cherche une page de journal qui brille (feuille de papier jaunâtre). Clique dessus pour la débloquer."},
    {title="🎮 Mini-jeu", detail="Va dans le menu 'Mini-games' ou cherche une zone avec un portail. Rejoins une partie et joue jusqu'à la fin (même 10 sec)."},
    {title="🐾 Pet action", detail="Ouvre ton inventaire → équipe un pet. Utilise une nourriture (food) sur le pet, ou fais-le jouer avec un jouet, ou lave-le."},
    {title="🔄 Trade", detail="Ouvre le menu Trade (icône échange). Envoie une demande à n'importe qui, ou accepte une demande. Fais juste l'action d'ouverture."},
}

local function addInstrLine(idx, data)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 26)
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    b.BorderSizePixel = 0
    b.Text = "  "..data.title.."   👆"
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.LayoutOrder = idx
    b.Parent = instr
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = b

    b.MouseButton1Click:Connect(function()
        -- Popup détaillé
        local overlay = Instance.new("Frame")
        overlay.Size = UDim2.new(1, 0, 1, 0)
        overlay.BackgroundColor3 = Color3.new(0, 0, 0)
        overlay.BackgroundTransparency = 0.55
        overlay.BorderSizePixel = 0
        overlay.ZIndex = 20
        overlay.Parent = sg

        local popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, 320, 0, 220)
        popup.Position = UDim2.new(0.5, -160, 0.5, -110)
        popup.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
        popup.BorderSizePixel = 0
        popup.ZIndex = 21
        popup.Parent = overlay
        local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 12); pc.Parent = popup
        local ps = Instance.new("UIStroke"); ps.Color = Color3.fromRGB(255, 130, 190); ps.Thickness = 2; ps.Parent = popup

        local pt = Instance.new("TextLabel")
        pt.Size = UDim2.new(1, -20, 0, 30)
        pt.Position = UDim2.new(0, 10, 0, 10)
        pt.BackgroundTransparency = 1
        pt.Text = data.title
        pt.TextColor3 = Color3.fromRGB(255, 130, 190)
        pt.Font = Enum.Font.GothamBlack
        pt.TextSize = 16
        pt.TextXAlignment = Enum.TextXAlignment.Left
        pt.ZIndex = 22
        pt.Parent = popup

        local pd = Instance.new("TextLabel")
        pd.Size = UDim2.new(1, -20, 0, 130)
        pd.Position = UDim2.new(0, 10, 0, 50)
        pd.BackgroundTransparency = 1
        pd.Text = data.detail
        pd.TextColor3 = Color3.fromRGB(220, 220, 240)
        pd.Font = Enum.Font.Gotham
        pd.TextSize = 13
        pd.TextXAlignment = Enum.TextXAlignment.Left
        pd.TextYAlignment = Enum.TextYAlignment.Top
        pd.TextWrapped = true
        pd.ZIndex = 22
        pd.Parent = popup

        local pb = Instance.new("TextButton")
        pb.Size = UDim2.new(1, -20, 0, 34)
        pb.Position = UDim2.new(0, 10, 1, -44)
        pb.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
        pb.Text = "OK compris !"
        pb.TextColor3 = Color3.new(1, 1, 1)
        pb.Font = Enum.Font.GothamBold
        pb.TextSize = 13
        pb.ZIndex = 22
        pb.Parent = popup
        local pbc = Instance.new("UICorner"); pbc.CornerRadius = UDim.new(0, 8); pbc.Parent = pb
        pb.MouseButton1Click:Connect(function() overlay:Destroy() end)
    end)
end

local headerInstr = Instance.new("TextLabel")
headerInstr.Size = UDim2.new(1, 0, 0, 20)
headerInstr.BackgroundTransparency = 1
headerInstr.Text = "📋 Clique sur chaque action pour voir comment faire :"
headerInstr.TextColor3 = Color3.fromRGB(255, 200, 100)
headerInstr.Font = Enum.Font.GothamBold
headerInstr.TextSize = 11
headerInstr.TextXAlignment = Enum.TextXAlignment.Left
headerInstr.LayoutOrder = 0
headerInstr.Parent = instr

for i, data in ipairs(INSTRUCTIONS) do
    addInstrLine(i, data)
end

-- ============================================================
-- COMPTEUR
-- ============================================================
local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, -20, 0, 26)
counter.Position = UDim2.new(0, 10, 0, 288)
counter.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
counter.BorderSizePixel = 0
counter.Text = "📊 0 logs capturés"
counter.TextColor3 = Color3.fromRGB(255, 200, 100)
counter.Font = Enum.Font.GothamBold
counter.TextSize = 12
counter.Parent = win
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 8); cc.Parent = counter

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 22)
status.Position = UDim2.new(0, 10, 0, 318)
status.BackgroundTransparency = 1
status.Text = "⏳ Hook en cours..."
status.TextColor3 = Color3.fromRGB(255, 200, 100)
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = win

-- Preview
local preview = Instance.new("ScrollingFrame")
preview.Size = UDim2.new(1, -20, 0, 80)
preview.Position = UDim2.new(0, 10, 0, 344)
preview.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
preview.BorderSizePixel = 0
preview.ScrollBarThickness = 4
preview.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
preview.CanvasSize = UDim2.new(0, 0, 0, 0)
preview.AutomaticCanvasSize = Enum.AutomaticSize.Y
preview.Parent = win
local pc = Instance.new("UICorner"); pc.CornerRadius = UDim.new(0, 8); pc.Parent = preview
local pl = Instance.new("UIListLayout")
pl.Padding = UDim.new(0, 2); pl.SortOrder = Enum.SortOrder.LayoutOrder; pl.Parent = preview
local pp = Instance.new("UIPadding")
pp.PaddingTop = UDim.new(0, 6); pp.PaddingBottom = UDim.new(0, 6)
pp.PaddingLeft = UDim.new(0, 8); pp.PaddingRight = UDim.new(0, 8)
pp.Parent = preview

-- Boutons
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
local dbc = Instance.new("UICorner"); dbc.CornerRadius = UDim.new(0, 10); dbc.Parent = doneBtn

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
local clc = Instance.new("UICorner"); clc.CornerRadius = UDim.new(0, 8); clc.Parent = clearBtn

-- ============================================================
-- LOGIQUE LOGGING
-- ============================================================
local logs = {}
local MAX_LOGS = 3000
local logCount = 0

local function fmt(v)
    local t = typeof(v)
    if t == "Instance" then return v:GetFullName()
    elseif t == "Vector3" then return string.format("V3(%.1f,%.1f,%.1f)", v.X, v.Y, v.Z)
    elseif t == "CFrame" then
        local p = v.Position
        return string.format("CF(%.1f,%.1f,%.1f)", p.X, p.Y, p.Z)
    elseif t == "table" then
        local parts, count = {}, 0
        for k, vv in pairs(v) do
            count = count + 1
            if count > 6 then table.insert(parts, "..."); break end
            table.insert(parts, tostring(k).."="..(type(vv)=="table" and "{...}" or tostring(vv)))
        end
        return "{"..table.concat(parts, ",").."}"
    elseif t == "EnumItem" then return tostring(v)
    else return tostring(v) end
end

local lastLogTime = {}
local function addLog(tag, name, args)
    -- Filtre spam : 1 même remote max toutes les 0.3s
    local now = tick()
    if lastLogTime[name] and now - lastLogTime[name] < 0.3 then return end
    lastLogTime[name] = now

    local parts = {}
    for i, a in ipairs(args) do parts[i] = fmt(a) end
    local line = string.format("[%s] %s(%s)", tag, name, table.concat(parts, ", "))
    table.insert(logs, line)
    if #logs > MAX_LOGS then table.remove(logs, 1) end
    logCount = logCount + 1
    counter.Text = "📊 "..logCount.." logs capturés"

    -- Preview
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

    -- Garde 15 dernières
    local labels = {}
    for _, c in ipairs(preview:GetChildren()) do
        if c:IsA("TextLabel") then table.insert(labels, c) end
    end
    if #labels > 15 then labels[1]:Destroy() end

    task.defer(function()
        pcall(function()
            preview.CanvasPosition = Vector2.new(0, preview.AbsoluteCanvasSize.Y)
        end)
    end)
end

-- ============================================================
-- HOOK PRINCIPAL : __namecall (fiable)
-- ============================================================
local hookedRemotes = 0
local function setupNamecallHook()
    if not hasGetRawMeta then return false end
    
    local mt = getrawmetatable(game)
    if not mt then return false end
    
    local oldNamecall = mt.__namecall
    if hasSetReadonly then setreadonly(mt, false) end
    
    local hookFn = function(self, ...)
        local method = hasGetNamecall and getnamecallmethod() or "?"
        if (method == "FireServer" or method == "InvokeServer") and typeof(self) == "Instance" then
            local cls = self.ClassName
            if cls == "RemoteEvent" or cls == "RemoteFunction" or cls == "UnreliableRemoteEvent" then
                local args = {...}
                local tag = (method == "FireServer") and "SEND" or "INVOKE"
                pcall(addLog, tag, self.Name, args)
            end
        end
        return oldNamecall(self, ...)
    end
    
    if hasNewcclosure then
        mt.__namecall = newcclosure(hookFn)
    else
        mt.__namecall = hookFn
    end
    
    if hasSetReadonly then setreadonly(mt, true) end
    return true
end

local namecallOK = setupNamecallHook()
print("[Logger] __namecall hook:", namecallOK)

-- Fallback : hook direct sur chaque remote (au cas où namecall pas dispo)
local WATCH_FALLBACK = {
    "CandyCornPileClaim","ClaimTombSpider","GhostVacuumToyFire",
    "JacobeanPigeonNestContributeTwig","LightningLeverActivate","LightningLeverDeliver",
    "StrayCatGiftFood","UnlockPadlock","UnlockHauntletJournalPage",
    "AttemptStart","FinishObby","PetPetted","ConsumeFoodObject",
    "ClaimProgressionReward","DoNeonFusion","FlyPet","RidePet",
    "PetHatched","MarkHatched","FocusPet","UnfocusPet",
    "DrinkGrowPotion","AddItemToOffer","ConfirmTrade","SendTradeRequest",
    "ClaimReward","ClaimLoginHandouts","ClaimLikeReward",
    "TicketsCollected","RewardReceived","ActivateFurniture",
    "LobbyJoin","LobbyCreate","AttemptJoin","LobbyStart",
}

local watchSet = {}
for _, n in ipairs(WATCH_FALLBACK) do watchSet[n] = true end

local function setupDirectHook()
    local count = 0
    for _, obj in ipairs(RS:GetDescendants()) do
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") then
            if watchSet[obj.Name] and not obj:GetAttribute("__hooked4") then
                pcall(function() obj:SetAttribute("__hooked4", true) end)
                count = count + 1
                
                if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then
                    local old = obj.FireServer
                    obj.FireServer = function(self, ...)
                        pcall(addLog, "SEND", self.Name, {...})
                        return old(self, ...)
                    end
                elseif obj:IsA("RemoteFunction") then
                    local old = obj.InvokeServer
                    obj.InvokeServer = function(self, ...)
                        pcall(addLog, "INVOKE", self.Name, {...})
                        return old(self, ...)
                    end
                end
            end
        end
    end
    return count
end

local directCount = setupDirectHook()
hookedRemotes = directCount
print("[Logger] Hooks directs:", directCount)

-- Status
if namecallOK then
    status.Text = "✅ Hook __namecall actif ("..directCount.." directs aussi)"
    status.TextColor3 = Color3.fromRGB(120, 220, 150)
else
    status.Text = "⚠️ Fallback : "..directCount.." remotes directs"
    status.TextColor3 = Color3.fromRGB(255, 200, 100)
end

-- Re-scan pour nouveaux remotes
task.spawn(function()
    while sg.Parent do
        task.wait(8)
        pcall(setupDirectHook)
    end
end)

-- ============================================================
-- BOUTON TERMINÉ
-- ============================================================
doneBtn.MouseButton1Click:Connect(function()
    local output = "=== ADOPT ME LOGS "..os.date("%Y-%m-%d %H:%M:%S").." ===\n"
    output = output .. "Total: "..logCount.." logs\n"
    output = output .. "Hook: "..(namecallOK and "__namecall" or "direct").."\n\n"
    output = output .. table.concat(logs, "\n")
    
    local copied = false
    if hasSetClipboard then
        copied = pcall(setclipboard, output)
    end
    
    -- Overlay ACCOMPLI
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 30
    overlay.Parent = sg
    
    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 340, 0, 220)
    box.Position = UDim2.new(0.5, -170, 0.5, -110)
    box.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
    box.BorderSizePixel = 0
    box.ZIndex = 31
    box.Parent = overlay
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 18); bc.Parent = box
    
    local bt = Instance.new("TextLabel")
    bt.Size = UDim2.new(1, 0, 0, 60)
    bt.Position = UDim2.new(0, 0, 0, 20)
    bt.BackgroundTransparency = 1
    bt.Text = "✅ ACCOMPLI !"
    bt.TextColor3 = Color3.new(1, 1, 1)
    bt.Font = Enum.Font.GothamBlack
    bt.TextSize = 32
    bt.ZIndex = 32
    bt.Parent = box
    
    local bi = Instance.new("TextLabel")
    bi.Size = UDim2.new(1, -40, 0, 90)
    bi.Position = UDim2.new(0, 20, 0, 85)
    bi.BackgroundTransparency = 1
    bi.Text = copied
        and ("📋 "..logCount.." logs COPIÉS !\nColle-les dans le chat et envoie.")
        or ("⚠️ setclipboard indispo.\nFais un screenshot F9.")
    bi.TextColor3 = Color3.new(1, 1, 1)
    bi.Font = Enum.Font.GothamBold
    bi.TextSize = 13
    bi.TextWrapped = true
    bi.ZIndex = 32
    bi.Parent = box
    
    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(1, -40, 0, 36)
    cb.Position = UDim2.new(0, 20, 1, -46)
    cb.BackgroundColor3 = Color3.new(1, 1, 1)
    cb.Text = "OK Fermer"
    cb.TextColor3 = Color3.fromRGB(120, 220, 150)
    cb.Font = Enum.Font.GothamBold
    cb.TextSize = 14
    cb.ZIndex = 32
    cb.Parent = box
    local cbc2 = Instance.new("UICorner"); cbc2.CornerRadius = UDim.new(0, 10); cbc2.Parent = cb
    cb.MouseButton1Click:Connect(function() overlay:Destroy() end)
    
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9118823103"
        s.Volume = 0.7
        s.Parent = game:GetService("SoundService")
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
    
    print("[Logger] ✅ ACCOMPLI - "..logCount.." logs | copié: "..tostring(copied))
end)

clearBtn.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    counter.Text = "📊 0 logs capturés"
    for _, c in ipairs(preview:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
    status.Text = "🗑 Effacé - reprends !"
end)

modeBtn.MouseButton1Click:Connect(function()
    LOG_ALL = not LOG_ALL
    if LOG_ALL then
        modeBtn.Text = "📡 Mode: TOUT (capture tous les remotes)"
        modeBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 240)
    else
        modeBtn.Text = "📡 Mode: FILTRÉ (que les remotes connus)"
        modeBtn.BackgroundColor3 = Color3.fromRGB(120, 200, 240)
    end
end)

print("[Logger] ✅ PRÊT")
print("[Logger] Hook namecall:", namecallOK, "| Directs:", directCount)