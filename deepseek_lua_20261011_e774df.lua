-- Adopt Me Scanner V7 (100% natif)
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Création de l'interface
local parentGui = (gethui and gethui()) or game:GetService("CoreGui")
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AMScannerNative"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

-- Fenêtre principale
local win = Instance.new("Frame")
win.Size = UDim2.new(0, 320, 0, 280)
win.Position = UDim2.new(0.5, -160, 0.5, -140)
win.BackgroundColor3 = Color3.fromRGB(255, 245, 252)
win.BorderSizePixel = 0
win.Active = true
win.Draggable = true
win.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = win

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 130, 190)
stroke.Thickness = 2
stroke.Parent = win

-- Header
local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, 0, 0, 40)
header.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
header.Text = "🐾 Adopt Me Scanner"
header.TextColor3 = Color3.new(1, 1, 1)
header.Font = Enum.Font.GothamBold
header.TextSize = 16
header.Parent = win
local hCorner = Instance.new("UICorner")
hCorner.CornerRadius = UDim.new(0, 12)
hCorner.Parent = header
local fixCorner = Instance.new("Frame")
fixCorner.Size = UDim2.new(1, 0, 0, 15)
fixCorner.Position = UDim2.new(0, 0, 1, -15)
fixCorner.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
fixCorner.BorderSizePixel = 0
fixCorner.Parent = header

-- Bouton Scan
local scanBtn = Instance.new("TextButton")
scanBtn.Size = UDim2.new(1, -40, 0, 40)
scanBtn.Position = UDim2.new(0, 20, 0, 60)
scanBtn.BackgroundColor3 = Color3.fromRGB(180, 140, 240)
scanBtn.Text = "🔄 Scanner les remotes"
scanBtn.TextColor3 = Color3.new(1, 1, 1)
scanBtn.Font = Enum.Font.GothamBold
scanBtn.TextSize = 14
scanBtn.Parent = win
local sCorner = Instance.new("UICorner")
sCorner.CornerRadius = UDim.new(0, 8)
sCorner.Parent = scanBtn

-- Bouton Logger
local logBtn = Instance.new("TextButton")
logBtn.Size = UDim2.new(1, -40, 0, 40)
logBtn.Position = UDim2.new(0, 20, 0, 110)
logBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
logBtn.Text = "▶ Activer le Logger"
logBtn.TextColor3 = Color3.new(1, 1, 1)
logBtn.Font = Enum.Font.GothamBold
logBtn.TextSize = 14
logBtn.Parent = win
local lCorner = Instance.new("UICorner")
lCorner.CornerRadius = UDim.new(0, 8)
lCorner.Parent = logBtn

-- Bouton Copier
local copyBtn = Instance.new("TextButton")
copyBtn.Size = UDim2.new(1, -40, 0, 40)
copyBtn.Position = UDim2.new(0, 20, 0, 160)
copyBtn.BackgroundColor3 = Color3.fromRGB(120, 220, 150)
copyBtn.Text = "📋 Copier les résultats"
copyBtn.TextColor3 = Color3.new(1, 1, 1)
copyBtn.Font = Enum.Font.GothamBold
copyBtn.TextSize = 14
copyBtn.Parent = win
local cCorner = Instance.new("UICorner")
cCorner.CornerRadius = UDim.new(0, 8)
cCorner.Parent = copyBtn

-- Label de statut
local statusLbl = Instance.new("TextLabel")
statusLbl.Size = UDim2.new(1, -40, 0, 30)
statusLbl.Position = UDim2.new(0, 20, 0, 210)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "Statut : En attente..."
statusLbl.TextColor3 = Color3.fromRGB(80, 50, 100)
statusLbl.Font = Enum.Font.Gotham
statusLbl.TextSize = 12
statusLbl.TextXAlignment = Enum.TextXAlignment.Left
statusLbl.Parent = win

-- ==========================================
-- LOGIQUE DU SCRIPT
-- ==========================================
local remotes = {}
local logs = {}
local loggerActive = false
local hooked = {}

local function getPath(obj)
    local ok, path = pcall(function() return obj:GetFullName() end)
    return ok and path or obj.Name
end

-- Scan
scanBtn.MouseButton1Click:Connect(function()
    statusLbl.Text = "Scan en cours..."
    remotes = {}
    
    local roots = {game:GetService("ReplicatedStorage"), game:GetService("Workspace"), LocalPlayer:FindFirstChild("PlayerScripts")}
    for _, root in ipairs(roots) do
        if root then
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("UnreliableRemoteEvent") then
                    table.insert(remotes, {name = obj.Name, path = getPath(obj), ref = obj, class = obj.ClassName})
                end
            end
        end
    end
    
    statusLbl.Text = "✅ " .. #remotes .. " remotes trouvés !"
end)

-- Logger (Hook)
logBtn.MouseButton1Click:Connect(function()
    loggerActive = not loggerActive
    
    if loggerActive then
        logBtn.Text = "⏹ Désactiver le Logger"
        logBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        statusLbl.Text = "Logger ACTIF - Joue au jeu !"
        
        -- Hook les remotes
        for _, data in ipairs(remotes) do
            local remote = data.ref
            if not hooked[remote] then
                hooked[remote] = true
                
                if remote:IsA("RemoteEvent") then
                    local oldFire = remote.FireServer
                    remote.FireServer = function(self, ...)
                        if loggerActive then
                            local args = {...}
                            local argStr = ""
                            for i, v in ipairs(args) do
                                argStr = argStr .. tostring(v) .. (i < #args and ", " or "")
                            end
                            table.insert(logs, "[SEND] " .. remote.Name .. "(" .. argStr .. ")")
                            statusLbl.Text = "Logs: " .. #logs
                        end
                        return oldFire(self, ...)
                    end
                elseif remote:IsA("RemoteFunction") then
                    local oldInvoke = remote.InvokeServer
                    remote.InvokeServer = function(self, ...)
                        if loggerActive then
                            local args = {...}
                            local argStr = ""
                            for i, v in ipairs(args) do
                                argStr = argStr .. tostring(v) .. (i < #args and ", " or "")
                            end
                            table.insert(logs, "[INVOKE] " .. remote.Name .. "(" .. argStr .. ")")
                            statusLbl.Text = "Logs: " .. #logs
                        end
                        return oldInvoke(self, ...)
                    end
                end
            end
        end
    else
        logBtn.Text = "▶ Activer le Logger"
        logBtn.BackgroundColor3 = Color3.fromRGB(255, 130, 190)
        statusLbl.Text = "Logger arrêté. " .. #logs .. " logs."
    end
end)

-- Copier
copyBtn.MouseButton1Click:Connect(function()
    if type(setclipboard) ~= "function" then
        statusLbl.Text = "❌ setclipboard pas supporté"
        return
    end
    
    local output = "=== ADOPT ME SCANNER ===\n\n-- REMOTES (" .. #remotes .. ") --\n"
    for i, r in ipairs(remotes) do
        output = output .. "[" .. i .. "] (" .. r.class .. ") " .. r.path .. "\n"
    end
    
    output = output .. "\n-- LOGS (" .. #logs .. ") --\n"
    for _, log in ipairs(logs) do
        output = output .. log .. "\n"
    end
    
    setclipboard(output)
    statusLbl.Text = "📋 Copié ! (" .. #remotes .. " remotes, " .. #logs .. " logs)"
end)