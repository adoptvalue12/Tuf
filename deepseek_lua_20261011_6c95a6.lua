--[[ Adopt Me Remote Scanner v5 ]]

if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(0.3)

local _ok, _err = pcall(function()

local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst   = game:GetService("ReplicatedFirst")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local Lighting          = game:GetService("Lighting")
local SoundService      = game:GetService("SoundService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
    LocalPlayer = Players.LocalPlayer
end

local parentGui
do
    local ok1, h = pcall(function() return gethui() end)
    if ok1 and h then parentGui = h
    else
        local ok2, c = pcall(function() return game:GetService("CoreGui") end)
        if ok2 and c then parentGui = c
        else parentGui = LocalPlayer:WaitForChild("PlayerGui", 10) end
    end
end

local hasSetClipboard = type(setclipboard) == "function"
local hasNewCclosure  = type(newcclosure) == "function"
local hasWriteFile    = type(writefile) == "function"
local hasReadFile     = type(readfile) == "function"
local hasIsFile       = type(isfile) == "function"

local function ncc(f)
    if hasNewCclosure then return newcclosure(f) end
    return f
end

local T = {
    Bg=Color3.fromRGB(255,245,252), Card=Color3.fromRGB(255,255,255),
    CardAlt=Color3.fromRGB(255,235,248), Pink=Color3.fromRGB(255,130,190),
    PinkDark=Color3.fromRGB(230,90,150), Purple=Color3.fromRGB(180,140,240),
    PurpleDark=Color3.fromRGB(140,100,210), Mint=Color3.fromRGB(150,230,200),
    Yellow=Color3.fromRGB(255,210,120), Text=Color3.fromRGB(80,50,100),
    TextDim=Color3.fromRGB(160,140,180), TextLight=Color3.fromRGB(255,255,255),
    Error=Color3.fromRGB(255,120,130), Success=Color3.fromRGB(120,220,150),
    Border=Color3.fromRGB(255,200,230), Sky=Color3.fromRGB(190,230,255),
    Lavender=Color3.fromRGB(220,200,255), Peach=Color3.fromRGB(255,200,170),
}

local FH = Enum.Font.GothamBlack
local FB = Enum.Font.GothamBold
local FR = Enum.Font.Gotham
local FC = Enum.Font.Code

local IMG = {
    Paw     = "rbxassetid://120204214310777",
    Heart   = "rbxassetid://6031075931",
    Close   = "rbxassetid://6031096226",
    Minus   = "rbxassetid://6031090992",
    Search  = "rbxassetid://6031096677",
    Copy    = "rbxassetid://6031280882",
    Play    = "rbxassetid://6031075931",
    Stop    = "rbxassetid://6031094667",
    Trash   = "rbxassetid://6023426926",
    Star    = "rbxassetid://6031090992",
    Fire    = "rbxassetid://6031096677",
    Gear    = "rbxassetid://6031234412",
    Save    = "rbxassetid://6031280882",
    Bell    = "rbxassetid://6031075931",
}

local SND = {
    Click    = "rbxassetid://6895086596",
    Notify   = "rbxassetid://6042053627",
    Success  = "rbxassetid://9118823103",
    Error    = "rbxassetid://5873524714",
    Scan     = "rbxassetid://4612375234",
    Pop      = "rbxassetid://6895086596",
    Alert    = "rbxassetid://5873524714",
    Complete = "rbxassetid://9118823103",
}

local function playSnd(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = id
        s.Volume = vol or 0.5
        s.Parent = SoundService
        s:Play()
        task.delay(3, function() s:Destroy() end)
    end)
end

local function make(cls, props, kids)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    for _, c in ipairs(kids or {}) do c.Parent = o end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end
local function corner(p, r) return make("UICorner", {CornerRadius=UDim.new(0,r or 10), Parent=p}) end
local function stroke(p, c, t, tr) return make("UIStroke", {Color=c or T.Border, Thickness=t or 1.5, Transparency=tr or 0, ApplyStrokeMode=Enum.ApplyStrokeMode.Border, Parent=p}) end
local function pad(p, a, t, b, l, r) return make("UIPadding", {PaddingTop=UDim.new(0,t or a or 0), PaddingBottom=UDim.new(0,b or a or 0), PaddingLeft=UDim.new(0,l or a or 0), PaddingRight=UDim.new(0,r or a or 0), Parent=p}) end
local function grad(p, c1, c2, rot) return make("UIGradient", {Color=ColorSequence.new(c1,c2), Rotation=rot or 0, Parent=p}) end
local function isMobile() return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled end

local gui = make("ScreenGui", {
    Name = "AMScannerV5_" .. tostring(math.random(10000,99999)),
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = parentGui,
})

-- Notifications
local notifHolder = make("Frame", {Size=UDim2.new(0,240,1,-40), Position=UDim2.new(1,-250,0,20), BackgroundTransparency=1, Parent=gui})
make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, VerticalAlignment=Enum.VerticalAlignment.Bottom, Padding=UDim.new(0,6), Parent=notifHolder})

local function notify(text, kind)
    kind = kind or "info"
    local accent = T.Pink
    if kind == "success" then accent = T.Success end
    if kind == "warning" then accent = T.Yellow end
    if kind == "error" then accent = T.Error end

    local f = make("Frame", {Size=UDim2.new(0,230,0,40), BackgroundColor3=T.Card, BorderSizePixel=0, BackgroundTransparency=1, Parent=notifHolder})
    corner(f, 10)
    stroke(f, accent, 1.5)
    make("Frame", {Size=UDim2.new(0,4,1,-12), Position=UDim2.new(0,6,0,6), BackgroundColor3=accent, BorderSizePixel=0, Parent=f})
    make("TextLabel", {
        Size=UDim2.new(1,-22,1,0), Position=UDim2.new(0,14,0,0),
        BackgroundTransparency=1, Text=text, TextColor3=T.Text,
        Font=FB, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
        TextYAlignment=Enum.TextYAlignment.Center, TextWrapped=true, Parent=f,
    })
    f.Position = UDim2.new(1,20,0,0)
    task.spawn(function()
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position=UDim2.new(0,0,0,0), BackgroundTransparency=0}):Play()
        task.wait(3)
        TweenService:Create(f, TweenInfo.new(0.3), {Position=UDim2.new(1,20,0,0), BackgroundTransparency=1}):Play()
        task.wait(0.35)
        f:Destroy()
    end)
end

-- Bouton flottant
local floatBtn = make("TextButton", {
    Size=UDim2.new(0,54,0,54), Position=UDim2.new(0,20,0.5,-27),
    BackgroundColor3=T.Pink, Text="🐾", TextSize=24, Font=FB,
    TextColor3=T.TextLight, AutoButtonColor=false, Parent=gui,
})
corner(floatBtn, 27)
stroke(floatBtn, T.PinkDark, 2)
grad(floatBtn, T.Pink, T.Purple, 45)

do
    local dragging, dragStart, startPos
    floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            floatBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local isSmall = isMobile()
local winW = isSmall and 400 or 720
local winH = isSmall and 540 or 580

local window = make("Frame", {
    Size=UDim2.new(0,winW,0,winH), Position=UDim2.new(0.5,-winW/2,0.5,-winH/2),
    BackgroundColor3=T.Bg, BorderSizePixel=0, ClipsDescendants=true, Parent=gui,
})
corner(window, 18)
stroke(window, T.Pink, 2.5, 0.2)

local header = make("Frame", {Size=UDim2.new(1,0,0,72), BackgroundColor3=T.Pink, BorderSizePixel=0, Parent=window})
corner(header, 18)
make("Frame", {Size=UDim2.new(1,0,0,30), Position=UDim2.new(0,0,1,-30), BackgroundColor3=T.Pink, BorderSizePixel=0, Parent=header})
grad(header, T.Pink, T.Purple, 15)

make("TextLabel", {
    Size=UDim2.new(1,-120,0,26), Position=UDim2.new(0,60,0,12),
    BackgroundTransparency=1, Text="ADOPT ME SCANNER v5",
    TextColor3=T.TextLight, Font=FH, TextSize=19,
    TextXAlignment=Enum.TextXAlignment.Left, Parent=header,
})
make("TextLabel", {
    Size=UDim2.new(1,-120,0,16), Position=UDim2.new(0,60,0,38),
    BackgroundTransparency=1, Text="Remotes · Logs · Auto-Inject · Mini-jeu",
    TextColor3=Color3.fromRGB(255,240,250), Font=FR, TextSize=11,
    TextXAlignment=Enum.TextXAlignment.Left, Parent=header,
})

local headerIcon = make("TextLabel", {
    Size=UDim2.new(0,48,0,48), Position=UDim2.new(0,10,0,12),
    BackgroundTransparency=1, Text="🐾", TextSize=36, Font=FB, Parent=header,
})

local function hBtn(txt, xOff, cb)
    local b = make("TextButton", {
        Size=UDim2.new(0,28,0,28), Position=UDim2.new(1,xOff,0,22),
        BackgroundColor3=Color3.fromRGB(255,255,255), BackgroundTransparency=0.75,
        Text=txt, TextColor3=T.TextLight, Font=FB, TextSize=14,
        AutoButtonColor=false, Parent=header,
    })
    corner(b, 10)
    b.MouseButton1Click:Connect(cb)
    return b
end

local closeBtn = hBtn("✕", -34, function() gui.Enabled = false; notify("UI fermée. Clique sur 🐾 pour rouvrir.") end)
local minimizeBtn = hBtn("–", -66, function() end)

do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetH = minimized and 72 or winH
    TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size=UDim2.new(0,winW,0,targetH)}):Play()
    for _, c in ipairs(window:GetChildren()) do
        if c ~= header and c:IsA("GuiObject") then c.Visible = not minimized end
    end
end)

-- Stats bar
local statsBar = make("Frame", {
    Size=UDim2.new(1,-20,0,36), Position=UDim2.new(0,10,0,80),
    BackgroundColor3=T.Card, BorderSizePixel=0, Parent=window,
})
corner(statsBar, 10)
stroke(statsBar, T.Border, 1)
make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,5), VerticalAlignment=Enum.VerticalAlignment.Center, HorizontalAlignment=Enum.HorizontalAlignment.Center, Parent=statsBar})
pad(statsBar, 6)

local function statChip(color, order, width)
    local c = make("Frame", {Size=UDim2.new(0,width or 84,1,-4), BackgroundColor3=color, BackgroundTransparency=0.85, LayoutOrder=order, Parent=statsBar})
    corner(c, 8)
    stroke(c, color, 1.5, 0.3)
    local l = make("TextLabel", {Size=UDim2.new(1,-8,1,0), Position=UDim2.new(0,4,0,0), BackgroundTransparency=1, Text="0", TextColor3=T.Text, Font=FB, TextSize=11, Parent=c})
    return l
end

local statTotal  = statChip(T.Purple, 1)
local statEvents = statChip(T.Pink, 2)
local statFuncs  = statChip(T.Mint, 3)
local statLogs   = statChip(T.Yellow, 4)
local statCps    = statChip(T.Lavender, 5)

-- Start bar
local startBar = make("Frame", {
    Size=UDim2.new(1,-20,0,40), Position=UDim2.new(0,10,0,122),
    BackgroundColor3=T.Card, BorderSizePixel=0, Parent=window,
})
corner(startBar, 10)
stroke(startBar, T.Border, 1)
pad(startBar, 6)
make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), VerticalAlignment=Enum.VerticalAlignment.Center, Parent=startBar})

local startBtn = make("TextButton", {
    Size=UDim2.new(0,130,1,0), BackgroundColor3=T.Success,
    Text="▶  DÉMARRER", TextColor3=T.TextLight, Font=FB, TextSize=12,
    AutoButtonColor=false, LayoutOrder=1, Parent=startBar,
})
corner(startBtn, 9)
grad(startBtn, T.Success, Color3.fromRGB(90,200,130), 0)

local durations = {30, 60, 120, 300, 0}
local durIdx = 2

local durBtn = make("TextButton", {
    Size=UDim2.new(0,100,1,0), BackgroundColor3=T.Purple,
    Text="⏱ 60s", TextColor3=T.TextLight, Font=FB, TextSize=12,
    AutoButtonColor=false, LayoutOrder=2, Parent=startBar,
})
corner(durBtn, 9)
grad(durBtn, T.Purple, T.PurpleDark, 0)

durBtn.MouseButton1Click:Connect(function()
    durIdx = durIdx % #durations + 1
    local d = durations[durIdx]
    durBtn.Text = d == 0 and "⏱ ∞" or ("⏱ " .. d .. "s")
    startBtn.Text = d == 0 and "▶  DÉMARRER" or ("▶  DÉMARRER")
    playSnd(SND.Click, 0.3)
end)

local timerLbl = make("TextLabel", {
    Size=UDim2.new(1,-240,1,0), Position=UDim2.new(0,240,0,0),
    BackgroundTransparency=1, Text="Prêt", TextColor3=T.Text,
    Font=FB, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
    LayoutOrder=3, Parent=startBar,
})

local progressBar = make("Frame", {
    Size=UDim2.new(0,0,0,4), Position=UDim2.new(0,10,0,165),
    BackgroundColor3=T.Pink, BorderSizePixel=0, Parent=window,
})
corner(progressBar, 2)
grad(progressBar, T.Pink, T.Purple, 0)

-- Tab bar
local tabBar = make("Frame", {
    Size=UDim2.new(1,-20,0,34), Position=UDim2.new(0,10,0,178),
    BackgroundColor3=T.CardAlt, BorderSizePixel=0, Parent=window,
})
corner(tabBar, 10)
pad(tabBar, 4)
make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=tabBar})

local content = make("Frame", {
    Size=UDim2.new(1,-20,1,-290), Position=UDim2.new(0,10,0,222),
    BackgroundColor3=T.Card, BorderSizePixel=0, Parent=window,
})
corner(content, 12)
stroke(content, T.Border, 1)
pad(content, 8)

local tabs = {}
local activeTab

local function createTab(id, label, order, width)
    local b = make("TextButton", {
        Size=UDim2.new(0,width or 78,1,0), BackgroundColor3=T.CardAlt,
        BackgroundTransparency=0.3, Text=label, TextColor3=T.TextDim,
        Font=FB, TextSize=10, AutoButtonColor=false, LayoutOrder=order, Parent=tabBar,
    })
    corner(b, 8)

    local page = make("ScrollingFrame", {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, BorderSizePixel=0,
        ScrollBarThickness=5, ScrollBarImageColor3=T.Pink, ScrollBarImageTransparency=0.3,
        CanvasSize=UDim2.new(0,0,0,0), AutomaticCanvasSize=Enum.AutomaticSize.Y,
        Visible=false, Parent=content,
    })
    make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,4), Parent=page})

    tabs[id] = {btn=b, page=page}

    b.MouseButton1Click:Connect(function()
        if activeTab == id then return end
        activeTab = id
        for tid, t in pairs(tabs) do
            local on = (tid == id)
            t.btn.BackgroundColor3 = on and T.Pink or T.CardAlt
            t.btn.BackgroundTransparency = on and 0 or 0.3
            t.btn.TextColor3 = on and T.TextLight or T.TextDim
            t.page.Visible = on
        end
        playSnd(SND.Click, 0.2)
    end)
    return page
end

local scanPage  = createTab("scan",   "🔍 Scan",   1, 78)
local logPage   = createTab("log",    "📝 Logs",   2, 78)
local toolsPage = createTab("tools",  "🔧 Outils", 3, 82)
local filterPage= createTab("filter", "🎯 Filtre", 4, 78)
local gamePage  = createTab("game",   "🎮 Jeu",    5, 78)
local helpPage  = createTab("help",   "ℹ️",       6, 42)

activeTab = "scan"
tabs.scan.btn.BackgroundColor3 = T.Pink
tabs.scan.btn.BackgroundTransparency = 0
tabs.scan.btn.TextColor3 = T.TextLight
scanPage.Visible = true

-- Page Scan
local searchBox
do
    local top = make("Frame", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, LayoutOrder=1, Parent=scanPage})
    searchBox = make("TextBox", {
        Size=UDim2.new(1,0,1,0), BackgroundColor3=T.CardAlt, BorderSizePixel=0,
        PlaceholderText="🔍  Rechercher un remote...", PlaceholderColor3=T.TextDim,
        Text="", TextColor3=T.Text, Font=FR, TextSize=13,
        TextXAlignment=Enum.TextXAlignment.Left, ClearTextOnFocus=false, Parent=top,
    })
    corner(searchBox, 8)
    stroke(searchBox, T.Border, 1)
    pad(searchBox, 0, 0, 0, 10, 10)
end

local scanListFrame = make("Frame", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, LayoutOrder=2, Parent=scanPage})

-- Page Logs
local logCount = 0
local logActive = false
local logStatusLbl
do
    local top = make("Frame", {Size=UDim2.new(1,0,0,26), BackgroundTransparency=1, LayoutOrder=1, Parent=logPage})
    logStatusLbl = make("TextLabel", {
        Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="⏸  Arrêté",
        TextColor3=T.Yellow, Font=FB, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, Parent=top,
    })
end

local logListFrame = make("Frame", {Size=UDim2.new(1,0,0,0), BackgroundTransparency=1, LayoutOrder=2, Parent=logPage})
make("UIListLayout", {SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,3), Parent=logListFrame})

-- Page Outils
do
    local title = make("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text="🔧  Outils",
        TextColor3=T.Text, Font=FB, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=1, Parent=toolsPage,
    })

    local function toolBtn(text, color, order, cb)
        local b = make("TextButton", {
            Size=UDim2.new(1,0,0,34), BackgroundColor3=color,
            Text=text, TextColor3=T.TextLight, Font=FB, TextSize=12,
            AutoButtonColor=false, LayoutOrder=order, Parent=toolsPage,
        })
        corner(b, 9)
        b.MouseButton1Click:Connect(function()
            playSnd(SND.Click, 0.3)
            cb(b)
        end)
        return b
    end

    toolBtn("🔗  AUTO-INJECT : capturer le prochain FireServer", T.Purple, 2, function()
        if not hasSetClipboard then notify("setclipboard non supporté", "error") return end
        notify("En attente... clique un bouton dans Adopt Me", "info")
        local mt = getrawmetatable and getrawmetatable(game)
        if not mt then notify("getrawmetatable non supporté", "error") return end
        local oldNamecall = mt.__namecall
        setreadonly(mt, false)
        mt.__namecall = ncc(function(self, ...)
            local m = getnamecallmethod()
            if m == "FireServer" or m == "InvokeServer" then
                local args = {...}
                local out = {}
                for i, v in ipairs(args) do
                    local t = typeof(v)
                    if t == "Vector3" then out[i] = string.format("Vector3.new(%.2f,%.2f,%.2f)", v.X, v.Y, v.Z)
                    elseif t == "CFrame" then out[i] = "CFrame.new(" .. tostring(v.Position) .. ")"
                    elseif t == "string" then out[i] = string.format("%q", v)
                    elseif t == "Instance" then out[i] = v:GetFullName()
                    else out[i] = tostring(v) end
                end
                local final = string.format("%s:%s(%s)", self:GetFullName(), m, table.concat(out, ", "))
                setclipboard(final)
                notify("✅ Remote capturé !", "success")
                playSnd(SND.Success, 0.5)
                print("[Auto-Inject] " .. final)
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end
            return oldNamecall(self, ...)
        end)
        task.delay(30, function()
            pcall(function()
                mt.__namecall = oldNamecall
                setreadonly(mt, true)
            end)
        end)
    end)

    toolBtn("💾  SAUVEGARDER logs dans un fichier", T.Mint, 3, function()
        if not hasWriteFile then notify("writefile non supporté", "error") return end
        local c = "=== ADOPT ME SCANNER v5 ===\n" .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n"
        c = c .. "-- REMOTES (" .. #foundRemotes .. ") --\n"
        for i, r in ipairs(foundRemotes) do
            local cnt = callCounts[r.ref] or 0
            c = c .. string.format("[%d] (%s) %s [%d]\n", i, r.class, r.path, cnt)
        end
        c = c .. "\n-- LOGS (" .. #logs .. ") --\n"
        for _, l in ipairs(logs) do c = c .. l .. "\n" end
        local ok = pcall(function() writefile("adopt_me_v5_logs.txt", c) end)
        if ok then
            notify("💾 Sauvegardé : adopt_me_v5_logs.txt", "success")
            playSnd(SND.Success, 0.5)
        else
            notify("Échec sauvegarde", "error")
        end
    end)

    toolBtn("📂  CHARGER les logs sauvegardés", T.Yellow, 4, function()
        if not hasReadFile or not hasIsFile then notify("readfile/isfile non supporté", "error") return end
        if not isfile("adopt_me_v5_logs.txt") then notify("Aucun fichier trouvé", "warning") return end
        local c = readfile("adopt_me_v5_logs.txt")
        print(c)
        notify("Logs chargés (" .. #c .. " caractères) - voir console", "success")
    end)

    -- Auto-copy à la fin du scan
    local autoCopyBtn = toolBtn("📋  AUTO-COPY à la fin du scan : OFF", T.Pink, 5, function() end)
    local autoCopy = false
    autoCopyBtn.MouseButton1Click:Connect(function()
        autoCopy = not autoCopy
        autoCopyBtn.Text = autoCopy and "📋  AUTO-COPY à la fin du scan : ON" or "📋  AUTO-COPY à la fin du scan : OFF"
        autoCopyBtn.BackgroundColor3 = autoCopy and T.Success or T.Pink
        getgenv()._autoCopy = autoCopy
    end)
    getgenv()._autoCopy = false

    -- Alerte détection
    local alertBtn = toolBtn("🚨  ALERTE DÉTECTION : OFF", T.Error, 6, function() end)
    local alertActive = false
    alertBtn.MouseButton1Click:Connect(function()
        alertActive = not alertActive
        alertBtn.Text = alertActive and "🚨  ALERTE DÉTECTION : ON" or "🚨  ALERTE DÉTECTION : OFF"
        alertBtn.BackgroundColor3 = alertActive and T.Error or T.CardAlt
        alertBtn.TextColor3 = alertActive and T.TextLight or T.Text
        getgenv()._alertActive = alertActive
    end)
    getgenv()._alertActive = false

    -- Reset compteurs
    toolBtn("🔄  RESET les compteurs d'appels", T.Lavender, 7, function()
        callCounts = {}
        renderScanList(searchBox.Text)
        notify("Compteurs réinitialisés", "success")
    end)

    -- Fermer proprement
    toolBtn("❌  DÉTRUIRE L'UI", T.Error, 8, function()
        gui:Destroy()
    end)
end

-- Page Filtre
local filters = {
    RemoteEvent = true, RemoteFunction = true, UnreliableRemoteEvent = true,
    BindableEvent = true, BindableFunction = true,
}
do
    make("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text="🎯  Types affichés",
        TextColor3=T.Text, Font=FB, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=1, Parent=filterPage,
    })
    local order = 2
    for cls, _ in pairs(filters) do
        local row = make("TextButton", {
            Size=UDim2.new(1,0,0,30), BackgroundColor3=T.CardAlt,
            BorderSizePixel=0, Text="", AutoButtonColor=false, LayoutOrder=order, Parent=filterPage,
        })
        corner(row, 8)
        stroke(row, T.Border, 1)
        order = order + 1
        local chk = make("Frame", {Size=UDim2.new(0,20,0,20), Position=UDim2.new(0,8,0.5,-10), BackgroundColor3=T.Pink, BorderSizePixel=0, Parent=row})
        corner(chk, 6)
        local tick = make("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="✓", TextColor3=T.TextLight, Font=FH, TextSize=14, Parent=chk})
        make("TextLabel", {
            Size=UDim2.new(1,-50,1,0), Position=UDim2.new(0,36,0,0),
            BackgroundTransparency=1, Text=cls, TextColor3=T.Text,
            Font=FR, TextSize=12, TextXAlignment=Enum.TextXAlignment.Left, Parent=row,
        })
        row.MouseButton1Click:Connect(function()
            filters[cls] = not filters[cls]
            chk.BackgroundColor3 = filters[cls] and T.Pink or T.TextDim
            tick.Visible = filters[cls]
            renderScanList(searchBox.Text)
            playSnd(SND.Click, 0.2)
        end)
    end

    local freqBtn = make("TextButton", {
        Size=UDim2.new(1,0,0,30), BackgroundColor3=T.CardAlt, BorderSizePixel=0,
        Text="📊  Trier par fréquence : OFF", TextColor3=T.Text,
        Font=FB, TextSize=12, AutoButtonColor=false, LayoutOrder=10, Parent=filterPage,
    })
    corner(freqBtn, 8)
    stroke(freqBtn, T.Yellow, 1)
    local sortByFreq = false
    freqBtn.MouseButton1Click:Connect(function()
        sortByFreq = not sortByFreq
        freqBtn.BackgroundColor3 = sortByFreq and T.Yellow or T.CardAlt
        freqBtn.Text = sortByFreq and "📊  Trier par fréquence : ON" or "📊  Trier par fréquence : OFF"
        getgenv()._sortByFreq = sortByFreq
        renderScanList(searchBox.Text)
        playSnd(SND.Click, 0.2)
    end)
    getgenv()._sortByFreq = false

    local kwBtn = make("TextButton", {
        Size=UDim2.new(1,0,0,30), BackgroundColor3=T.CardAlt, BorderSizePixel=0,
        Text="🏷  Catégoriser (farm/trade/event/ui) : OFF", TextColor3=T.Text,
        Font=FB, TextSize=11, AutoButtonColor=false, LayoutOrder=11, Parent=filterPage,
    })
    corner(kwBtn, 8)
    stroke(kwBtn, T.Mint, 1)
    local categorize = false
    kwBtn.MouseButton1Click:Connect(function()
        categorize = not categorize
        kwBtn.BackgroundColor3 = categorize and T.Mint or T.CardAlt
        kwBtn.Text = categorize and "🏷  Catégoriser : ON" or "🏷  Catégoriser (farm/trade/event/ui) : OFF"
        getgenv()._categorize = categorize
        renderScanList(searchBox.Text)
        playSnd(SND.Click, 0.2)
    end)
    getgenv()._categorize = false
end

-- Mini-jeu
local gameRunning = false
local gameScore = 0
local gameBest = 0
local gameField, gameScoreLbl, gameBestLbl, gameTimeLbl, gameStartBtn
local gamePets = {
    {emoji="🐶", color=Color3.fromRGB(255,200,130)},
    {emoji="🐱", color=Color3.fromRGB(200,180,255)},
    {emoji="🐰", color=Color3.fromRGB(255,200,230)},
    {emoji="🐲", color=Color3.fromRGB(180,220,180)},
    {emoji="🦄", color=Color3.fromRGB(255,220,240)},
    {emoji="🐧", color=Color3.fromRGB(180,200,255)},
    {emoji="🐢", color=Color3.fromRGB(170,220,170)},
    {emoji="🦊", color=Color3.fromRGB(255,180,120)},
    {emoji="🐼", color=Color3.fromRGB(240,240,240)},
    {emoji="🐸", color=Color3.fromRGB(180,230,140)},
}
do
    make("TextLabel", {
        Size=UDim2.new(1,0,0,22), BackgroundTransparency=1, Text="🎮  Tape les pets ! (30s)",
        TextColor3=T.Text, Font=FB, TextSize=13, TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=1, Parent=gamePage,
    })
    local gsBar = make("Frame", {Size=UDim2.new(1,0,0,30), BackgroundTransparency=1, LayoutOrder=2, Parent=gamePage})
    make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), Parent=gsBar})

    gameScoreLbl = make("TextLabel", {Size=UDim2.new(0,90,1,0), BackgroundColor3=T.Pink, BackgroundTransparency=0.85, Text="🏆 0", TextColor3=T.Text, Font=FB, TextSize=12, LayoutOrder=1, Parent=gsBar})
    corner(gameScoreLbl, 8); stroke(gameScoreLbl, T.Pink, 1)
    gameBestLbl = make("TextLabel", {Size=UDim2.new(0,90,1,0), BackgroundColor3=T.Purple, BackgroundTransparency=0.85, Text="⭐ 0", TextColor3=T.Text, Font=FB, TextSize=12, LayoutOrder=2, Parent=gsBar})
    corner(gameBestLbl, 8); stroke(gameBestLbl, T.Purple, 1)
    gameTimeLbl = make("TextLabel", {Size=UDim2.new(0,90,1,0), BackgroundColor3=T.Mint, BackgroundTransparency=0.8, Text="⏱ 30s", TextColor3=T.Text, Font=FB, TextSize=12, LayoutOrder=3, Parent=gsBar})
    corner(gameTimeLbl, 8); stroke(gameTimeLbl, T.Mint, 1)

    gameField = make("Frame", {Size=UDim2.new(1,0,0,220), BackgroundColor3=T.Sky, BorderSizePixel=0, ClipsDescendants=true, LayoutOrder=3, Parent=gamePage})
    corner(gameField, 12); stroke(gameField, T.Purple, 1.5, 0.3)
    make("TextLabel", {Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="🐾  Appuie sur DÉMARRER", TextColor3=Color3.fromRGB(140,180,220), Font=FB, TextSize=15, Parent=gameField})

    gameStartBtn = make("TextButton", {
        Size=UDim2.new(1,0,0,36), BackgroundColor3=T.Pink, Text="▶  DÉMARRER LE MINI-JEU",
        TextColor3=T.TextLight, Font=FB, TextSize=13, AutoButtonColor=false, LayoutOrder=4, Parent=gamePage,
    })
    corner(gameStartBtn, 9); grad(gameStartBtn, T.Pink, T.Purple, 0)
end

local function spawnPetInGame()
    if not gameRunning then return end
    local pet = gamePets[math.random(1, #gamePets)]
    local btn = make("TextButton", {
        Size=UDim2.new(0,54,0,54),
        Position=UDim2.new(math.random()*0.85, 0, math.random()*0.75, 0),
        BackgroundColor3=pet.color, BackgroundTransparency=0.15,
        Text=pet.emoji, TextSize=28, TextColor3=T.Text,
        AutoButtonColor=false, Parent=gameField,
    })
    corner(btn, 27); stroke(btn, Color3.new(1,1,1), 2, 0.2)
    btn.Size = UDim2.new(0,0,0,0)
    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back), {Size=UDim2.new(0,54,0,54)}):Play()
    local clicked = false
    btn.MouseButton1Click:Connect(function()
        if clicked or not gameRunning then return end
        clicked = true
        gameScore = gameScore + 1
        gameScoreLbl.Text = "🏆 " .. gameScore
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

gameStartBtn.MouseButton1Click:Connect(function()
    if gameRunning then return end
    gameRunning = true
    gameScore = 0
    gameScoreLbl.Text = "🏆 0"
    gameStartBtn.Text = "⏸  EN COURS..."
    gameStartBtn.BackgroundColor3 = T.Error
    playSnd(SND.Scan, 0.4)
    for _, c in ipairs(gameField:GetChildren()) do
        if c:IsA("TextButton") then c:Destroy() end
    end
    local endTime = tick() + 30
    task.spawn(function()
        while gameRunning do
            local left = math.max(0, math.ceil(endTime - tick()))
            gameTimeLbl.Text = "⏱ " .. left .. "s"
            if left <= 0 then break end
            spawnPetInGame()
            task.wait(math.random(50,90)/100)
        end
    end)
    task.delay(30, function()
        gameRunning = false
        gameStartBtn.Text = "▶  DÉMARRER LE MINI-JEU"
        gameStartBtn.BackgroundColor3 = T.Pink
        if gameScore > gameBest then
            gameBest = gameScore
            gameBestLbl.Text = "⭐ " .. gameBest
            notify("🏆 Record : " .. gameScore .. " !", "success")
            playSnd(SND.Success, 0.6)
        else
            notify("Score : " .. gameScore)
        end
        for _, c in ipairs(gameField:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        make("TextLabel", {
            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
            Text="🏁  Score : " .. gameScore, TextColor3=Color3.fromRGB(140,180,220),
            Font=FB, TextSize=15, Parent=gameField,
        })
    end)
end)

-- Page Aide
do
    make("TextLabel", {
        Size=UDim2.new(1,0,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundTransparency=1,
        Text=table.concat({
            "🐾  GUIDE RAPIDE","",
            "1.  ▶ DÉMARRER (durée ⏱ configurable)",
            "2.  🎮 JEU pendant l'attente",
            "3.  Joue : œufs, pets, Halloween, trades",
            "4.  📋 COPIER TOUT et envoie au dev","",
            "🔧  OUTILS",
            "• Auto-Inject : capture le prochain remote",
            "• Sauvegarde / chargement fichier",
            "• Auto-copy à la fin du scan",
            "• Alerte détection (Kick/Ban/Detect)",
            "• Reset compteurs","",
            "🔒  100% autonome — aucune requête réseau",
        }, "\n"),
        TextColor3=T.Text, Font=FR, TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left, TextYAlignment=Enum.TextYAlignment.Top,
        TextWrapped=true, Parent=helpPage,
    })
end

-- Footer
local footer = make("Frame", {
    Size=UDim2.new(1,-20,0,52), Position=UDim2.new(0,10,1,-60),
    BackgroundColor3=T.CardAlt, BorderSizePixel=0, Parent=window,
})
corner(footer, 12)
pad(footer, 6)
make("UIListLayout", {FillDirection=Enum.FillDirection.Horizontal, SortOrder=Enum.SortOrder.LayoutOrder, Padding=UDim.new(0,6), VerticalAlignment=Enum.VerticalAlignment.Center, Parent=footer})

local function fBtn(label, color, order, wide)
    local b = make("TextButton", {
        Size=UDim2.new(0,wide and 130 or 100,1,0), BackgroundColor3=color,
        Text=label, TextColor3=T.TextLight, Font=FB, TextSize=12,
        AutoButtonColor=false, LayoutOrder=order, Parent=footer,
    })
    corner(b, 9)
    grad(b, color, Color3.new(math.min(1,color.R+0.1), math.min(1,color.G+0.05), math.min(1,color.B+0.1)), 0)
    return b
end

local btnScan  = fBtn("🔄  SCANNER", T.Purple, 1, true)
local btnCopy  = fBtn("📋  COPIER",  T.Pink,   2)
local btnClear = fBtn("🗑  CLEAR",   T.Error,  3)

-- Scan logic
local foundRemotes = {}
local remoteRefs = {}
local hookedSet = {}
local callCounts = {}

local function getPath(o)
    local ok, p = pcall(function() return o:GetFullName() end)
    return ok and p or o.Name
end

local function scanObject(container, seen, list)
    if not container or seen[container] then return end
    seen[container] = true
    for _, o in ipairs(container:GetDescendants()) do
        local c = o.ClassName
        if c == "RemoteEvent" or c == "RemoteFunction" or c == "UnreliableRemoteEvent" or c == "BindableEvent" or c == "BindableFunction" then
            table.insert(list, {path=getPath(o), class=c, name=o.Name, ref=o})
        end
    end
end

local function doScan()
    foundRemotes, remoteRefs = {}, {}
    local seen = {}
    local results = {}
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

    local cntE, cntF = 0, 0
    for _, r in ipairs(results) do
        if r.class == "RemoteEvent" or r.class == "UnreliableRemoteEvent" then cntE = cntE + 1 end
        if r.class == "RemoteFunction" then cntF = cntF + 1 end
    end
    statTotal.Text  = "📡 " .. #results
    statEvents.Text = "⚡ " .. cntE
    statFuncs.Text  = "🔶 " .. cntF
end

local function categorize(name)
    local n = name:lower()
    if n:find("farm") or n:find("collect") or n:find("auto") then return "🌾 Farm" end
    if n:find("trade") or n:find("offer") or n:find("accept") then return "🔄 Trade" end
    if n:find("event") or n:find("halloween") or n:find("candy") then return "🎃 Event" end
    if n:find("buy") or n:find("purchase") or n:find("egg") then return "🛒 Shop" end
    if n:find("equip") or n:find("pet") or n:find("inventory") then return "🐾 Pet" end
    if n:find("ui") or n:find("menu") or n:find("toggle") then return "🎨 UI" end
    return "📦 Autre"
end

function renderScanList(filter)
    for _, c in ipairs(scanListFrame:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    filter = (filter or ""):lower()
    local sortByFreq = getgenv()._sortByFreq
    local categorize = getgenv()._categorize

    local flat = {}
    for _, r in ipairs(foundRemotes) do
        if filters[r.class] and (filter == "" or r.name:lower():find(filter, 1, true)) then
            table.insert(flat, r)
        end
    end

    if sortByFreq then
        table.sort(flat, function(a, b)
            return (callCounts[a.ref] or 0) > (callCounts[b.ref] or 0)
        end)
    end

    if #flat == 0 then
        make("TextLabel", {
            Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
            Text="Aucun remote. Clique sur 🔄 SCANNER.",
            TextColor3=T.TextDim, Font=FR, TextSize=13, Parent=scanListFrame,
        })
        return
    end

    if sortByFreq or categorize == false then
        local groups = {}
        for _, r in ipairs(flat) do
            local key
            if categorize then key = categorize(r.name)
            else key = r.path:match("^(.*)%.[^%.]+$") or "Racine" end
            groups[key] = groups[key] or {}
            table.insert(groups[key], r)
        end
        local order = 0
        for pp, list in pairs(groups) do
            order = order + 1
            local h = make("TextLabel", {
                Size=UDim2.new(1,0,0,22), BackgroundColor3=T.CardAlt, BackgroundTransparency=0.2,
                Text="  " .. (categorize and pp or ("📁 " .. pp)) .. "  (" .. #list .. ")",
                TextColor3=T.PurpleDark, Font=FB, TextSize=11,
                TextXAlignment=Enum.TextXAlignment.Left, LayoutOrder=order, Parent=scanListFrame,
            })
            corner(h, 6); pad(h, 4)

            for _, r in ipairs(list) do
                order = order + 1
                local icon = "🔹"
                if r.class == "RemoteFunction" then icon = "🔶" end
                if r.class == "UnreliableRemoteEvent" then icon = "⚡" end
                if r.class == "BindableEvent" then icon = "🧩" end
                local cnt = callCounts[r.ref] or 0

                local row = make("TextButton", {
                    Size=UDim2.new(1,-12,0,24), BackgroundColor3=T.CardAlt, BackgroundTransparency=0.5,
                    Text="   " .. icon .. "  " .. r.name .. "  ·  " .. cnt .. "x  ·  " .. r.class,
                    TextColor3=T.Text, Font=FC, TextSize=11,
                    TextXAlignment=Enum.TextXAlignment.Left, AutoButtonColor=false,
                    LayoutOrder=order, Parent=scanListFrame,
                })
                corner(row, 6); pad(row, 0, 0, 0, 6, 6)
                row.MouseEnter:Connect(function()
                    row.BackgroundColor3 = T.Pink; row.BackgroundTransparency = 0.75
                end)
                row.MouseLeave:Connect(function()
                    row.BackgroundColor3 = T.CardAlt; row.BackgroundTransparency = 0.5
                end)
                row.MouseButton1Click:Connect(function()
                    if hasSetClipboard then
                        setclipboard(r.path)
                        notify("Copié : " .. r.name, "success")
                        playSnd(SND.Click, 0.3)
                    end
                end)
            end
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderScanList(searchBox.Text)
end)

-- Logger
local logs = {}
local MAX_LOGS = 600

local function addLog(tag, remoteName, args, remoteRef)
    if not logActive then return end
    local parts = {}
    for i, v in ipairs(args) do
        local ok, s = pcall(function()
            if type(v) == "table" then
                local inner = {}
                for k, vv in pairs(v) do table.insert(inner, tostring(k) .. "=" .. tostring(vv)) end
                return "{" .. table.concat(inner, ",") .. "}"
            end
            return tostring(v)
        end)
        parts[i] = ok and s or "?"
    end
    local ts = os.date("%H:%M:%S")
    local text = string.format("[%s] %s %s(%s)", ts, tag, remoteName, table.concat(parts, ", "))

    table.insert(logs, text)
    if #logs > MAX_LOGS then table.remove(logs, 1) end

    if remoteRef then callCounts[remoteRef] = (callCounts[remoteRef] or 0) + 1 end

    if getgenv()._alertActive then
        local suspects = {"kick","ban","detect","anti","guard","log","report","punish"}
        for _, s in ipairs(suspects) do
            if remoteName:lower():find(s, 1, true) then
                notify("🚨 " .. remoteName .. " suspect !", "error")
                playSnd(SND.Alert, 0.7)
                break
            end
        end
    end

    local color = T.Text
    if tag == "SEND" then color = T.PinkDark end
    if tag == "RECV" then color = T.PurpleDark end
    if tag == "INVOKE" then color = T.Yellow end

    local lbl = make("TextLabel", {
        Size=UDim2.new(1,-8,0,0), AutomaticSize=Enum.AutomaticSize.Y,
        BackgroundColor3=T.CardAlt, BackgroundTransparency=0.5,
        Text="  " .. text, TextColor3=color, Font=FC, TextSize=10,
        TextXAlignment=Enum.TextXAlignment.Left, TextWrapped=true, Parent=logListFrame,
    })
    corner(lbl, 6); pad(lbl, 4)

    logCount = logCount + 1
    statLogs.Text = "📝 " .. logCount
    logStatusLbl.Text = string.format("%s  |  %d logs", logActive and "▶  Actif" or "⏸  Arrêté", logCount)
    logStatusLbl.TextColor3 = logActive and T.Success or T.Yellow
end

local function hookRemote(remote)
    if hookedSet[remote] then return end
    hookedSet[remote] = true
    pcall(function() remote:SetAttribute("__ck_hooked", true) end)
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

-- Start/Stop session
local sessionActive = false
local sessionEnd = 0
local sessionDur = 60

local function stopSession(reason)
    sessionActive = false
    logActive = false
    startBtn.Text = "▶  DÉMARRER"
    startBtn.BackgroundColor3 = T.Success
    timerLbl.Text = reason or "Terminé"
    TweenService:Create(progressBar, TweenInfo.new(0.3), {Size=UDim2.new(0,0,0,4)}):Play()
    playSnd(SND.Complete, 0.6)
    notify("Session terminée. 📋 Copie tes résultats.", "success")
end

startBtn.MouseButton1Click:Connect(function()
    if sessionActive then
        stopSession("Arrêté")
        return
    end
    sessionDur = durations[durIdx]
    sessionActive = true
    logActive = true
    startBtn.Text = "⏹  ARRÊTER"
    startBtn.BackgroundColor3 = T.Error
    playSnd(SND.Scan, 0.4)

    timerLbl.Text = "Scan en cours..."
    notify("Scan automatique...")
    task.spawn(function()
        doScan()
        renderScanList(searchBox.Text)
        notify("✅ " .. #foundRemotes .. " remotes détectés", "success")
        playSnd(SND.Success, 0.5)

        for _, r in ipairs(remoteRefs) do pcall(hookRemote, r) end
        ReplicatedStorage.DescendantAdded:Connect(function(o)
            local c = o.ClassName
            if c == "RemoteEvent" or c == "RemoteFunction" or c == "UnreliableRemoteEvent" then
                task.wait(0.08)
                pcall(hookRemote, o)
                table.insert(foundRemotes, {path=getPath(o), class=c, name=o.Name, ref=o})
                table.insert(remoteRefs, o)
            end
        end)

        sessionEnd = sessionDur == 0 and math.huge or (tick() + sessionDur)
        local cpsCounter, cpsTime = 0, tick()

        while sessionActive do
            if sessionDur == 0 then
                timerLbl.Text = string.format("⏺ Actif — %d logs", logCount)
                TweenService:Create(progressBar, TweenInfo.new(0.5), {Size=UDim2.new(0.5,0,0,4)}):Play()
            else
                local left = math.max(0, math.ceil(sessionEnd - tick()))
                timerLbl.Text = string.format("⏱ %ds — %d logs", left, logCount)
                local pct = 1 - (left / sessionDur)
                TweenService:Create(progressBar, TweenInfo.new(0.2), {Size=UDim2.new(pct,0,0,4)}):Play()
                if left <= 0 then break end
            end
            if tick() - cpsTime >= 1 then
                statCps.Text = "⚡ " .. (logCount - cpsCounter) .. "/s"
                cpsCounter = logCount
                cpsTime = tick()
            end
            task.wait(0.25)
        end

        if sessionActive then
            stopSession("Durée écoulée ✓")
            if getgenv()._autoCopy and hasSetClipboard then
                task.wait(0.2)
                btnCopy.MouseButton1Click:Fire?()
            end
        end
    end)
end)

btnScan.MouseButton1Click:Connect(function()
    notify("Scan en cours...")
    playSnd(SND.Scan, 0.4)
    task.spawn(function()
        doScan()
        renderScanList(searchBox.Text)
        notify("✅ " .. #foundRemotes .. " remotes", "success")
        playSnd(SND.Success, 0.5)
    end)
end)

btnCopy.MouseButton1Click:Connect(function()
    local L = {}
    table.insert(L, "=== ADOPT ME SCANNER v5 ===")
    table.insert(L, "Date : " .. os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(L, "Remotes : " .. #foundRemotes)
    table.insert(L, "Logs : " .. #logs)
    table.insert(L, "")
    table.insert(L, "-- REMOTES (avec fréquence) --")
    for i, r in ipairs(foundRemotes) do
        local cnt = callCounts[r.ref] or 0
        table.insert(L, string.format("[%d] (%s) %s [%d]", i, r.class, r.path, cnt))
    end
    table.insert(L, "")
    table.insert(L, "-- LOGS --")
    for _, l in ipairs(logs) do table.insert(L, l) end
    local out = table.concat(L, "\n")

    if hasSetClipboard then
        setclipboard(out)
        notify("📋 Copié ! (" .. #foundRemotes .. " remotes, " .. #logs .. " logs)", "success")
        playSnd(SND.Success, 0.5)
    else
        print(out)
        notify("setclipboard indispo", "error")
    end
end)

btnClear.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    callCounts = {}
    for _, c in ipairs(logListFrame:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    statLogs.Text = "📝 0"
    logStatusLbl.Text = "⏸  Arrêté"
    notify("Effacé", "warning")
    playSnd(SND.Click, 0.3)
end)

floatBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
    if not gui.Enabled then
        task.delay(0.05, function() gui.Enabled = true end)
        floatBtn.Visible = true
    end
end)

-- Raccourcis clavier (PC)
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        btnScan.MouseButton1Click:Fire?()
    elseif input.KeyCode == Enum.KeyCode.RightControl then
        if sessionActive then stopSession("Raccourci") else startBtn.MouseButton1Click:Fire?() end
    elseif input.KeyCode == Enum.KeyCode.RightAlt then
        btnCopy.MouseButton1Click:Fire?()
    end
end)

notify("🐾 Scanner v5 prêt !", "success")
playSnd(SND.Notify, 0.4)
task.delay(1.2, function()
    notify("💡 Raccourcis PC : RShift scan · RCtrl start · RAlt copie")
end)

getgenv().AMScannerV5 = {
    gui = gui, logs = logs, remotes = foundRemotes,
    scan = function() btnScan.MouseButton1Click:Fire?() end,
    start = function() startBtn.MouseButton1Click:Fire?() end,
    copy = function() btnCopy.MouseButton1Click:Fire?() end,
}

end)

if not _ok then
    warn("[AMScannerV5] " .. tostring(_err))
end