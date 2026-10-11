--[[
============================================================
  🐾  ADOPT ME ULTIMATE SCANNER v3  🐾
  ─────────────────────────────────────────
  ✓ Images pets Adopt Me (asset IDs)
  ✓ Mini-jeu "Tap the Pet" pour patienter
  ✓ Bouton START + durée configurable
  ✓ Timer countdown visuel
  ✓ Timestamps sur les logs
  ✓ Recherche live
  ✓ Stats live (remotes / events / funcs / logs)
  ✓ Mobile & PC friendly
  ✓ Bouton flottant 🐾 (ferme/rouvre)
  ✓ 100% autonome — aucune requête réseau
============================================================
]]

-- ============================================================
-- SERVICES
-- ============================================================
local Players           = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReplicatedFirst   = game:GetService("ReplicatedFirst")
local UserInputService  = game:GetService("UserInputService")
local TweenService      = game:GetService("TweenService")
local RunService        = game:GetService("RunService")
local Workspace         = game:GetService("Workspace")
local CoreGui           = game:GetService("CoreGui")
local Lighting          = game:GetService("Lighting")
local SoundService      = game:GetService("SoundService")
local LocalPlayer       = Players.LocalPlayer

-- ============================================================
-- THÈME ADOPT ME
-- ============================================================
local T = {
    Bg         = Color3.fromRGB(255, 245, 252),
    Card       = Color3.fromRGB(255, 255, 255),
    CardAlt    = Color3.fromRGB(255, 235, 248),
    Pink       = Color3.fromRGB(255, 130, 190),
    PinkDark   = Color3.fromRGB(230, 90, 150),
    Purple     = Color3.fromRGB(180, 140, 240),
    PurpleDark = Color3.fromRGB(140, 100, 210),
    Mint       = Color3.fromRGB(150, 230, 200),
    Yellow     = Color3.fromRGB(255, 210, 120),
    Text       = Color3.fromRGB(80, 50, 100),
    TextDim    = Color3.fromRGB(160, 140, 180),
    TextLight  = Color3.fromRGB(255, 255, 255),
    Error      = Color3.fromRGB(255, 120, 130),
    Success    = Color3.fromRGB(120, 220, 150),
    Border     = Color3.fromRGB(255, 200, 230),
    Shadow     = Color3.fromRGB(255, 170, 210),
    Sky        = Color3.fromRGB(190, 230, 255),
}

local FONT_H    = Enum.Font.GothamBlack
local FONT_B    = Enum.Font.GothamBold
local FONT_R    = Enum.Font.Gotham
local FONT_CODE = Enum.Font.Code

-- ============================================================
-- ASSETS IMAGES (Roblox IDs)
-- ============================================================
local IMG = {
    -- Icônes UI
    Paw      = "rbxassetid://120204214310777",
    Heart    = "rbxassetid://6031075931",
    Close    = "rbxassetid://6031096226",
    Minus    = "rbxassetid://6031090992",
    Search   = "rbxassetid://6031096677",
    Copy     = "rbxassetid://6031280882",
    Refresh  = "rbxassetid://6031096677",
    Play     = "rbxassetid://6031075931",
    Stop     = "rbxassetid://6031094667",
    Trash    = "rbxassetid://6023426926",
    Menu     = "rbxassetid://6031234412",

    -- Images "pets" décoratifs (asset IDs publics génériques)
    -- Tu peux les remplacer par d'autres asset IDs que tu préfères.
    PetDog    = "rbxassetid://6023426926",
    PetCat    = "rbxassetid://6026568198",
    PetBunny  = "rbxassetid://6031075931",
    PetDragon = "rbxassetid://6031090992",
    PetUnicorn= "rbxassetid://6034684930",
    PetPhoenix= "rbxassetid://6031094667",
    PetEgg    = "rbxassetid://6034287456",
    PetPaw    = "rbxassetid://6023426926",
}

-- Table des pets pour le mini-jeu + affichage décoratif
local PETS = {
    { name = "Dog",     img = IMG.PetDog,     color = Color3.fromRGB(255, 200, 130) },
    { name = "Cat",     img = IMG.PetCat,     color = Color3.fromRGB(200, 180, 255) },
    { name = "Bunny",   img = IMG.PetBunny,   color = Color3.fromRGB(255, 200, 230) },
    { name = "Dragon",  img = IMG.PetDragon,  color = Color3.fromRGB(180, 220, 180) },
    { name = "Unicorn", img = IMG.PetUnicorn, color = Color3.fromRGB(255, 220, 240) },
    { name = "Phoenix", img = IMG.PetPhoenix, color = Color3.fromRGB(255, 180, 120) },
}

-- ============================================================
-- HELPERS
-- ============================================================
local function make(cls, props, kids)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do
        if k ~= "Parent" then o[k] = v end
    end
    for _, c in ipairs(kids or {}) do c.Parent = o end
    if props and props.Parent then o.Parent = props.Parent end
    return o
end

local function corner(p, r)
    return make("UICorner", { CornerRadius = UDim.new(0, r or 10), Parent = p })
end

local function stroke(p, color, thickness, transparency)
    return make("UIStroke", {
        Color = color or T.Border,
        Thickness = thickness or 1.5,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = p,
    })
end

local function pad(p, all, top, bottom, left, right)
    return make("UIPadding", {
        PaddingTop    = UDim.new(0, top    or all or 0),
        PaddingBottom = UDim.new(0, bottom or all or 0),
        PaddingLeft   = UDim.new(0, left   or all or 0),
        PaddingRight  = UDim.new(0, right  or all or 0),
        Parent = p,
    })
end

local function grad(p, c1, c2, rot)
    return make("UIGradient", {
        Color = ColorSequence.new(c1, c2),
        Rotation = rot or 0,
        Parent = p,
    })
end

local function isMobile()
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function playSound(id, vol)
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://" .. tostring(id or 6895086596)
        s.Volume = vol or 0.4
        s.Parent = SoundService
        s:Play()
        task.delay(2, function() s:Destroy() end)
    end)
end

-- ============================================================
-- GUI PARENT
-- ============================================================
local parentGui = (gethui and gethui()) or CoreGui

local gui = make("ScreenGui", {
    Name = "AdoptMeScannerV3_" .. tostring(math.random(10000, 99999)),
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = parentGui,
})

-- ============================================================
-- NOTIFICATIONS
-- ============================================================
local notifHolder = make("Frame", {
    Size = UDim2.new(0, 260, 1, -40),
    Position = UDim2.new(1, -270, 0, 20),
    BackgroundTransparency = 1,
    Parent = gui,
})
make("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    VerticalAlignment = Enum.VerticalAlignment.Bottom,
    Padding = UDim.new(0, 6),
    Parent = notifHolder,
})

local function notify(text, kind)
    kind = kind or "info"
    local accent = T.Pink
    local icon = "🐾"
    if kind == "success" then accent = T.Success; icon = "✅" end
    if kind == "warning" then accent = T.Yellow; icon = "⚠️" end
    if kind == "error"   then accent = T.Error;  icon = "❌" end

    local f = make("Frame", {
        Size = UDim2.new(0, 250, 0, 42),
        BackgroundColor3 = T.Card,
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Parent = notifHolder,
    })
    corner(f, 10)
    stroke(f, accent, 1.5)

    make("Frame", {
        Size = UDim2.new(0, 4, 1, -12),
        Position = UDim2.new(0, 6, 0, 6),
        BackgroundColor3 = accent,
        BorderSizePixel = 0,
        Parent = f,
    })

    make("TextLabel", {
        Size = UDim2.new(1, -24, 1, 0),
        Position = UDim2.new(0, 16, 0, 0),
        BackgroundTransparency = 1,
        Text = icon .. "  " .. text,
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        Parent = f,
    })

    f.Position = UDim2.new(1, 20, 0, 0)
    task.spawn(function()
        TweenService:Create(f, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 0,
        }):Play()
        task.wait(3)
        TweenService:Create(f, TweenInfo.new(0.3), {
            Position = UDim2.new(1, 20, 0, 0),
            BackgroundTransparency = 1,
        }):Play()
        task.wait(0.35)
        f:Destroy()
    end)
end

-- ============================================================
-- BOUTON FLOTTANT (toggle window)
-- ============================================================
local floatBtn = make("TextButton", {
    Name = "FloatButton",
    Size = UDim2.new(0, 54, 0, 54),
    Position = UDim2.new(0, 20, 0.5, -27),
    BackgroundColor3 = T.Pink,
    Text = "",
    AutoButtonColor = false,
    Parent = gui,
})
corner(floatBtn, 27)
stroke(floatBtn, T.PinkDark, 2)
grad(floatBtn, T.Pink, T.Purple, 45)

make("TextLabel", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Text = "🐾",
    TextSize = 26,
    Font = FONT_B,
    Parent = floatBtn,
})

-- Drag float button
do
    local dragging, dragStart, startPos
    floatBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = floatBtn.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            floatBtn.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

-- ============================================================
-- FENÊTRE PRINCIPALE
-- ============================================================
local isSmall = isMobile()
local winW = isSmall and 400 or 700
local winH = isSmall and 520 or 540

local window = make("Frame", {
    Name = "Window",
    Size = UDim2.new(0, winW, 0, winH),
    Position = UDim2.new(0.5, -winW/2, 0.5, -winH/2),
    BackgroundColor3 = T.Bg,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    Parent = gui,
})
corner(window, 18)
stroke(window, T.Pink, 2.5, 0.2)

-- HEADER
local header = make("Frame", {
    Size = UDim2.new(1, 0, 0, 72),
    BackgroundColor3 = T.Pink,
    BorderSizePixel = 0,
    Parent = window,
})
corner(header, 18)
make("Frame", {
    Size = UDim2.new(1, 0, 0, 30),
    Position = UDim2.new(0, 0, 1, -30),
    BackgroundColor3 = T.Pink,
    BorderSizePixel = 0,
    Parent = header,
})
grad(header, T.Pink, T.Purple, 15)

make("TextLabel", {
    Size = UDim2.new(1, -120, 0, 26),
    Position = UDim2.new(0, 60, 0, 12),
    BackgroundTransparency = 1,
    Text = "ADOPT ME SCANNER",
    TextColor3 = T.TextLight,
    Font = FONT_H,
    TextSize = 20,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})

make("TextLabel", {
    Size = UDim2.new(1, -120, 0, 16),
    Position = UDim2.new(0, 60, 0, 38),
    BackgroundTransparency = 1,
    Text = "🐾 v3 · Remotes · Logs · Mini-jeu",
    TextColor3 = Color3.fromRGB(255, 240, 250),
    Font = FONT_R,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = header,
})

-- Pet image dans le header (rotatif)
local headerPet = make("ImageLabel", {
    Size = UDim2.new(0, 48, 0, 48),
    Position = UDim2.new(0, 10, 0, 12),
    BackgroundTransparency = 1,
    Image = IMG.PetDog,
    ImageColor3 = Color3.new(1, 1, 1),
    Parent = header,
})

-- Animation : change de pet régulièrement
task.spawn(function()
    local i = 1
    while headerPet.Parent do
        headerPet.Image = PETS[i].img
        i = i % #PETS + 1
        task.wait(2.5)
    end
end)

-- Boutons header
local function hBtn(label, xOff, cb)
    local b = make("TextButton", {
        Size = UDim2.new(0, 28, 0, 28),
        Position = UDim2.new(1, xOff, 0, 22),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 0.75,
        Text = label,
        TextColor3 = T.TextLight,
        Font = FONT_B,
        TextSize = 14,
        AutoButtonColor = false,
        Parent = header,
    })
    corner(b, 10)
    b.MouseButton1Click:Connect(cb)
    return b
end

local closeBtn    = hBtn("✕", -34, function()
    gui.Enabled = false
    notify("UI fermée. Clique sur 🐾 pour rouvrir.", "info")
end)
local minimizeBtn = hBtn("–", -66, function() end)

-- Drag window
do
    local dragging, dragStart, startPos
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            window.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y
            )
        end
    end)
end

local minimized = false
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    local targetH = minimized and 72 or winH
    TweenService:Create(window, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size = UDim2.new(0, winW, 0, targetH),
    }):Play()
    for _, c in ipairs(window:GetChildren()) do
        if c ~= header and c:IsA("GuiObject") then
            c.Visible = not minimized
        end
    end
end)

-- ============================================================
-- STATS BAR (live)
-- ============================================================
local statsBar = make("Frame", {
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 0, 80),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
    Parent = window,
})
corner(statsBar, 10)
stroke(statsBar, T.Border, 1)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Parent = statsBar,
})
pad(statsBar, 6)

local function statChip(label, color, order)
    local c = make("Frame", {
        Size = UDim2.new(0, 88, 1, -4),
        BackgroundColor3 = color,
        BackgroundTransparency = 0.85,
        LayoutOrder = order,
        Parent = statsBar,
    })
    corner(c, 8)
    stroke(c, color, 1.5, 0.3)
    local lbl = make("TextLabel", {
        Size = UDim2.new(1, -8, 1, 0),
        Position = UDim2.new(0, 4, 0, 0),
        BackgroundTransparency = 1,
        Text = label,
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 11,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = c,
    })
    return lbl
end

local statTotal  = statChip("📡 0", T.Purple, 1)
local statEvents = statChip("⚡ 0", T.Pink,   2)
local statFuncs  = statChip("🔶 0", T.Mint,   3)
local statLogs   = statChip("📝 0", T.Yellow, 4)

-- ============================================================
-- BARRE START + TIMER
-- ============================================================
local startBar = make("Frame", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 122),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
    Parent = window,
})
corner(startBar, 10)
stroke(startBar, T.Border, 1)
pad(startBar, 6)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = startBar,
})

-- Bouton START / STOP enregistrement auto
local startBtn = make("TextButton", {
    Size = UDim2.new(0, 130, 1, 0),
    BackgroundColor3 = T.Success,
    Text = "▶  DÉMARRER (60s)",
    TextColor3 = T.TextLight,
    Font = FONT_B,
    TextSize = 12,
    AutoButtonColor = false,
    LayoutOrder = 1,
    Parent = startBar,
})
corner(startBtn, 9)
grad(startBtn, T.Success, Color3.fromRGB(90, 200, 130), 0)

-- Bouton durée (cycle 30 / 60 / 120 / 300 / ∞)
local durations = { 30, 60, 120, 300, 0 } -- 0 = infini
local durIdx = 2

local durBtn = make("TextButton", {
    Size = UDim2.new(0, 110, 1, 0),
    BackgroundColor3 = T.Purple,
    Text = "⏱  Durée: 60s",
    TextColor3 = T.TextLight,
    Font = FONT_B,
    TextSize = 12,
    AutoButtonColor = false,
    LayoutOrder = 2,
    Parent = startBar,
})
corner(durBtn, 9)
grad(durBtn, T.Purple, T.PurpleDark, 0)

durBtn.MouseButton1Click:Connect(function()
    durIdx = durIdx % #durations + 1
    local d = durations[durIdx]
    durBtn.Text = d == 0 and "⏱  Durée: ∞" or ("⏱  Durée: " .. d .. "s")
    startBtn.Text = d == 0 and "▶  DÉMARRER (∞)" or ("▶  DÉMARRER (" .. d .. "s)")
    playSound(6895086596, 0.2)
end)

-- Timer display
local timerLbl = make("TextLabel", {
    Size = UDim2.new(1, -250, 1, 0),
    Position = UDim2.new(0, 250, 0, 0),
    BackgroundTransparency = 1,
    Text = "Prêt à scanner",
    TextColor3 = T.Text,
    Font = FONT_B,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    LayoutOrder = 3,
    Parent = startBar,
})

-- Barre de progression
local progressBar = make("Frame", {
    Size = UDim2.new(0, 0, 0, 4),
    Position = UDim2.new(0, 10, 0, 165),
    BackgroundColor3 = T.Pink,
    BorderSizePixel = 0,
    Parent = window,
})
corner(progressBar, 2)
grad(progressBar, T.Pink, T.Purple, 0)

-- ============================================================
-- TAB BAR
-- ============================================================
local tabBar = make("Frame", {
    Size = UDim2.new(1, -20, 0, 36),
    Position = UDim2.new(0, 10, 0, 178),
    BackgroundColor3 = T.CardAlt,
    BorderSizePixel = 0,
    Parent = window,
})
corner(tabBar, 10)
pad(tabBar, 4)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 4),
    Parent = tabBar,
})

-- Content
local content = make("Frame", {
    Size = UDim2.new(1, -20, 1, -290),
    Position = UDim2.new(0, 10, 0, 222),
    BackgroundColor3 = T.Card,
    BorderSizePixel = 0,
    Parent = window,
})
corner(content, 12)
stroke(content, T.Border, 1)
pad(content, 8)

local tabs = {}
local activeTab

local function createTab(id, label, order)
    local b = make("TextButton", {
        Size = UDim2.new(0, 92, 1, 0),
        BackgroundColor3 = T.CardAlt,
        BackgroundTransparency = 0.3,
        Text = label,
        TextColor3 = T.TextDim,
        Font = FONT_B,
        TextSize = 11,
        AutoButtonColor = false,
        LayoutOrder = order,
        Parent = tabBar,
    })
    corner(b, 8)

    local page = make("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 5,
        ScrollBarImageColor3 = T.Pink,
        ScrollBarImageTransparency = 0.3,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false,
        Parent = content,
    })
    make("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 4),
        Parent = page,
    })

    tabs[id] = { btn = b, page = page }

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
        playSound(6895086596, 0.25)
    end)

    return page
end

local scanPage  = createTab("scan",   "🔍 Scan",   1)
local logPage   = createTab("log",    "📝 Logs",   2)
local filterPage= createTab("filter", "🎯 Filtre", 3)
local gamePage  = createTab("game",   "🎮 Jeu",    4)
local helpPage  = createTab("help",   "ℹ️ Aide",   5)

activeTab = "scan"
tabs.scan.btn.BackgroundColor3 = T.Pink
tabs.scan.btn.BackgroundTransparency = 0
tabs.scan.btn.TextColor3 = T.TextLight
scanPage.Visible = true

-- ============================================================
-- PAGE SCAN
-- ============================================================
local searchBox
do
    local top = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = scanPage,
    })
    searchBox = make("TextBox", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.CardAlt,
        BorderSizePixel = 0,
        PlaceholderText = "🔍  Rechercher un remote...",
        PlaceholderColor3 = T.TextDim,
        Text = "",
        TextColor3 = T.Text,
        Font = FONT_R,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        ClearTextOnFocus = false,
        Parent = top,
    })
    corner(searchBox, 8)
    stroke(searchBox, T.Border, 1)
    pad(searchBox, 0, 0, 0, 10, 10)
end

local scanListFrame = make("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Parent = scanPage,
})

-- ============================================================
-- PAGE LOGS
-- ============================================================
local logCount = 0
local logActive = false
local logStatusLbl
do
    local top = make("Frame", {
        Size = UDim2.new(1, 0, 0, 26),
        BackgroundTransparency = 1,
        LayoutOrder = 1,
        Parent = logPage,
    })
    logStatusLbl = make("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "⏸  Logger arrêté",
        TextColor3 = T.Yellow,
        Font = FONT_B,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = top,
    })
end

local logListFrame = make("Frame", {
    Size = UDim2.new(1, 0, 0, 0),
    BackgroundTransparency = 1,
    LayoutOrder = 2,
    Parent = logPage,
})
make("UIListLayout", {
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 3),
    Parent = logListFrame,
})

-- ============================================================
-- PAGE FILTRE
-- ============================================================
local filters = {
    RemoteEvent            = true,
    RemoteFunction         = true,
    UnreliableRemoteEvent  = true,
    BindableEvent          = true,
    BindableFunction       = true,
}
do
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24),
        BackgroundTransparency = 1,
        Text = "🎯  Filtrer les types affichés :",
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = filterPage,
    })

    local order = 2
    for cls, _ in pairs(filters) do
        local row = make("TextButton", {
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = T.CardAlt,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            LayoutOrder = order,
            Parent = filterPage,
        })
        corner(row, 8)
        stroke(row, T.Border, 1)
        order = order + 1

        local chk = make("Frame", {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 8, 0.5, -10),
            BackgroundColor3 = T.Pink,
            BorderSizePixel = 0,
            Parent = row,
        })
        corner(chk, 6)
        local tick = make("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "✓",
            TextColor3 = T.TextLight,
            Font = FONT_H,
            TextSize = 14,
            Parent = chk,
        })

        make("TextLabel", {
            Size = UDim2.new(1, -50, 1, 0),
            Position = UDim2.new(0, 36, 0, 0),
            BackgroundTransparency = 1,
            Text = cls,
            TextColor3 = T.Text,
            Font = FONT_R,
            TextSize = 13,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = row,
        })

        row.MouseButton1Click:Connect(function()
            filters[cls] = not filters[cls]
            chk.BackgroundColor3 = filters[cls] and T.Pink or T.TextDim
            tick.Visible = filters[cls]
            renderScanList(searchBox.Text)
        end)
    end
end

-- ============================================================
-- MINI-JEU "TAP THE PET"
-- ============================================================
local gameRunning = false
local gameScore = 0
local gameBest = 0
local gameTimeLeft = 0
local gameFrame, gameScoreLbl, gameBestLbl, gameTimeLbl, gameField, gameStartBtn

do
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 22),
        BackgroundTransparency = 1,
        Text = "🎮  Tape les pets qui apparaissent ! (30s)",
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 13,
        TextXAlignment = Enum.TextXAlignment.Left,
        LayoutOrder = 1,
        Parent = gamePage,
    })

    -- Stats du jeu
    local gsBar = make("Frame", {
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        Parent = gamePage,
    })
    make("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding = UDim.new(0, 6),
        Parent = gsBar,
    })

    gameScoreLbl = make("TextLabel", {
        Size = UDim2.new(0, 90, 1, 0),
        BackgroundColor3 = T.Pink,
        BackgroundTransparency = 0.85,
        Text = "🏆 Score: 0",
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 12,
        LayoutOrder = 1,
        Parent = gsBar,
    })
    corner(gameScoreLbl, 8)
    stroke(gameScoreLbl, T.Pink, 1)

    gameBestLbl = make("TextLabel", {
        Size = UDim2.new(0, 90, 1, 0),
        BackgroundColor3 = T.Purple,
        BackgroundTransparency = 0.85,
        Text = "⭐ Best: 0",
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 12,
        LayoutOrder = 2,
        Parent = gsBar,
    })
    corner(gameBestLbl, 8)
    stroke(gameBestLbl, T.Purple, 1)

    gameTimeLbl = make("TextLabel", {
        Size = UDim2.new(0, 90, 1, 0),
        BackgroundColor3 = T.Mint,
        BackgroundTransparency = 0.8,
        Text = "⏱ 30s",
        TextColor3 = T.Text,
        Font = FONT_B,
        TextSize = 12,
        LayoutOrder = 3,
        Parent = gsBar,
    })
    corner(gameTimeLbl, 8)
    stroke(gameTimeLbl, T.Mint, 1)

    -- Champ de jeu
    gameField = make("Frame", {
        Size = UDim2.new(1, 0, 0, 220),
        BackgroundColor3 = T.Sky,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        LayoutOrder = 3,
        Parent = gamePage,
    })
    corner(gameField, 12)
    stroke(gameField, T.Purple, 1.5, 0.3)

    make("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "🐾  Appuie sur DÉMARRER",
        TextColor3 = Color3.fromRGB(140, 180, 220),
        Font = FONT_B,
        TextSize = 15,
        Parent = gameField,
    })

    gameStartBtn = make("TextButton", {
        Size = UDim2.new(1, 0, 0, 38),
        BackgroundColor3 = T.Pink,
        Text = "▶  DÉMARRER LE MINI-JEU",
        TextColor3 = T.TextLight,
        Font = FONT_B,
        TextSize = 13,
        AutoButtonColor = false,
        LayoutOrder = 4,
        Parent = gamePage,
    })
    corner(gameStartBtn, 9)
    grad(gameStartBtn, T.Pink, T.Purple, 0)
end

-- Logique du mini-jeu
local function spawnPetInGame()
    if not gameRunning then return end
    local pet = PETS[math.random(1, #PETS)]
    local btn = make("TextButton", {
        Size = UDim2.new(0, 54, 0, 54),
        Position = UDim2.new(
            math.random() * 0.85,
            0,
            math.random() * 0.75,
            0
        ),
        BackgroundColor3 = pet.color,
        BackgroundTransparency = 0.15,
        Text = "",
        AutoButtonColor = false,
        Parent = gameField,
    })
    corner(btn, 27)
    stroke(btn, Color3.new(1, 1, 1), 2, 0.2)

    make("ImageLabel", {
        Size = UDim2.new(0.7, 0, 0.7, 0),
        Position = UDim2.new(0.15, 0, 0.15, 0),
        BackgroundTransparency = 1,
        Image = pet.img,
        Parent = btn,
    })

    -- Animation pop-in
    btn.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 54, 0, 54),
    }):Play()

    local clicked = false
    btn.MouseButton1Click:Connect(function()
        if clicked or not gameRunning then return end
        clicked = true
        gameScore = gameScore + 1
        gameScoreLbl.Text = "🏆 Score: " .. gameScore
        playSound(6895086596, 0.3)
        TweenService:Create(btn, TweenInfo.new(0.15), {
            Size = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
        }):Play()
        task.wait(0.15)
        btn:Destroy()
    end)

    -- Auto-destruction si pas cliqué
    task.delay(1.5, function()
        if btn.Parent and not clicked then
            TweenService:Create(btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0),
            }):Play()
            task.wait(0.25)
            btn:Destroy()
        end
    end)
end

gameStartBtn.MouseButton1Click:Connect(function()
    if gameRunning then return end
    gameRunning = true
    gameScore = 0
    gameTimeLeft = 30
    gameScoreLbl.Text = "🏆 Score: 0"
    gameStartBtn.Text = "⏸  JEU EN COURS..."
    gameStartBtn.BackgroundColor3 = T.Error

    for _, c in ipairs(gameField:GetChildren()) do
        if c:IsA("GuiObject") and c:IsA("TextButton") then c:Destroy() end
    end

    local endTime = tick() + 30
    local loop = task.spawn(function()
        while gameRunning do
            gameTimeLeft = math.max(0, math.ceil(endTime - tick()))
            gameTimeLbl.Text = "⏱ " .. gameTimeLeft .. "s"
            if gameTimeLeft <= 0 then break end
            spawnPetInGame()
            task.wait(math.random(50, 90) / 100)
        end
    end)

    task.delay(30, function()
        gameRunning = false
        gameStartBtn.Text = "▶  DÉMARRER LE MINI-JEU"
        gameStartBtn.BackgroundColor3 = T.Pink
        if gameScore > gameBest then
            gameBest = gameScore
            gameBestLbl.Text = "⭐ Best: " .. gameBest
            notify("🏆 Nouveau record : " .. gameScore .. " !", "success")
        else
            notify("Score : " .. gameScore, "info")
        end
        for _, c in ipairs(gameField:GetChildren()) do
            if c:IsA("TextButton") then c:Destroy() end
        end
        make("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "🏁  Partie terminée ! Score : " .. gameScore,
            TextColor3 = Color3.fromRGB(140, 180, 220),
            Font = FONT_B,
            TextSize = 15,
            Parent = gameField,
        })
    end)
end)

-- ============================================================
-- PAGE AIDE
-- ============================================================
do
    make("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Text = table.concat({
            "🐾  GUIDE RAPIDE",
            "",
            "1.  Clique sur  ▶ DÉMARRER  en haut",
            "    → choisir la durée avec  ⏱ DURÉE",
            "    → le scan + log démarrent tout seuls",
            "",
            "2.  Pendant ce temps, va sur l'onglet",
            "    🎮 JEU  pour taper des pets et",
            "    gagner du temps !",
            "",
            "3.  Joue à Adopt Me :",
            "    •  ouvre un œuf  🥚",
            "    •  équipe un pet  🐶",
            "    •  va à l'événement Halloween  🎃",
            "    •  clique portes / autels / bonbons",
            "    •  fais un trade",
            "",
            "4.  Clique sur  📋 COPIER TOUT  en bas",
            "    → envoie le texte au développeur.",
            "",
            "────────────────────",
            "🔒  SÉCURITÉ",
            "•  Aucun chargement distant",
            "•  Aucune requête HTTP",
            "•  100% autonome",
            "",
            "🎨  MOBILE",
            "•  Glisse le header pour bouger",
            "•  Glisse 🐾 pour déplacer le bouton",
            "•  Tap 🐾 pour fermer/rouvrir l'UI",
        }, "\n"),
        TextColor3 = T.Text,
        Font = FONT_R,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true,
        Parent = helpPage,
    })
end

-- ============================================================
-- FOOTER
-- ============================================================
local footer = make("Frame", {
    Size = UDim2.new(1, -20, 0, 52),
    Position = UDim2.new(0, 10, 1, -60),
    BackgroundColor3 = T.CardAlt,
    BorderSizePixel = 0,
    Parent = window,
})
corner(footer, 12)
pad(footer, 6)
make("UIListLayout", {
    FillDirection = Enum.FillDirection.Horizontal,
    SortOrder = Enum.SortOrder.LayoutOrder,
    Padding = UDim.new(0, 6),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    Parent = footer,
})

local function fBtn(label, color, order, wide)
    local b = make("TextButton", {
        Size = UDim2.new(0, wide and 130 or 100, 1, 0),
        BackgroundColor3 = color,
        Text = label,
        TextColor3 = T.TextLight,
        Font = FONT_B,
        TextSize = 12,
        AutoButtonColor = false,
        LayoutOrder = order,
        Parent = footer,
    })
    corner(b, 9)
    grad(b, color, Color3.new(
        math.min(1, color.R + 0.1),
        math.min(1, color.G + 0.05),
        math.min(1, color.B + 0.1)
    ), 0)
    return b
end

local btnScan  = fBtn("🔄  SCANNER",     T.Purple, 1, true)
local btnCopy  = fBtn("📋  COPIER TOUT", T.Pink,   2, true)
local btnClear = fBtn("🗑  CLEAR",       T.Error,  3)

-- ============================================================
-- SCAN LOGIC
-- ============================================================
local foundRemotes = {}
local remoteRefs   = {}
local hookedSet    = {}

local function getPath(o)
    local ok, p = pcall(function() return o:GetFullName() end)
    return ok and p or o.Name
end

local function scanObject(container, seen, list)
    if not container or seen[container] then return end
    seen[container] = true
    for _, o in ipairs(container:GetDescendants()) do
        local c = o.ClassName
        if c == "RemoteEvent" or c == "RemoteFunction"
        or c == "UnreliableRemoteEvent"
        or c == "BindableEvent" or c == "BindableFunction" then
            table.insert(list, { path = getPath(o), class = c, name = o.Name, ref = o })
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
        LocalPlayer.Character,
        Lighting, SoundService,
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

-- ============================================================
-- RENDER SCAN LIST
-- ============================================================
function renderScanList(filter)
    for _, c in ipairs(scanListFrame:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    filter = (filter or ""):lower()

    local groups = {}
    local count = 0
    for _, r in ipairs(foundRemotes) do
        if filters[r.class] and (filter == "" or r.name:lower():find(filter, 1, true)) then
            local pp = r.path:match("^(.*)%.[^%.]+$") or "Racine"
            groups[pp] = groups[pp] or {}
            table.insert(groups[pp], r)
            count = count + 1
        end
    end

    if count == 0 then
        make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 40),
            BackgroundTransparency = 1,
            Text = "Aucun remote. Clique sur '🔄 SCANNER'.",
            TextColor3 = T.TextDim,
            Font = FONT_R,
            TextSize = 13,
            Parent = scanListFrame,
        })
        return
    end

    local order = 0
    for pp, list in pairs(groups) do
        order = order + 1
        local h = make("TextLabel", {
            Size = UDim2.new(1, 0, 0, 24),
            BackgroundColor3 = T.CardAlt,
            BackgroundTransparency = 0.2,
            Text = "  📁  " .. pp .. "  (" .. #list .. ")",
            TextColor3 = T.PurpleDark,
            Font = FONT_B,
            TextSize = 11,
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = order,
            Parent = scanListFrame,
        })
        corner(h, 6)
        pad(h, 4)

        for _, r in ipairs(list) do
            order = order + 1
            local icon = "🔹"
            if r.class == "RemoteFunction" then icon = "🔶" end
            if r.class == "UnreliableRemoteEvent" then icon = "⚡" end
            if r.class == "BindableEvent" then icon = "🧩" end

            local row = make("TextButton", {
                Size = UDim2.new(1, -12, 0, 24),
                BackgroundColor3 = T.CardAlt,
                BackgroundTransparency = 0.5,
                Text = "   " .. icon .. "  " .. r.name .. "  ·  " .. r.class,
                TextColor3 = T.Text,
                Font = FONT_CODE,
                TextSize = 11,
                TextXAlignment = Enum.TextXAlignment.Left,
                AutoButtonColor = false,
                LayoutOrder = order,
                Parent = scanListFrame,
            })
            corner(row, 6)
            pad(row, 0, 0, 0, 6, 6)

            row.MouseEnter:Connect(function()
                row.BackgroundColor3 = T.Pink
                row.BackgroundTransparency = 0.75
            end)
            row.MouseLeave:Connect(function()
                row.BackgroundColor3 = T.CardAlt
                row.BackgroundTransparency = 0.5
            end)
            row.MouseButton1Click:Connect(function()
                if setclipboard then
                    setclipboard(r.path)
                    notify("Copié : " .. r.name, "success")
                end
            end)
        end
    end
end

searchBox:GetPropertyChangedSignal("Text"):Connect(function()
    renderScanList(searchBox.Text)
end)

-- ============================================================
-- LOGGER
-- ============================================================
local logs = {}
local MAX_LOGS = 600

local function addLog(tag, remoteName, args)
    if not logActive then return end
    local parts = {}
    for i, v in ipairs(args) do
        local ok, s = pcall(function()
            if type(v) == "table" then
                local inner = {}
                for k, vv in pairs(v) do
                    table.insert(inner, tostring(k) .. "=" .. tostring(vv))
                end
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

    local color = T.Text
    if tag == "SEND"   then color = T.PinkDark end
    if tag == "RECV"   then color = T.PurpleDark end
    if tag == "INVOKE" then color = T.Yellow end

    local lbl = make("TextLabel", {
        Size = UDim2.new(1, -8, 0, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.CardAlt,
        BackgroundTransparency = 0.5,
        Text = "  " .. text,
        TextColor3 = color,
        Font = FONT_CODE,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        Parent = logListFrame,
    })
    corner(lbl, 6)
    pad(lbl, 4)
    lbl.Text = "  " .. text

    logCount = logCount + 1
    statLogs.Text = "📝 " .. logCount
    logStatusLbl.Text = string.format("%s  |  %d logs",
        logActive and "▶  Logger actif" or "⏸  Logger arrêté", logCount)
    logStatusLbl.TextColor3 = logActive and T.Success or T.Yellow
end

local function hookRemote(remote)
    if hookedSet[remote] then return end
    hookedSet[remote] = true
    pcall(function() remote:SetAttribute("__ck_hooked", true) end)

    local cls = remote.ClassName
    if cls == "RemoteEvent" or cls == "UnreliableRemoteEvent" then
        local oldFire = remote.FireServer
        remote.FireServer = newcclosure(function(self, ...)
            pcall(addLog, "SEND", remote.Name, {...})
            return oldFire(self, ...)
        end)
        remote.OnClientEvent:Connect(function(...)
            pcall(addLog, "RECV", remote.Name, {...})
        end)
    elseif cls == "RemoteFunction" then
        local oldInvoke = remote.InvokeServer
        remote.InvokeServer = newcclosure(function(self, ...)
            pcall(addLog, "INVOKE", remote.Name, {...})
            return oldInvoke(self, ...)
        end)
        pcall(function()
            local oldOnClient = remote.OnClientInvoke
            if oldOnClient then
                remote.OnClientInvoke = newcclosure(function(...)
                    pcall(addLog, "RECV-INV", remote.Name, {...})
                    return oldOnClient(...)
                end)
            end
        end)
    end
end

-- ============================================================
-- START / STOP AUTO SCAN + LOG
-- ============================================================
local sessionActive = false
local sessionEnd = 0
local sessionDur = 60

local function stopSession(reason)
    sessionActive = false
    logActive = false
    startBtn.Text = "▶  DÉMARRER (" .. (sessionDur == 0 and "∞" or (sessionDur .. "s")) .. ")"
    startBtn.BackgroundColor3 = T.Success
    timerLbl.Text = reason or "Terminé"
    TweenService:Create(progressBar, TweenInfo.new(0.3), {
        Size = UDim2.new(0, 0, 0, 4),
    }):Play()
    notify("Session terminée. Clique sur 📋 COPIER TOUT", "success")
end

startBtn.MouseButton1Click:Connect(function()
    if sessionActive then
        stopSession("Arrêté manuellement")
        return
    end
    sessionDur = durations[durIdx]
    sessionActive = true

    logActive = true
    startBtn.Text = "⏹  ARRÊTER"
    startBtn.BackgroundColor3 = T.Error

    -- 1. Scan auto
    timerLbl.Text = "Scan en cours..."
    notify("Scan automatique...", "info")
    task.spawn(function()
        doScan()
        renderScanList(searchBox.Text)
        notify("✅ " .. #foundRemotes .. " remotes détectés", "success")

        -- 2. Hook tous les remotes
        for _, r in ipairs(remoteRefs) do pcall(hookRemote, r) end
        ReplicatedStorage.DescendantAdded:Connect(function(o)
            local c = o.ClassName
            if c == "RemoteEvent" or c == "RemoteFunction"
            or c == "UnreliableRemoteEvent" then
                task.wait(0.08)
                pcall(hookRemote, o)
                table.insert(foundRemotes, { path = getPath(o), class = c, name = o.Name, ref = o })
                table.insert(remoteRefs, o)
            end
        end)

        -- 3. Timer
        sessionEnd = sessionDur == 0 and math.huge or (tick() + sessionDur)
        local startT = tick()

        while sessionActive do
            if sessionDur == 0 then
                timerLbl.Text = string.format("⏺ Log actif — %d logs", logCount)
                TweenService:Create(progressBar, TweenInfo.new(0.5), {
                    Size = UDim2.new(0.5, 0, 0, 4),
                }):Play()
            else
                local left = math.max(0, math.ceil(sessionEnd - tick()))
                timerLbl.Text = string.format("⏱ %ds restants — %d logs", left, logCount)
                local pct = 1 - (left / sessionDur)
                TweenService:Create(progressBar, TweenInfo.new(0.2), {
                    Size = UDim2.new(pct, 0, 0, 4),
                }):Play()
                if left <= 0 then break end
            end
            task.wait(0.25)
        end

        if sessionActive then
            stopSession("Durée écoulée ✓")
            if not gameRunning then
                notify("💡 Ouvre 🎮 JEU pour patienter la prochaine fois !", "info")
            end
        end
    end)
end)

-- ============================================================
-- SCAN MANUEL / COPIE / CLEAR
-- ============================================================
btnScan.MouseButton1Click:Connect(function()
    notify("Scan en cours...", "info")
    playSound(6895086596, 0.3)
    task.spawn(function()
        doScan()
        renderScanList(searchBox.Text)
        notify("✅ " .. #foundRemotes .. " remotes trouvés !", "success")
    end)
end)

btnCopy.MouseButton1Click:Connect(function()
    local L = {}
    table.insert(L, "=== ADOPT ME REMOTE SCAN & LOG ===")
    table.insert(L, "Date : " .. os.date("%Y-%m-%d %H:%M:%S"))
    table.insert(L, "Remotes : " .. #foundRemotes)
    table.insert(L, "Logs    : " .. #logs)
    table.insert(L, "")
    table.insert(L, "--- REMOTES ---")
    for i, r in ipairs(foundRemotes) do
        table.insert(L, string.format("[%d] (%s) %s", i, r.class, r.path))
    end
    table.insert(L, "")
    table.insert(L, "--- LOGS (horodatés) ---")
    for _, l in ipairs(logs) do table.insert(L, l) end

    local out = table.concat(L, "\n")
    if setclipboard then
        setclipboard(out)
        notify("📋 Copié ! (" .. #foundRemotes .. " remotes, " .. #logs .. " logs)", "success")
    else
        print(out)
        notify("setclipboard indispo — voir console", "error")
    end
end)

btnClear.MouseButton1Click:Connect(function()
    logs = {}
    logCount = 0
    for _, c in ipairs(logListFrame:GetChildren()) do
        if c:IsA("GuiObject") then c:Destroy() end
    end
    statLogs.Text = "📝 0"
    logStatusLbl.Text = "⏸  Logger arrêté"
    notify("Logs effacés.", "warning")
end)

-- ============================================================
-- FLOAT BUTTON TOGGLE
-- ============================================================
floatBtn.MouseButton1Click:Connect(function()
    gui.Enabled = not gui.Enabled
    if not gui.Enabled then
        task.delay(0.05, function() gui.Enabled = true end)
        -- Astuce : on garde le floatBtn visible
        floatBtn.Visible = true
    end
end)

-- ============================================================
-- DÉMARRAGE
-- ============================================================
notify("🐾 Scanner v3 prêt ! Clique sur ▶ DÉMARRER", "success")
task.delay(1.2, function()
    notify("💡 Onglet 🎮 JEU pour patienter pendant le scan", "info")
end)

getgenv().AdoptMeScannerV3 = {
    gui    = gui,
    scan   = function() btnScan.MouseButton1Click:Fire?() end,
    start  = function() startBtn.MouseButton1Click:Fire?() end,
    copy   = function() btnCopy.MouseButton1Click:Fire?() end,
    logs   = logs,
    remotes= foundRemotes,
}

return "🐾 Adopt Me Scanner v3 chargé."