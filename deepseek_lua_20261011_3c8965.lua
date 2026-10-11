--[[ Adopt Me Scanner v6 — Rayfield Edition ]]

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst   = game:GetService("ReplicatedFirst")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local SoundService      = game:GetService("SoundService")
local LocalPlayer       = Players.LocalPlayer

local hasSetClipboard  = type(setclipboard) == "function"
local hasWriteFile     = type(writefile) == "function"
local hasReadFile      = type(readfile) == "function"
local hasIsFile        = type(isfile) == "function"
local hasNewCclosure   = type(newcclosure) == "function"
local function ncc(f) if hasNewCclosure then return newcclosure(f) end return f end

local foundRemotes, remoteRefs, hookedSet, callCounts = {}, {}, {}, {}
local logs, logActive, logCount = {}, false, 0
local autoCopy, alertActive = false, false
local filters = {
    RemoteEvent = true, RemoteFunction = true, UnreliableRemoteEvent = true,
    BindableEvent = true, BindableFunction = true,
}

local SND = {
    Click="rbxassetid://6895086596", Success="rbxassetid://9118823103",
    Scan="rbxassetid://4612375234", Pop="rbxassetid://6895086596",
    Alert="rbxassetid://5873524714",
}
local function playSnd(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id; s.Volume = vol or 0.5; s.Parent = SoundService
        s:Play(); task.delay(3, function() s:Destroy() end)
    end)
end

local function getPath(o)
    local ok, p = pcall(function() return o:GetFullName() end)
    return ok and p or o.Name
end

local function scanObject(container, seen, list)
    if not container or seen[container] then return end
    seen[container] = true
    for _, o in ipairs(container:GetDescendants()) do
        local c = o.ClassName
        if c == "RemoteEvent" or c == "RemoteFunction" or c == "UnreliableRemoteEvent"
        or c == "BindableEvent" or c == "BindableFunction" then
            table.insert(list, {path=getPath(o), class=c, name=o.Name, ref=o})
        end
    end
end

local function doScan()
    foundRemotes, remoteRefs = {}, {}
    local seen, results = {}, {}
    local roots = {
        ReplicatedStorage, ReplicatedFirst, Workspace,
        LocalPlayer:FindFirstChild("PlayerScripts"),
        LocalPlayer:FindFirstChild("PlayerGui"),
        LocalPlayer:FindFirstChild("Backpack"),
        LocalPlayer.Character, Lighting, SoundService,
    }
    for _, r in ipairs(roots) do pcall(scanObject, r, seen, results) end
    task.wait(0.3)
    for _, r in ipairs(roots) do pcall(scanObject, r, seen, results) end
    table.sort(results, function(a, b) return a.path < b.path end)
    foundRemotes = results
    for _, r in ipairs(results) do table.insert(remoteRefs, r.ref) end
end

local MAX_LOGS = 500
local function addLog(tag, remoteName, args, remoteRef)
    if not logActive then return end
    local parts = {}
    for i, v in ipairs(args) do
        local ok, s = pcall(function()
            if type(v) == "table" then
                local inner = {}
                for k, vv in pairs(v) do table.insert(inner, tostring(k).."="..tostring(vv)) end
                return "{"..table.concat(inner, ",").."}"
            end
            return tostring(v)
        end)
        parts[i] = ok and s or "?"
    end
    local text = string.format("[%s] %s %s(%s)", os.date("%H:%M:%S"), tag, remoteName, table.concat(parts, ", "))
    table.insert(logs, text)
    if #logs > MAX_LOGS then table.remove(logs, 1) end
    if remoteRef then callCounts[remoteRef] = (callCounts[remoteRef] or 0) + 1 end
    logCount = logCount + 1
    if alertActive then
        for _, s in ipairs({"kick","ban","detect","anti","guard","report","punish"}) do
            if remoteName:lower():find(s, 1, true) then
                Rayfield:Notify({Title="🚨 ALERTE", Content=remoteName.." suspect !", Duration=5})
                playSnd(SND.Alert, 0.8); break
            end
        end
    end
end

local function hookRemote(remote)
    if hookedSet[remote] then return end
    hookedSet[remote] = true
    local cls = remote.ClassName
    if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" then
        local oldFire = remote.FireServer
        remote.FireServer = ncc(function(self, ...)
            pcall(addLog, "SEND", remote.Name, {...}, remote)
            return oldFire(self, ...)
        end)
        remote.OnClientEvent:Connect(function(...)
            pcall(addLog, "RECV", remote.Name, {...}, remote)
        end)
    elseif cls == "RemoteFunction" then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = ncc(function(self, ...)
            pcall(addLog, "INVOKE", remote.Name, {...}, remote)
            return oldInvoke(self, ...)
        end)
    end
end

local function buildCopyText()
    local L = {"=== ADOPT ME SCANNER v6 ===", "Date: "..os.date("%Y-%m-%d %H:%M:%S"),
               "Remotes: "#foundRemotes, "Logs: "#logs, "", "-- REMOTES --"}
    for i, r in ipairs(foundRemotes) do
        table.insert(L, string.format("[%d] (%s) %s [%d]", i, r.class, r.path, callCounts[r.ref] or 0))
    end
    table.insert(L, ""); table.insert(L, "-- LOGS --")
    for _, l in ipairs(logs) do table.insert(L, l) end
    return table.concat(L, "\n")
end

-- ============================
-- UI RAYFIELD
-- ============================
local Window = Rayfield:CreateWindow({
    Name = "🐾 Adopt Me Scanner v6",
    LoadingTitle = "Chargement...",
    LoadingSubtitle = "Scanner de remotes",
    ConfigurationSaving = { Enabled = false },
    KeySystem = false,
})

-- === SCAN TAB ===
local ScanTab = Window:CreateTab("🔍 Scan", nil)
ScanTab:CreateSection("Actions")

ScanTab:CreateButton({
    Name = "🔄 Scanner les remotes",
    Callback = function()
        playSnd(SND.Scan, 0.4)
        Rayfield:Notify({Title="🔍 Scan", Content="Recherche en cours...", Duration=2})
        task.spawn(function()
            doScan()
            local cE, cF = 0, 0
            for _, r in ipairs(foundRemotes) do
                if r.class == "RemoteEvent" or r.class == "UnreliableRemoteEvent" then cE = cE + 1 end
                if r.class == "RemoteFunction" then cF = cF + 1 end
            end
            playSnd(SND.Success, 0.5)
            Rayfield:Notify({
                Title = "✅ Scan terminé",
                Content = string.format("%d remotes · %d events · %d functions", #foundRemotes, cE, cF),
                Duration = 6,
            })
            if autoCopy and hasSetClipboard then
                setclipboard(buildCopyText())
                Rayfield:Notify({Title="📋 Auto-copy", Content="Résultats copiés !", Duration=3})
            end
        end)
    end,
})

ScanTab:CreateButton({
    Name = "📋 Voir la liste des remotes (console)",
    Callback = function()
        for i, r in ipairs(foundRemotes) do
            print(string.format("[%d] (%s) %s", i, r.class, r.path))
        end
        Rayfield:Notify({Title="📋 Liste", Content=#foundRemotes.." remotes affichés en console (F9)", Duration=4})
    end,
})

ScanTab:CreateSection("Info")
ScanTab:CreateParagraph({
    Title = "💡 Comment faire",
    Content = "1. Clique sur '🔄 Scanner'\n2. Va dans l'onglet Logs, active le logger\n3. Joue à Adopt Me (œufs, pets, Halloween, trades)\n4. Clique sur '📋 Copier tout'\n5. Envoie le résultat au dev",
})

-- === LOGS TAB ===
local LogTab = Window:CreateTab("📝 Logs", nil)
LogTab:CreateSection("Logger")

LogTab:CreateToggle({
    Name = "▶ Activer le logger",
    CurrentValue = false,
    Flag = "loggerActive",
    Callback = function(val)
        logActive = val
        if val then
            for _, r in ipairs(remoteRefs) do pcall(hookRemote, r) end
            ReplicatedStorage.DescendantAdded:Connect(function(o)
                local c = o.ClassName
                if c == "RemoteEvent" or c == "RemoteFunction" or c == "UnreliableRemoteEvent" then
                    task.wait(0.1)
                    pcall(hookRemote, o)
                end
            end)
            playSnd(SND.Success, 0.4)
            Rayfield:Notify({Title="▶ Logger", Content="Activé - joue à Adopt Me !", Duration=4})
        else
            Rayfield:Notify({Title="⏸ Logger", Content="Désactivé", Duration=2})
        end
    end,
})

LogTab:CreateSection("Actions")

LogTab:CreateButton({
    Name = "📋 Copier tout (remotes + logs)",
    Callback = function()
        if not hasSetClipboard then
            Rayfield:Notify({Title="❌ Erreur", Content="setclipboard non supporté", Duration=4})
            return
        end
        setclipboard(buildCopyText())
        playSnd(SND.Success, 0.5)
        Rayfield:Notify({
            Title = "📋 Copié !",
            Content = #foundRemotes.." remotes, "#logs.." logs",
            Duration = 4,
        })
    end,
})

LogTab:CreateButton({
    Name = "🗑 Effacer les logs",
    Callback = function()
        logs, logCount, callCounts = {}, 0, {}
        Rayfield:Notify({Title="🗑 Effacé", Content="Logs réinitialisés", Duration=2})
    end,
})

LogTab:CreateButton({
    Name = "🔢 Nombre de logs actuellement",
    Callback = function()
        Rayfield:Notify({Title="📊 Stats", Content="Logs: "#logCount.." / Remotes: "#foundRemotes, Duration=4})
    end,
})

-- === FILTRES TAB ===
local FilterTab = Window:CreateTab("🎯 Filtres", nil)
FilterTab:CreateSection("Types affichés")

for cls, _ in pairs(filters) do
    FilterTab:CreateToggle({
        Name = cls,
        CurrentValue = true,
        Flag = "filter_"..cls,
        Callback = function(val) filters[cls] = val end,
    })
end

-- === OUTILS TAB ===
local ToolsTab = Window:CreateTab("🔧 Outils", nil)
ToolsTab:CreateSection("Auto-Inject")

ToolsTab:CreateButton({
    Name = "🔗 Capturer le prochain FireServer / InvokeServer",
    Callback = function()
        if not hasSetClipboard or not getrawmetatable then
            Rayfield:Notify({Title="❌ Erreur", Content="Fonctions non supportées", Duration=4})
            return
        end
        Rayfield:Notify({Title="🔗 Auto-Inject", Content="En attente... clique un bouton dans Adopt Me", Duration=6})
        local mt = getrawmetatable(game)
        if not mt then return end
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        local captured = false
        mt.__namecall = ncc(function(self, ...)
            local m = getnamecallmethod()
            if not captured and (m == "FireServer" or m == "InvokeServer") then
                captured = true
                local out = {}
                for i, v in ipairs({...}) do
                    local t = typeof(v)
                    if t == "Vector3" then out[i] = string.format("Vector3.new(%.2f,%.2f,%.2f)", v.X, v.Y, v.Z)
                    elseif t == "string" then out[i] = string.format("%q", v)
                    elseif t == "Instance" then out[i] = v:GetFullName()
                    else out[i] = tostring(v) end
                end
                local final = string.format("%s:%s(%s)", self:GetFullName(), m, table.concat(out, ", "))
                setclipboard(final)
                print("[Auto-Inject] "..final)
                playSnd(SND.Success, 0.6)
                Rayfield:Notify({Title="✅ Capturé !", Content=final:sub(1, 80), Duration=6})
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end
            return oldNamecall(self, ...)
        end)
        task.delay(30, function()
            pcall(function()
                if not captured then
                    mt.__namecall = oldNamecall
                    setreadonly(mt, true)
                    Rayfield:Notify({Title="⏱ Timeout", Content="Auto-inject désactivé", Duration=3})
                end
            end)
        end)
    end,
})

ToolsTab:CreateSection("Sauvegarde")

ToolsTab:CreateButton({
    Name = "💾 Sauvegarder dans un fichier",
    Callback = function()
        if not hasWriteFile then
            Rayfield:Notify({Title="❌ Erreur", Content="writefile non supporté", Duration=4})
            return
        end
        local ok = pcall(function() writefile("adopt_me_v6.txt", buildCopyText()) end)
        if ok then
            playSnd(SND.Success, 0.5)
            Rayfield:Notify({Title="💾 Sauvegardé", Content="adopt_me_v6.txt", Duration=4})
        else
            Rayfield:Notify({Title="❌ Erreur", Content="Échec sauvegarde", Duration=4})
        end
    end,
})

ToolsTab:CreateButton({
    Name = "📂 Charger le fichier de logs",
    Callback = function()
        if not hasReadFile or not hasIsFile then
            Rayfield:Notify({Title="❌ Erreur", Content="readfile non supporté", Duration=4})
            return
        end
        if not isfile("adopt_me_v6.txt") then
            Rayfield:Notify({Title="⚠️", Content="Aucun fichier trouvé", Duration=4})
            return
        end
        local c = readfile("adopt_me_v6.txt")
        print(c)
        Rayfield:Notify({Title="📂 Chargé", Content="Voir console (F9)", Duration=4})
    end,
})

ToolsTab:CreateSection("Options")

ToolsTab:CreateToggle({
    Name = "📋 Auto-copy à la fin du scan",
    CurrentValue = false,
    Flag = "autoCopy",
    Callback = function(val) autoCopy = val end,
})

ToolsTab:CreateToggle({
    Name = "🚨 Alerte détection (Kick/Ban/Detect)",
    CurrentValue = false,
    Flag = "alertActive",
    Callback = function(val)
        alertActive = val
        Rayfield:Notify({Title="🚨 Alerte", Content=val and "Activée" or "Désactivée", Duration=2})
    end,
})

ToolsTab:CreateButton({
    Name = "🔄 Reset les compteurs d'appels",
    Callback = function()
        callCounts = {}
        Rayfield:Notify({Title="🔄 Reset", Content="Compteurs réinitialisés", Duration=2})
    end,
})

-- === MINI-JEU TAB ===
local GameTab = Window:CreateTab("🎮 Mini-jeu", nil)
GameTab:CreateSection("Tap the Pet")

GameTab:CreateParagraph({
    Title = "🎮 Tap the Pet",
    Content = "Un mini-jeu de 30 secondes pour patienter pendant le scan. Tape un maximum de pets qui apparaissent !",
})

GameTab:CreateButton({
    Name = "▶ Ouvrir / Fermer le mini-jeu",
    Callback = function() openMiniGame() end,
})

-- === INFOS TAB ===
local InfoTab = Window:CreateTab("ℹ️ Infos", nil)
InfoTab:CreateSection("À propos")
InfoTab:CreateParagraph({
    Title = "🐾 Adopt Me Scanner v6",
    Content = "Scanner les remotes d'Adopt Me pour créer un autofarm sur mesure. Aucun code distant chargé à part Rayfield (source officielle).",
})
InfoTab:CreateSection("Raccourcis clavier (PC)")
InfoTab:CreateParagraph({
    Title = "⌨️",
    Content = "RightShift : Scanner\nRightControl : Toggle logger\nRightAlt : Copier tout",
})

-- ============================
-- MINI-JEU (ScreenGui séparée)
-- ============================
local miniGui = nil

function openMiniGame()
    if miniGui then miniGui:Destroy(); miniGui = nil; return end
    local parent = (gethui and gethui()) or game:GetService("CoreGui")

    miniGui = Instance.new("ScreenGui")
    miniGui.Name = "AMMiniGame_"..math.random(10000, 99999)
    miniGui.ResetOnSpawn = false
    miniGui.Parent = parent

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 380, 0, 420)
    frame.Position = UDim2.new(0.5, -190, 0.5, -210)
    frame.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
    frame.BorderSizePixel = 0
    frame.Parent = miniGui
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 16); c.Parent = frame
    local st = Instance.new("UIStroke"); st.Color = Color3.fromRGB(255, 130, 190); st.Thickness = 2; st.Parent = frame

    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
    header.BorderSizePixel = 0
    header.Parent = frame
    local hc = Instance.new("UICorner"); hc.CornerRadius = UDim.new(0, 16); hc.Parent = header

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -60, 1, 0)
    title.Position = UDim2.new(0, 12, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "🎮  TAP THE PET"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -38, 0, 10)
    closeBtn.BackgroundColor3 = Color3.new(1, 1, 1)
    closeBtn.BackgroundTransparency = 0.7
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = Color3.new(1, 1, 1)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 16
    closeBtn.Parent = header
    local cbc = Instance.new("UICorner"); cbc.CornerRadius = UDim.new(0, 10); cbc.Parent = closeBtn
    closeBtn.MouseButton1Click:Connect(function() miniGui:Destroy(); miniGui = nil end)

    local scoreBar = Instance.new("Frame")
    scoreBar.Size = UDim2.new(1, -20, 0, 30)
    scoreBar.Position = UDim2.new(0, 10, 0, 58)
    scoreBar.BackgroundTransparency = 1
    scoreBar.Parent = frame
    local sbL = Instance.new("UIListLayout"); sbL.FillDirection = Enum.FillDirection.Horizontal; sbL.Padding = UDim.new(0, 6); sbL.Parent = scoreBar

    local function chip(color, text)
        local l = Instance.new("TextLabel")
        l.Size = UDim2.new(0, 108, 1, 0)
        l.BackgroundColor3 = color
        l.BackgroundTransparency = 0.85
        l.Text = text
        l.TextColor3 = Color3.fromRGB(80, 50, 100)
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.Parent = scoreBar
        local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 8); cc.Parent = l
        return l
    end
    local scoreLbl = chip(Color3.fromRGB(255, 130, 190), "🏆 0")
    local bestLbl  = chip(Color3.fromRGB(180, 140, 240), "⭐ 0")
    local timeLbl  = chip(Color3.fromRGB(150, 230, 200), "⏱ 30s")

    local field = Instance.new("Frame")
    field.Size = UDim2.new(1, -20, 0, 260)
    field.Position = UDim2.new(0, 10, 0, 96)
    field.BackgroundColor3 = Color3.fromRGB(190, 230, 255)
    field.BorderSizePixel = 0
    field.ClipsDescendants = true
    field.Parent = frame
    local fc = Instance.new("UICorner"); fc.CornerRadius = UDim.new(0, 12); fc.Parent = field

    local fieldMsg = Instance.new("TextLabel")
    fieldMsg.Size = UDim2.new(1, 0, 1, 0)
    fieldMsg.BackgroundTransparency = 1
    fieldMsg.Text = "🐾  Appuie sur DÉMARRER"
    fieldMsg.TextColor3 = Color3.fromRGB(140, 180, 220)
    fieldMsg.Font = Enum.Font.GothamBold
    fieldMsg.TextSize = 15
    fieldMsg.Parent = field

    local startBtn = Instance.new("TextButton")
    startBtn.Size = UDim2.new(1, -20, 0, 38)
    startBtn.Position = UDim2.new(0, 10, 1, -48)
    startBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
    startBtn.Text = "▶  DÉMARRER"
    startBtn.TextColor3 = Color3.new(1, 1, 1)
    startBtn.Font = Enum.Font.GothamBold
    startBtn.TextSize = 13
    startBtn.Parent = frame
    local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0, 10); sbc.Parent = startBtn

    -- Drag mini-game
    local drag, dStart, sPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            drag = true; dStart = input.Position; sPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then drag = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if drag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dStart
            frame.Position = UDim2.new(sPos.X.Scale, sPos.X.Offset + d.X, sPos.Y.Scale, sPos.Y.Offset + d.Y)
        end
    end)

    local running, score, best = false, 0, 0
    local pets = {"🐶","🐱","🐰","🐲","🦄","🐧","🐢","🦊","🐼","🐸"}
    local colors = {
        Color3.fromRGB(255,200,130), Color3.fromRGB(200,180,255),
        Color3.fromRGB(255,200,230), Color3.fromRGB(180,220,180),
        Color3.fromRGB(255,220,240), Color3.fromRGB(180,200,255),
        Color3.fromRGB(170,220,170), Color3.fromRGB(255,180,120),
        Color3.fromRGB(240,240,240), Color3.fromRGB(180,230,140),
    }

    local function spawnPet()
        if not running then return end
        local idx = math.random(1, #pets)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 0, 0, 0)
        btn.Position = UDim2.new(math.random()*0.85, 0, math.random()*0.75, 0)
        btn.BackgroundColor3 = colors[idx]
        btn.Text = pets[idx]
        btn.TextSize = 28
        btn.Font = Enum.Font.GothamBold
        btn.TextColor3 = Color3.fromRGB(80, 50, 100)
        btn.Parent = field
        local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 27); bc.Parent = btn
        local bs = Instance.new("UIStroke"); bs.Color = Color3.new(1,1,1); bs.Thickness = 2; bs.Transparency = 0.2; bs.Parent = btn

        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size=UDim2.new(0,54,0,54)}):Play()

        local clicked = false
        btn.MouseButton1Click:Connect(function()
            if clicked or not running then return end
            clicked = true
            score = score + 1
            scoreLbl.Text = "🏆 "..score
            playSnd(SND.Pop, 0.4)
            TweenService:Create(btn, TweenInfo.new(0.15), {Size=UDim2.new(0,0,0,0), BackgroundTransparency=1}):Play()
            task.wait(0.15); btn:Destroy()
        end)

        task.delay(1.5, function()
            if btn.Parent and not clicked then
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency=1, Size=UDim2.new(0,0,0,0)}):Play()
                task.wait(0.25); btn:Destroy()
            end
        end)
    end

    startBtn.MouseButton1Click:Connect(function()
        if running then return end
        running = true; score = 0
        scoreLbl.Text = "🏆 0"
        startBtn.Text = "⏸  EN COURS..."
        startBtn.BackgroundColor3 = Color3.fromRGB(255, 120, 130)
        playSnd(SND.Scan, 0.4)
        for _, ch in ipairs(field:GetChildren()) do
            if ch:IsA("TextButton") then ch:Destroy() end
        end
        fieldMsg.Text = ""
        local endTime = tick() + 30
        task.spawn(function()
            while running do
                local left = math.max(0, math.ceil(endTime - tick()))
                timeLbl.Text = "⏱ "..left.."s"
                if left <= 0 then break end
                spawnPet()
                task.wait(math.random(50,90)/100)
            end
        end)
        task.delay(30, function()
            running = false
            startBtn.Text = "▶  DÉMARRER"
            startBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
            if score > best then
                best = score
                bestLbl.Text = "⭐ "..best
                playSnd(SND.Success, 0.6)
                Rayfield:Notify({Title="🏆 Record !", Content="Score: "..score, Duration=4})
            else
                Rayfield:Notify({Title="🏁 Fini", Content="Score: "..score, Duration=3})
            end
            for _, ch in ipairs(field:GetChildren()) do
                if ch:IsA("TextButton") then ch:Destroy() end
            end
            fieldMsg.Text = "🏁  Score : "..score
        end)
    end)
end

-- Raccourcis clavier
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        task.spawn(function()
            playSnd(SND.Scan, 0.4)
            Rayfield:Notify({Title="🔍 Scan", Content="En cours...", Duration=2})
            doScan()
            Rayfield:Notify({Title="✅ Terminé", Content=#foundRemotes.." remotes", Duration=4})
            playSnd(SND.Success, 0.5)
        end)
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        logActive = not logActive
        if logActive then
            for _, r in ipairs(remoteRefs) do pcall(hookRemote, r) end
            Rayfield:Notify({Title="▶ Logger", Content="Activé", Duration=3})
        else
            Rayfield:Notify({Title="⏸ Logger", Content="Désactivé", Duration=3})
        end
    elseif input.KeyCode == Enum.KeyCode.RightAlt then
        if hasSetClipboard then
            setclipboard(buildCopyText())
            Rayfield:Notify({Title="📋 Copié", Content=#foundRemotes.." remotes", Duration=3})
        end
    end
end)

Rayfield:Notify({
    Title = "🐾 Scanner v6 prêt",
    Content = "Onglet Scan → clique sur '🔄 Scanner les remotes'",
    Duration = 6,
})

getgenv().AMScanner = {
    scan = function()
        task.spawn(function() doScan(); Rayfield:Notify({Title="✅", Content=#foundRemotes.." remotes", Duration=3}) end)
    end,
    remotes = function() return foundRemotes end,
    logs = function() return logs end,
}

print("[AMScanner v6] Rayfield chargé. UI ouverte.")