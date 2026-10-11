-- ============================================================
-- LOGGER ADOPT ME v6 - Instructions inline (fiable)
-- ============================================================
print("[Logger v6] Démarrage...")

local RS = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")

local hasGetRawMeta = type(getrawmetatable) == "function"
local hasSetReadonly = type(setreadonly) == "function"
local hasGetNamecall = type(getnamecallmethod) == "function"
local hasSetClipboard = type(setclipboard) == "function"

local sg = Instance.new("ScreenGui")
sg.Name = "AMLoggerV6"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.Parent = CoreGui

-- Fenêtre
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
title.Text = "🎃 Logger v6"
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
closeBtn.MouseButton1Click:Connect(function()
    if getgenv()._loggerV6Stop then getgenv()._loggerV6Stop() end
    sg:Destroy()
end)

-- Bouton PAUSE
local pauseBtn = Instance.new("TextButton")
pauseBtn.Size = UDim2.new(1, -20, 0, 26)
pauseBtn.Position = UDim2.new(0, 10, 0, 48)
pauseBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
pauseBtn.Text = "⏸ HOOK ACTIF - Clique pour PAUSE"
pauseBtn.TextColor3 = Color3.new(1, 1, 1)
pauseBtn.Font = Enum.Font.GothamBold
pauseBtn.TextSize = 11
pauseBtn.AutoButtonColor = false
pauseBtn.Parent = win
local pbc = Instance.new("UICorner"); pbc.CornerRadius = UDim.new(0, 8); pbc.Parent = pauseBtn

-- Zone qui change (liste ⇄ détail)
local zone = Instance.new("Frame")
zone.Size = UDim2.new(1, -20, 0, 200)
zone.Position = UDim2.new(0, 10, 0, 80)
zone.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
zone.BorderSizePixel = 0
zone.Parent = win
local zc = Instance.new("UICorner"); zc.CornerRadius = UDim.new(0, 10); zc.Parent = zone

-- === VUE LISTE ===
local listView = Instance.new("ScrollingFrame")
listView.Size = UDim2.new(1, 0, 1, 0)
listView.BackgroundTransparency = 1
listView.BorderSizePixel = 0
listView.ScrollBarThickness = 5
listView.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
listView.CanvasSize = UDim2.new(0, 0, 0, 0)
listView.AutomaticCanvasSize = Enum.AutomaticSize.Y
listView.Parent = zone
local lvc = Instance.new("UICorner"); lvc.CornerRadius = UDim.new(0, 10); lvc.Parent = listView
local lvl = Instance.new("UIListLayout")
lvl.Padding = UDim.new(0, 4); lvl.SortOrder = Enum.SortOrder.LayoutOrder; lvl.Parent = listView
local lvp = Instance.new("UIPadding")
lvp.PaddingTop = UDim.new(0, 8); lvp.PaddingBottom = UDim.new(0, 8)
lvp.PaddingLeft = UDim.new(0, 8); lvp.PaddingRight = UDim.new(0, 8)
lvp.Parent = listView

-- === VUE DÉTAIL ===
local detailView = Instance.new("ScrollingFrame")
detailView.Size = UDim2.new(1, 0, 1, 0)
detailView.BackgroundTransparency = 1
detailView.BorderSizePixel = 0
detailView.ScrollBarThickness = 5
detailView.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
detailView.CanvasSize = UDim2.new(0, 0, 0, 0)
detailView.AutomaticCanvasSize = Enum.AutomaticSize.Y
detailView.Visible = false
detailView.Parent = zone
local dvc = Instance.new("UICorner"); dvc.CornerRadius = UDim.new(0, 10); dvc.Parent = detailView
local dvl = Instance.new("UIListLayout")
dvl.Padding = UDim.new(0, 6); dvl.SortOrder = Enum.SortOrder.LayoutOrder; dvl.Parent = detailView
local dvp = Instance.new("UIPadding")
dvp.PaddingTop = UDim.new(0, 10); dvp.PaddingBottom = UDim.new(0, 10)
dvp.PaddingLeft = UDim.new(0, 10); dvp.PaddingRight = UDim.new(0, 10)
dvp.Parent = detailView

-- Contenu des instructions
local INSTRUCTIONS = {
    {title="🎃 Hauntlet", detail="Vas au portail Halloween.\n\n• Cherche un portail violet/vert près du spawn\n• Ou ouvre le menu 'Events' → Halloween\n• Entre dedans"},
    {title="🍬 Candy Corn", detail="Dans le Hauntlet :\n\n• Cherche des tas de bonbons oranges qui brillent au sol\n• Marche dessus OU clique dessus\n• Ramasse-en au moins 1"},
    {title="🕷️ Tomb Spider", detail="Cherche une tombe dans le Hauntlet :\n\n• Tombe en pierre avec une araignée dessus\n• Clique dessus\n• Un item ou une récompense apparaît"},
    {title="👻 Ghost Vacuum", detail="Utilise l'aspirateur à fantômes :\n\n• Équipe le 'Ghost Vacuum' (dans ton inventaire)\n• Va près d'un fantôme qui flotte\n• Clique sur 'Aspirer' ou utilise l'outil"},
    {title="🪶 Pigeon Jacobean", detail="Trouve le nid Jacobean :\n\n• Cherche un GRAND nid perché en haut\n• Ramasse une branche au sol\n• Clique sur le nid pour déposer la branche"},
    {title="⚡ Lightning Lever", detail="Active le levier lightning :\n\n• Cherche un GRAND levier en métal\n• Ressemble à un interrupteur Frankenstein\n• Marche dessus / clique pour l'activer"},
    {title="⚡ Livrer Lightning", detail="Après avoir activé le levier :\n\n• Un éclair / orbe apparaît\n• Ramasse-le\n• Porte-le au point de livraison indiqué"},
    {title="🐈 Stray Cat", detail="Nourris le chat errant :\n\n• Cherche un chat dans le Hauntlet\n• Achète de la nourriture pour chat\n• Clique sur le chat avec la nourriture en main"},
    {title="🔓 Padlock", detail="Déverrouille un cadenas :\n\n• Cherche un cadenas doré sur une porte/coffre\n• Clique dessus\n• Suis le puzzle si demandé"},
    {title="📖 Journal Hauntlet", detail="Débloque une page du journal :\n\n• Cherche une page / feuille qui brille\n• Souvent jaunâtre, par terre\n• Clique dessus pour la récupérer"},
    {title="🎮 Mini-jeu", detail="Joue à un mini-jeu complet :\n\n• Ouvre le menu 'Mini-games'\n• OU cherche une zone avec un portail\n• Rejoins une partie\n• Joue jusqu'à la fin (même 10 sec)"},
    {title="🐾 Pet action", detail="Action sur un pet :\n\n• Ouvre ton inventaire → équipe un pet\n• Utilise une NOURRITURE sur le pet\n• OU joue avec un jouet\n• OU lave-le dans une baignoire"},
    {title="🔄 Trade", detail="Fais un trade rapide :\n\n• Ouvre le menu Trade (icône échange)\n• Envoie une demande à n'importe qui\n• OU accepte une demande reçue\n• Pas besoin de compléter"},
}

local function showListView()
    detailView.Visible = false
    listView.Visible = true
end

local function showDetailView(data)
    -- Vider le détail
    for _, c in ipairs(detailView:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end

    -- Titre
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 30)
    t.BackgroundTransparency = 1
    t.Text = data.title
    t.TextColor3 = Color3.fromRGB(255, 130, 190)
    t.Font = Enum.Font.GothamBlack
    t.TextSize = 18
    t.TextXAlignment = Enum.TextXAlignment.Left
    t.LayoutOrder = 1
    t.Parent = detailView

    -- Séparateur
    local sep = Instance.new("Frame")
    sep.Size = UDim2.new(1, 0, 0, 2)
    sep.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
    sep.BackgroundTransparency = 0.5
    sep.BorderSizePixel = 0
    sep.LayoutOrder = 2
    sep.Parent = detailView

    -- Texte
    local d = Instance.new("TextLabel")
    d.Size = UDim2.new(1, 0, 0, 0)
    d.AutomaticSize = Enum.AutomaticSize.Y
    d.BackgroundTransparency = 1
    d.Text = data.detail
    d.TextColor3 = Color3.fromRGB(220, 220, 240)
    d.Font = Enum.Font.Gotham
    d.TextSize = 13
    d.TextXAlignment = Enum.TextXAlignment.Left
    d.TextYAlignment = Enum.TextYAlignment.Top
    d.TextWrapped = true
    d.LayoutOrder = 3
    d.Parent = detailView

    -- Bouton retour
    local backBtn = Instance.new("TextButton")
    backBtn.Size = UDim2.new(1, 0, 0, 40)
    backBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
    backBtn.Text = "⬅ RETOUR À LA LISTE"
    backBtn.TextColor3 = Color3.new(1, 1, 1)
    backBtn.Font = Enum.Font.GothamBold
    backBtn.TextSize = 13
    backBtn.AutoButtonColor = false
    backBtn.LayoutOrder = 4
    backBtn.Parent = detailView
    local bb = Instance.new("UICorner"); bb.CornerRadius = UDim.new(0, 8); bb.Parent = backBtn

    backBtn.MouseButton1Click:Connect(function()
        showListView()
    end)

    detailView.Visible = true
    listView.Visible = false
end

-- Construire la liste
local headerInstr = Instance.new("TextLabel")
headerInstr.Size = UDim2.new(1, 0, 0, 22)
headerInstr.BackgroundTransparency = 1
headerInstr.Text = "📋 Clique sur une action pour les détails :"
headerInstr.TextColor3 = Color3.fromRGB(255, 200, 100)
headerInstr.Font = Enum.Font.GothamBold
headerInstr.TextSize = 11
headerInstr.TextXAlignment = Enum.TextXAlignment.Left
headerInstr.LayoutOrder = 0
headerInstr.Parent = listView

for i, data in ipairs(INSTRUCTIONS) do
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 28)
    b.BackgroundColor3 = Color3.fromRGB(55, 55, 75)
    b.BorderSizePixel = 0
    b.Text = "  "..data.title
    b.TextColor3 = Color3.fromRGB(220, 220, 240)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.LayoutOrder = i
    b.Parent = listView
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = b

    b.MouseButton1Click:Connect(function()
        showDetailView(data)
    end)
end

-- Compteur
local counter = Instance.new("TextLabel")
counter.Size = UDim2.new(1, -20, 0, 26)
counter.Position = UDim2.new(0, 10, 0, 288)
counter.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
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
status.Text = "⏳ Init..."
status.TextColor3 = Color3.fromRGB(255, 200, 100)
status.Font = Enum.Font.GothamBold
status.TextSize = 11
status.TextXAlignment = Enum.TextXAlignment.Left
status.Parent = win

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

-- Boutons bas
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
-- LOGGING
-- ============================================================
local logQueue = {}
local logs = {}
local MAX_LOGS = 3000
local logCount = 0
local hookActive = true

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
            if count > 5 then table.insert(parts, "..."); break end
            table.insert(parts, tostring(k).."="..(type(vv)=="table" and "{...}" or tostring(vv)))
        end
        return "{"..table.concat(parts, ",").."}"
    elseif t == "EnumItem" then return tostring(v)
    else return tostring(v) end
end

-- HOOK
local oldNamecall = nil
local hooked = false

if hasGetRawMeta then
    local mt = getrawmetatable(game)
    if mt then
        oldNamecall = mt.__namecall
        if hasSetReadonly then setreadonly(mt, false) end

        mt.__namecall = function(self, ...)
            if hookActive and typeof(self) == "Instance" then
                local method = hasGetNamecall and getnamecallmethod() or ""
                if method == "FireServer" or method == "InvokeServer" then
                    local cls = self.ClassName
                    if cls == "RemoteEvent" or cls == "RemoteFunction" or cls == "UnreliableRemoteEvent" then
                        table.insert(logQueue, {
                            tag = (method == "FireServer") and "SEND" or "INVOKE",
                            name = self.Name,
                            args = {...},
                            time = os.clock(),
                        })
                    end
                end
            end
            return oldNamecall(self, ...)
        end

        if hasSetReadonly then setreadonly(mt, true) end
        hooked = true
    end
end

getgenv()._loggerV6Stop = function()
    if not hooked then return end
    hookActive = false
    if hasGetRawMeta then
        local mt = getrawmetatable(game)
        if mt and oldNamecall then
            if hasSetReadonly then setreadonly(mt, false) end
            mt.__namecall = oldNamecall
            if hasSetReadonly then setreadonly(mt, true) end
        end
    end
    hooked = false
end

getgenv()._loggerV6Resume = function()
    if hooked then hookActive = true; return end
    if not hasGetRawMeta then return end
    local mt = getrawmetatable(game)
    if not mt then return end
    oldNamecall = mt.__namecall
    if hasSetReadonly then setreadonly(mt, false) end
    mt.__namecall = function(self, ...)
        if hookActive and typeof(self) == "Instance" then
            local method = hasGetNamecall and getnamecallmethod() or ""
            if method == "FireServer" or method == "InvokeServer" then
                local cls = self.ClassName
                if cls == "RemoteEvent" or cls == "RemoteFunction" or cls == "UnreliableRemoteEvent" then
                    table.insert(logQueue, {
                        tag = (method == "FireServer") and "SEND" or "INVOKE",
                        name = self.Name,
                        args = {...},
                        time = os.clock(),
                    })
                end
            end
        end
        return oldNamecall(self, ...)
    end
    if hasSetReadonly then setreadonly(mt, true) end
    hooked = true
    hookActive = true
end

-- Boucle de traitement
local lastLogTime = {}
task.spawn(function()
    while sg.Parent do
        task.wait(0.3)
        if #logQueue == 0 then continue end

        local toProcess = math.min(#logQueue, 40)
        for i = 1, toProcess do
            local entry = logQueue[i]
            local name = entry.name
            if not lastLogTime[name] or (entry.time - lastLogTime[name]) > 0.4 then
                lastLogTime[name] = entry.time

                local parts = {}
                for j, a in ipairs(entry.args) do parts[j] = fmt(a) end
                local line = string.format("[%s] %s(%s)", entry.tag, name, table.concat(parts, ", "))

                table.insert(logs, line)
                if #logs > MAX_LOGS then table.remove(logs, 1) end
                logCount = logCount + 1

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

                local labels = {}
                for _, c in ipairs(preview:GetChildren()) do
                    if c:IsA("TextLabel") then table.insert(labels, c) end
                end
                if #labels > 15 then labels[1]:Destroy() end
            end
        end

        for i = toProcess, 1, -1 do table.remove(logQueue, i) end

        counter.Text = "📊 "..logCount.." logs capturés"
        pcall(function()
            preview.CanvasPosition = Vector2.new(0, preview.AbsoluteCanvasSize.Y)
        end)
    end
end)

pauseBtn.MouseButton1Click:Connect(function()
    if hookActive then
        getgenv()._loggerV6Stop()
        pauseBtn.Text = "▶ HOOK EN PAUSE - Clique pour reprendre"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 100)
        status.Text = "⏸ Hook en PAUSE"
        status.TextColor3 = Color3.fromRGB(255, 200, 100)
    else
        getgenv()._loggerV6Resume()
        pauseBtn.Text = "⏸ HOOK ACTIF - Clique pour PAUSE"
        pauseBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
        status.Text = "✅ Hook ACTIF"
        status.TextColor3 = Color3.fromRGB(120, 220, 150)
    end
end)

status.Text = hooked and "✅ Hook ACTIF - capture en cours" or "⚠️ Hook indisponible"
status.TextColor3 = hooked and Color3.fromRGB(120, 220, 150) or Color3.fromRGB(255, 200, 100)

doneBtn.MouseButton1Click:Connect(function()
    local output = "=== ADOPT ME LOGS "..os.date("%Y-%m-%d %H:%M:%S").." ===\n"
    output = output .. "Total: "..logCount.." logs\n\n"
    output = output .. table.concat(logs, "\n")

    local copied = false
    if hasSetClipboard then copied = pcall(setclipboard, output) end

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.new(0, 0, 0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 30
    overlay.Parent = sg

    local box = Instance.new("Frame")
    box.Size = UDim2.new(0, 320, 0, 200)
    box.Position = UDim2.new(0.5, -160, 0.5, -100)
    box.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
    box.BorderSizePixel = 0
    box.ZIndex = 31
    box.Parent = overlay
    local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 18); bc.Parent = box

    local bt = Instance.new("TextLabel")
    bt.Size = UDim2.new(1, 0, 0, 60); bt.Position = UDim2.new(0, 0, 0, 20)
    bt.BackgroundTransparency = 1; bt.Text = "✅ ACCOMPLI !"
    bt.TextColor3 = Color3.new(1, 1, 1)
    bt.Font = Enum.Font.GothamBlack; bt.TextSize = 30
    bt.ZIndex = 32; bt.Parent = box

    local bi = Instance.new("TextLabel")
    bi.Size = UDim2.new(1, -40, 0, 70); bi.Position = UDim2.new(0, 20, 0, 80)
    bi.BackgroundTransparency = 1
    bi.Text = copied and ("📋 "..logCount.." logs COPIÉS !\nColle dans le chat et envoie.")
        or ("⚠️ setclipboard indispo.\nFais un screenshot F9.")
    bi.TextColor3 = Color3.new(1, 1, 1)
    bi.Font = Enum.Font.GothamBold; bi.TextSize = 13
    bi.TextWrapped = true
    bi.ZIndex = 32; bi.Parent = box

    local cb = Instance.new("TextButton")
    cb.Size = UDim2.new(1, -40, 0, 36); cb.Position = UDim2.new(0, 20, 1, -46)
    cb.BackgroundColor3 = Color3.new(1, 1, 1)
    cb.Text = "OK Fermer"; cb.TextColor3 = Color3.fromRGB(120, 220, 150)
    cb.Font = Enum.Font.GothamBold; cb.TextSize = 14
    cb.ZIndex = 32; cb.Parent = box
    local cbc2 = Instance.new("UICorner"); cbc2.CornerRadius = UDim.new(0, 10); cbc2.Parent = cb
    cb.MouseButton1Click:Connect(function() overlay:Destroy() end)

    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9118823103"; s.Volume = 0.7
        s.Parent = game:GetService("SoundService"); s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
end)

clearBtn.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    counter.Text = "📊 0 logs capturés"
    for _, c in ipairs(preview:GetChildren()) do
        if c:IsA("TextLabel") then c:Destroy() end
    end
end)

print("[Logger v6] ✅ PRÊT")