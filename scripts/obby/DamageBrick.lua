-- DamageBrick by RoB-Kit
-- Place this script inside a Script (not LocalScript) under your brick
-- Change DAMAGE and INTERVAL to your liking

local DAMAGE = 10        -- How much damage per hit
local INTERVAL = 1       -- Seconds between each damage tick

local brick = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
    local character = hit.Parent
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")

    if humanoid and not debounce[character.Name] then
        debounce[character.Name] = true
        
        while brick.TouchEnded and debounce[character.Name] do
            humanoid:TakeDamage(DAMAGE)
            task.wait(INTERVAL)
        end
    end
end)

brick.TouchEnded:Connect(function(hit)
    local character = hit.Parent
    debounce[character.Name] = nil
end)
