-- ============================================
-- DamageBrick by RoB-Kit
-- ============================================
-- WHAT IT DOES:
--   Continuously damages any player who stands
--   on or touches this brick, like lava or spikes.
--
-- HOW TO USE:
--   1. Insert a Script (not LocalScript) inside your brick
--   2. Paste this code into that Script
--   3. Change DAMAGE and INTERVAL below to your liking
-- ============================================

-- How much health to take away each tick
-- Example: 10 means the player loses 10 HP every second
local DAMAGE = 10

-- How many seconds to wait between each damage hit
-- Example: 1 means damage happens once per second
-- Use 0.5 for faster damage, 2 for slower damage
local INTERVAL = 1

-- This gets the brick this script is sitting inside
local brick = script.Parent

-- A "debounce" table keeps track of who is currently touching the brick
-- This prevents the same player from being damaged multiple times at once
local debounce = {}

-- This fires every time something touches the brick
brick.Touched:Connect(function(hit)

    -- "hit" is the body part that touched the brick (like a foot or leg)
    -- hit.Parent is the full character model of the player
    local character = hit.Parent

    -- Check if the character has a Humanoid (only players and NPCs have one)
    -- This stops random parts like hats or tools from triggering damage
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")

    -- Only run if there's a humanoid AND this player isn't already being damaged
    if humanoid and not debounce[character.Name] then

        -- Mark this player as "currently being damaged" so we don't double-damage
        debounce[character.Name] = true

        -- Keep damaging in a loop as long as they're still touching the brick
        while debounce[character.Name] do
            humanoid:TakeDamage(DAMAGE)  -- Take away HP
            task.wait(INTERVAL)           -- Wait before hitting again
        end
    end
end)

-- This fires when something STOPS touching the brick
brick.TouchEnded:Connect(function(hit)
    local character = hit.Parent

    -- Remove this player from the debounce table so damage stops
    debounce[character.Name] = nil
end)
