-- Logger Halloween + Mini-jeux uniquement
local RS = game:GetService("ReplicatedStorage")

local WATCH = {
    "CandyCornPileClaim", "ClaimTombSpider", "GhostVacuumToyFire",
    "JacobeanPigeonNestContributeTwig", "LightningLeverActivate",
    "LightningLeverDeliver", "StrayCatGiftFood", "UnlockPadlock",
    "UnlockHauntletJournalPage", "AttemptStart", "FinishObby",
    "MessageClient", "MessageServer", "RequestClient", "RequestServer",
    "LobbyJoin", "LobbyCreate", "LobbyStart", "AttemptJoin",
}

local watched = {}
for _, name in ipairs(WATCH) do watched[name] = true end

local function fmt(v)
    local t = typeof(v)
    if t == "Instance" then return v:GetFullName() end
    if t == "Vector3" then return string.format("V3(%.1f,%.1f,%.1f)", v.X, v.Y, v.Z) end
    if t == "CFrame" then
        local p = v.Position
        return string.format("CF(%.1f,%.1f,%.1f)", p.X, p.Y, p.Z)
    end
    if t == "table" then
        local parts = {}
        for k, vv in pairs(v) do
            table.insert(parts, tostring(k).."="..fmt(vv))
        end
        return "{"..table.concat(parts,", ").."}"
    end
    return tostring(v)
end

-- Hook global sur TOUS les remotes
local function hookAll()
    for _, obj in ipairs(RS:GetDescendants()) do
        if (obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction")) and watched[obj.Name] then
            if obj:GetAttribute("__logged") then continue end
            obj:SetAttribute("__logged", true)

            if obj:IsA("RemoteEvent") then
                local old = obj.FireServer
                obj.FireServer = newcclosure(function(self, ...)
                    local args = {...}
                    local s = {}
                    for i, a in ipairs(args) do s[i] = fmt(a) end
                    print(string.format("[SEND] %s(%s)", obj.Name, table.concat(s, ", ")))
                    return old(self, ...)
                end)
                obj.OnClientEvent:Connect(function(...)
                    local args = {...}
                    local s = {}
                    for i, a in ipairs(args) do s[i] = fmt(a) end
                    print(string.format("[RECV] %s(%s)", obj.Name, table.concat(s, ", ")))
                end)
            elseif obj:IsA("RemoteFunction") then
                local old = obj.InvokeServer
                obj.InvokeServer = newcclosure(function(self, ...)
                    local args = {...}
                    local s = {}
                    for i, a in ipairs(args) do s[i] = fmt(a) end
                    print(string.format("[INVOKE] %s(%s)", obj.Name, table.concat(s, ", ")))
                    return old(self, ...)
                end)
            end
        end
    end
end

hookAll()
-- Re-scan toutes les 5s au cas où de nouveaux remotes apparaissent
task.spawn(function()
    while true do
        task.wait(5)
        hookAll()
    end
end)

print("=====================================================")
print("🎃 LOGGER HALLOWEEN ACTIF")
print("Fais TOUTES ces actions dans le jeu :")
print("  1. Va au Hauntlet (event Halloween)")
print("  2. Ramasse du candy corn")
print("  3. Ouvre un tomb spider")
print("  4. Utilise le ghost vacuum")
print("  5. Donne une branche au pigeon Jacobean")
print("  6. Active le levier lightning")
print("  7. Livre la lightning")
print("  8. Donne à manger au stray cat")
print("  9. Déverrouille un padlock")
print(" 10. Débloque une page du journal Hauntlet")
print(" 11. Lance un mini-jeu")
print()
print("🎯 Puis COPIE TOUT ce que la console affiche")
print("=====================================================")