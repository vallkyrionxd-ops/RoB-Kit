-- ============================================
-- KillBrick by RoB-Kit
-- ============================================
-- WHAT IT DOES:
--   Instantly kills any player who touches this brick.
--   Perfect for death floors, void tiles, or traps.
--
-- HOW TO USE:
--   1. Insert a Script (not LocalScript) inside your brick
--   2. Paste this code into that Script
--   No settings to change — it just works!
-- ============================================

-- This gets the brick that this script is sitting inside
local brick = script.Parent

-- A debounce table prevents the script from firing
-- multiple times at once for the same player
local debounce = {}

-- This fires every time something touches the brick
brick.Touched:Connect(function(hit)

    -- Get the full character model from the body part that touched
    local character = hit.Parent

    -- Check if the character has a Humanoid (only players/NPCs do)
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")

    -- Only kill if there's a humanoid AND we haven't already killed them
    -- (without debounce, this could fire 10+ times in one millisecond)
    if humanoid and not debounce[character.Name] then

        -- Lock this player so the kill only triggers once
        debounce[character.Name] = true

        -- Setting health to 0 instantly kills the player
        humanoid.Health = 0

        -- Wait 1 second before allowing this brick to kill again
        -- This gives the player time to respawn cleanly
        task.wait(1)

        -- Unlock so the brick can kill again (e.g. if they come back)
        debounce[character.Name] = nil
    end
end)
```
