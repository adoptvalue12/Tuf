-- Adopt Me Scanner V9 - Batch Copy Edition
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local SS = game:GetService("SoundService")
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")

-- Sons satisfaisants
local SND = {
    Click   = "rbxassetid://6895086596",
    Success = "rbxassetid://9118823103",
    Pop     = "rbxassetid://6042053627",
    Chime   = "rbxassetid://5873524714",
    Page    = "rbxassetid://4612375234",
    Finish  = "rbxassetid://9118823103",
}
local function playSnd(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = vol or 0.5
        s.Parent = SS
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
end

local sg = Instance.new("ScreenGui")
sg.Name = "AMScannerV9"
sg.ResetOnSpawn = false
sg.Parent = parentGui

-- Fenêtre
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 340, 0, 460)
win.Position = UDim2.new(0.5, -170, 0.5, -230)
win.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = sg
local cr = Instance.new("UICorner"); cr.CornerRadius = UDim.new(0, 12); cr.Parent = win
local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255, 130, 190); st.Thickness = 2; st.Parent = win

-- Header
local hd = Instance.new("TextLabel")
hd.Size = UDim2.new(1, 0, 0, 40)
hd.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
hd.Text = "🐾 Adopt Me Scanner v9"
hd.TextColor3 = Color3.new(1, 1, 1)
hd.Font = Enum.Font.GothamBold
hd.TextSize = 16
hd.Parent = win
local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 12); hc.Parent = hd
local fx = Instance.new("Frame"); fx.Size = UDim2.new(1, 0, 0, 15); fx.Position = UDim2.new(0, 0, 1, -15); fx.BackgroundColor3 = Color3.fromRGB(255, 130, 190); fx.BorderSizePixel = 0; fx.Parent = hd

-- Tab bar
local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, -20, 0, 34)
tabBar.Position = UDim2.new(0, 10, 0, 48)
tabBar.BackgroundColor3 = Color3.fromRGB(255, 235, 248)
tabBar.BorderSizePixel = 0
tabBar.Parent = win
local tbc = Instance.new("UICorner"); tbc.CornerRadius = UDim.new(0, 8); tbc.Parent = tabBar
local tbl = Instance.new("UIListLayout"); tbl.FillDirection = Enum.FillDirection.Horizontal; tbl.Padding = UDim.new(0, 4); tbl.Parent = tabBar
local tbp = Instance.new("UIPadding"); tbp.PaddingTop = UDim.new(0, 4); tbp.PaddingBottom = UDim.new(0, 4); tbp.PaddingLeft = UDim.new(0, 4); tbp.PaddingRight = UDim.new(0, 4); tbp.Parent = tabBar

-- Status
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -20, 0, 22)
statusLbl.Position = UDim2.new(0, 10, 0, 88)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Prêt. Clique sur 🔄 SCAN"
statusLbl.TextColor3 = Color3.fromRGB(80, 50, 100)
statusLbl.Font = Enum.Font.GothamBold
statusLbl.TextSize = 12
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = win

-- Content
local content = Instance.new("ScrollingFrame")
content.Size = UDim2.new(1, -20, 1, -250)
content.Position = UDim2.new(0, 10, 0, 116)
content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
content.BorderSizePixel = 0
content.ScrollBarThickness = 6
content.ScrollBarImageColor3 = Color3.fromRGB(255, 130, 190)
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.Parent = win
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 8); cc.Parent = content
local cs = Instance.new("UIStroke"); cs.Color = Color3.fromRGB(255, 200, 230); cs.Thickness = 1; cs.Parent = content
local cl = Instance.new("UIListLayout"); cl.SortOrder = Enum.SortOrder.LayoutOrder; cl.Padding = UDim.new(0, 3); cl.Parent = content
local cp = Instance.new("UIPadding"); cp.PaddingTop = UDim.new(0, 6); cp.PaddingBottom = UDim.new(0, 6); cp.PaddingLeft = UDim.new(0, 6); cp.PaddingRight = UDim.new(0, 6); cp.Parent = content

-- Footer 1 (actions principales)
local footer = Instance.new("Frame")
footer.Size = UDim2.new(1, -20, 0, 42)
footer.Position = UDim2.new(0, 10, 1, -100)
footer.BackgroundColor3 = Color3.fromRGB(255, 235, 248)
footer.BorderSizePixel = 0
footer.Parent = win
local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 10); fc.Parent = footer
local fl = Instance.new("UIListLayout"); fl.FillDirection = Enum.FillDirection.Horizontal; fl.Padding = UDim.new(0, 6); fl.VerticalAlignment = Enum.VerticalAlignment.Center; fl.HorizontalAlignment = Enum.HorizontalAlignment.Center; fl.Parent = footer
local fp = Instance.new("UIPadding"); fp.PaddingTop = UDim.new(0, 6); fp.PaddingBottom = UDim.new(0, 6); fp.PaddingLeft = UDim.new(0, 6); fp.PaddingRight = UDim.new(0, 6); fp.Parent = footer

-- Footer 2 (batch copy)
local footer2 = Instance.new("Frame")
footer2.Size = UDim2.new(1, -20, 0, 42)
footer2.Position = UDim2.new(0, 10, 1, -54)
footer2.BackgroundColor3 = Color3.fromRGB(220, 240, 255)
footer2.BorderSizePixel = 0
footer2.Parent = win
local fc2 = Instance.new("UICorner"); fc2.CornerRadius = UDim.new(0, 10); fc2.Parent = footer2
local fl2 = Instance.new("UIListLayout"); fl2.FillDirection = Enum.FillDirection.Horizontal; fl2.Padding = UDim.new(0, 6); fl2.VerticalAlignment = Enum.VerticalAlignment.Center; fl2.HorizontalAlignment = Enum.HorizontalAlignment.Center; fl2.Parent = footer2
local fp2 = Instance.new("UIPadding"); fp2.PaddingTop = UDim.new(0, 6); fp2.PaddingBottom = UDim.new(0, 6); fp2.PaddingLeft = UDim.new(0, 6); fp2.PaddingRight = UDim.new(0, 6); fp2.Parent = footer2

local function makeBtn(text, color, w, order, parent)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 1, 0)
    b.BackgroundColor3 = color
    b.Text = text
    b.TextColor3 = Color3.new(1, 1, 1)
    b.Font = Enum.Font.GothamBold
    b.TextSize = 12
    b.LayoutOrder = order
    b.Parent = parent or footer
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
    return b
end

local remotes, logs = {}, {}
local loggerActive = false
local hooked = {}
local activeTab = "scan"
local batchIndex = 0
local BATCH_SIZE = 200
local currentMode = "remotes" -- remotes / logs

-- Tabs
local tabs = {}
local function createTab(id, label, w)
    local b = makeBtn(label, Color3.fromRGB(255, 235, 248), w, #tabs + 1, tabBar)
    b.TextColor3 = Color3.fromRGB(160, 140, 180)
    tabs[id] = b
    b.MouseButton1Click:Connect(function()
        activeTab = id
        for tid, btn in pairs(tabs) do
            if tid == id then
                btn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
                btn.TextColor3 = Color3.new(1, 1, 1)
            else
                btn.BackgroundColor3 = Color3.fromRGB(255, 235, 248)
                btn.TextColor3 = Color3.fromRGB(160, 140, 180)
            end
        end
        playSnd(SND.Click, 0.2)
        renderTab()
    end)
    return b
end

createTab("scan", "📡 Remotes", 100)
createTab("log", "📝 Logs", 90)
createTab("help", "ℹ️ Aide", 80)

tabs.scan.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
tabs.scan.TextColor3 = Color3.new(1, 1, 1)

local function getPath(obj)
    local ok, p = pcall(function() return obj:GetFullName() end)
    return ok and p or obj.Name
end

local function clearContent()
    for _, ch in ipairs(content:GetChildren()) do
        if ch:IsA("GuiObject") then ch:Destroy() end
    end
end

local function makeRow(text, color, order)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -8, 0, 0)
    lbl.AutomaticSize = Enum.AutomaticSize.Y
    lbl.BackgroundColor3 = color or Color3.fromRGB(255, 245, 252)
    lbl.BorderSizePixel = 0
    lbl.Text = "  " .. text
    lbl.TextColor3 = Color3.fromRGB(80, 50, 100)
    lbl.Font = Enum.Font.Code
    lbl.TextSize = 11
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.TextWrapped = true
    lbl.LayoutOrder = order
    lbl.Parent = content
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = lbl
    local p = Instance.new("UIPadding"); p.PaddingTop = UDim.new(0, 4); p.PaddingBottom = UDim.new(0, 4); p.PaddingLeft = UDim.new(0, 6); p.PaddingRight = UDim.new(0, 6); p.Parent = lbl
    return lbl
end

function renderTab()
    clearContent()
    if activeTab == "scan" then
        if #remotes == 0 then
            makeRow("Aucun remote. Clique sur 🔄 SCAN.", Color3.fromRGB(255, 245, 252), 1)
            return
        end
        makeRow("📡 " .. #remotes .. " remotes · " .. math.ceil(#remotes / BATCH_SIZE) .. " lots de " .. BATCH_SIZE, Color3.fromRGB(220, 240, 255), 1)
        for i, r in ipairs(remotes) do
            local icon = "🔹"
            if r.class == "RemoteFunction" then icon = "🔶" end
            if r.class == "UnreliableRemoteEvent" then icon = "⚡" end
            local col = Color3.fromRGB(255, 245, 252)
            if i % 2 == 0 then col = Color3.fromRGB(255, 235, 248) end
            makeRow("[" .. i .. "] " .. icon .. " " .. r.name .. "\n     " .. r.path, col, i + 1)
        end
    elseif activeTab == "log" then
        if #logs == 0 then
            makeRow("Aucun log. Active le logger.", Color3.fromRGB(255, 245, 252), 1)
            return
        end
        makeRow("📝 " .. #logs .. " logs · " .. math.ceil(#logs / BATCH_SIZE) .. " lots", Color3.fromRGB(220, 240, 255), 1)
        for i, log in ipairs(logs) do
            local col = Color3.fromRGB(255, 245, 252)
            if i % 2 == 0 then col = Color3.fromRGB(255, 235, 248) end
            makeRow(log, col, i + 1)
        end
    elseif activeTab == "help" then
        makeRow("🐾 COMMENT COPIER PAR LOTS", Color3.fromRGB(220, 240, 255), 1)
        makeRow("1. Clique sur 🔄 SCAN", nil, 2)
        makeRow("2. Va sur 📡 Remotes pour voir la liste", nil, 3)
        makeRow("3. Clique ▶ LOG, joue à Adopt Me 1 min", nil, 4)
        makeRow("5. Reviens, clique sur 📦 LOT SUIVANT", nil, 5)
        makeRow("6. Colle dans ton app de notes (Discord, Notes, etc.)", nil, 6)
        makeRow("7. Re-clique 📦 LOT SUIVANT pour le prochain 200", nil, 7)
        makeRow("8. Continue jusqu'à 'Terminé !'", nil, 8)
        makeRow("───────────────────", Color3.fromRGB(255, 220, 240), 9)
        makeRow("🎯 Le compteur affiche 'Lot X/Y'", nil, 10)
        makeRow("🔄 Bouton RESET pour recommencer", nil, 11)
        makeRow("💾 Bouton SAVE FILE pour un fichier .txt", nil, 12)
    end
end

-- Boutons
local btnScan = makeBtn("🔄 SCAN", Color3.fromRGB(180, 140, 240), 100, 1)
local btnLog  = makeBtn("▶ LOG", Color3.fromRGB(255, 130, 190), 100, 2)
local btnCopy = makeBtn("📋 COPY ALL", Color3.fromRGB(120, 220, 150), 100, 3)

-- Batch copy buttons
local btnBatch = makeBtn("📦 LOT SUIVANT", Color3.fromRGB(255, 180, 80), 150, 1, footer2)
local btnMode  = makeBtn("📡 Remotes", Color3.fromRGB(180, 140, 240), 90, 2, footer2)
local btnReset = makeBtn("🔄 RESET", Color3.fromRGB(255, 120, 130), 60, 3, footer2)

-- Toggle mode
btnMode.MouseButton1Click:Connect(function()
    if currentMode == "remotes" then
        currentMode = "logs"
        btnMode.Text = "📝 Logs"
        btnMode.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
    else
        currentMode = "remotes"
        btnMode.Text = "📡 Remotes"
        btnMode.BackgroundColor3 = Color3.fromRGB(180, 140, 240)
    end
    batchIndex = 0
    playSnd(SND.Click, 0.3)
    statusLbl.Text = "Mode : " .. currentMode .. " · Lot remis à 0"
end)

-- SCAN
btnScan.MouseButton1Click:Connect(function()
    playSnd(SND.Page, 0.3)
    statusLbl.Text = "Scan en cours..."
    remotes = {}
    local roots = {
        game:GetService("ReplicatedStorage"),
        game:GetService("Workspace"),
        LocalPlayer:FindFirstChild("PlayerScripts"),
        LocalPlayer:FindFirstChild("PlayerGui"),
        LocalPlayer:FindFirstChild("Backpack"),
        LocalPlayer.Character,
        game:GetService("ReplicatedFirst"),
        game:GetService("Lighting"),
    }
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") or obj:IsA("BindableEvent") then
                    table.insert(remotes, {name = obj.Name, path = getPath(obj), ref = obj, class = obj.ClassName})
                end
            end
        end
    end
    table.sort(remotes, function(a, b) return a.path < b.path end)
    batchIndex = 0
    statusLbl.Text = "✅ " .. #remotes .. " remotes · " .. math.ceil(#remotes / BATCH_SIZE) .. " lots"
    playSnd(SND.Success, 0.5)
    if activeTab == "scan" then renderTab() end
end)

-- LOGGER
btnLog.MouseButton1Click:Connect(function()
    loggerActive = not loggerActive
    if loggerActive then
        btnLog.Text = "⏹ STOP"
        btnLog.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        statusLbl.Text = "Logger ACTIF - Joue !"
        playSnd(SND.Success, 0.5)
        for _, data in ipairs(remotes) do
            local remote = data.ref
            if not hooked[remote] then
                hooked[remote] = true
                if remote:IsA("RemoteEvent") or remote:IsA("UnreliableRemoteEvent") then
                    local old = remote.FireServer
                    remote.FireServer = function(self, ...)
                        if loggerActive then
                            local a = {...}
                            local s = ""
                            for i, v in ipairs(a) do
                                s = s .. tostring(v) .. (i < #a and ", " or "")
                            end
                            table.insert(logs, "[SEND] " .. remote.Name .. "(" .. s .. ")")
                            statusLbl.Text = "Logs: " .. #logs
                            if activeTab == "log" then renderTab() end
                        end
                        return old(self, ...)
                    end
                    remote.OnClientEvent:Connect(function(...)
                        if loggerActive then
                            local a = {...}
                            local s = ""
                            for i, v in ipairs(a) do
                                s = s .. tostring(v) .. (i < #a and ", " or "")
                            end
                            table.insert(logs, "[RECV] " .. remote.Name .. "(" .. s .. ")")
                            if activeTab == "log" then renderTab() end
                        end
                    end)
                elseif remote:IsA("RemoteFunction") then
                    local old = remote.InvokeServer
                    remote.InvokeServer = function(self, ...)
                        if loggerActive then
                            local a = {...}
                            local s = ""
                            for i, v in ipairs(a) do
                                s = s .. tostring(v) .. (i < #a and ", " or "")
                            end
                            table.insert(logs, "[INVOKE] " .. remote.Name .. "(" .. s .. ")")
                            statusLbl.Text = "Logs: " .. #logs
                            if activeTab == "log" then renderTab() end
                        end
                        return old(self, ...)
                    end
                end
            end
        end
    else
        btnLog.Text = "▶ LOG"
        btnLog.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
        statusLbl.Text = "Logger arrêté. " .. #logs .. " logs."
        playSnd(SND.Pop, 0.4)
    end
end)

-- COPY ALL
btnCopy.MouseButton1Click:Connect(function()
    if type(setclipboard) ~= "function" then
        statusLbl.Text = "❌ setclipboard non supporté"
        return
    end
    local output = ""
    if currentMode == "remotes" then
        output = "=== REMOTES (" .. #remotes .. ") ===\n"
        for i, r in ipairs(remotes) do
            output = output .. "[" .. i .. "] (" .. r.class .. ") " .. r.path .. "\n"
        end
    else
        output = "=== LOGS (" .. #logs .. ") ===\n"
        for _, log in ipairs(logs) do output = output .. log .. "\n" end
    end
    setclipboard(output)
    playSnd(SND.Chime, 0.6)
    statusLbl.Text = "📋 Copié ! (" .. #output .. " caractères)"
end)

-- BATCH COPY (le système principal)
btnBatch.MouseButton1Click:Connect(function()
    if type(setclipboard) ~= "function" then
        statusLbl.Text = "❌ setclipboard non supporté"
        return
    end
    
    local data = (currentMode == "remotes") and remotes or logs
    local total = #data
    if total == 0 then
        statusLbl.Text = "❌ Rien à copier. Fais un SCAN ou active LOG."
        playSnd(SND.Pop, 0.4)
        return
    end
    
    local totalBatches = math.ceil(total / BATCH_SIZE)
    if batchIndex >= totalBatches then
        statusLbl.Text = "✅ Terminé ! Tous les lots copiés (" .. totalBatches .. ")"
        playSnd(SND.Finish, 0.7)
        return
    end
    
    local startIdx = batchIndex * BATCH_SIZE + 1
    local endIdx = math.min(startIdx + BATCH_SIZE - 1, total)
    
    local output = ""
    if currentMode == "remotes" then
        output = "=== REMOTES " .. startIdx .. "-" .. endIdx .. "/" .. total .. " ===\n"
        for i = startIdx, endIdx do
            local r = data[i]
            output = output .. "[" .. i .. "] (" .. r.class .. ") " .. r.path .. "\n"
        end
    else
        output = "=== LOGS " .. startIdx .. "-" .. endIdx .. "/" .. total .. " ===\n"
        for i = startIdx, endIdx do
            output = output .. data[i] .. "\n"
        end
    end
    
    setclipboard(output)
    batchIndex = batchIndex + 1
    
    local remain = totalBatches - batchIndex
    if remain == 0 then
        statusLbl.Text = "🎉 LOT " .. batchIndex .. "/" .. totalBatches .. " copié · TERMINÉ !"
        playSnd(SND.Finish, 0.8)
    else
        statusLbl.Text = "📦 LOT " .. batchIndex .. "/" .. totalBatches .. " copié (" .. (endIdx - startIdx + 1) .. " lignes) · " .. remain .. " restant(s)"
        playSnd(SND.Chime, 0.5)
    end
end)

-- RESET
btnReset.MouseButton1Click:Connect(function()
    batchIndex = 0
    statusLbl.Text = "🔄 Compteur remis à 0 · Prochain lot = 1/" .. math.ceil(((currentMode == "remotes") and #remotes or #logs) / BATCH_SIZE)
    playSnd(SND.Click, 0.3)
end)

renderTab()