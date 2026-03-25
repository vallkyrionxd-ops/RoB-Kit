-- ============================================
-- TeleportBrick by RoB-Kit
-- ============================================
-- WHAT IT DOES:
--   Teleports a player to another brick in your game
--   when they touch this one. Great for stage skips,
--   secret rooms, portals, or obby checkpoints.
--
-- HOW TO USE:
--   1. Create two bricks in your game
--   2. Name the DESTINATION brick anything you want
--      (example: "Stage2Start" or "Portal_Exit")
--   3. Insert a Script inside the FIRST brick (the one players touch)
--   4. Paste this code into that Script
--   5. Change DESTINATION_NAME below to match your destination brick's name
-- ============================================

-- Change this to the exact Name of the brick you want to teleport TO
-- It must match the brick name in Workspace exactly (capital letters matter!)
local DESTINATION_NAME = "TeleportDestination"

-- How high above the destination brick to place the player
-- 5 means 5 studs above the brick so they don't spawn inside it
local HEIGHT_OFFSET = 5

-- A debounce table to prevent teleporting the same player multiple times
local debounce = {}

-- Get the brick this script is sitting inside
local brick = script.Parent

-- Search the entire Workspace for the destination brick by name
local destination = game.Workspace:FindFirstChild(DESTINATION_NAME)

-- If the destination brick doesn't exist, print a warning in the output
-- This helps you debug if you spelled the name wrong
if not destination then
    warn("TeleportBrick: Could not find a brick named '" .. DESTINATION_NAME .. "' in Workspace!")
    warn("Make sure the destination brick exists and the name matches exactly.")
end

-- This fires every time something touches the teleport brick
brick.Touched:Connect(function(hit)

    -- Get the full character from the body part that touched
    local character = hit.Parent

    -- Check if the character has a Humanoid (only players/NPCs do)
    local humanoid = character:FindFirstChildWhichIsA("Humanoid")

    -- Get the player's HumanoidRootPart — this is the part we actually move
    -- Moving the HumanoidRootPart moves the entire character
    local rootPart = character:FindFirstChild("HumanoidRootPart")

    -- Only teleport if:
    -- 1. There's a humanoid (it's a player or NPC)
    -- 2. We found the root part
    -- 3. The destination brick exists
    -- 4. This player isn't already being teleported (debounce)
    if humanoid and rootPart and destination and not debounce[character.Name] then

        -- Lock this player to prevent double-teleporting
        debounce[character.Name] = true

        -- Move the player to the destination brick's position
        -- We add HEIGHT_OFFSET so they appear above the brick, not inside it
        rootPart.CFrame = CFrame.new(
            destination.Position + Vector3.new(0, HEIGHT_OFFSET, 0)
        )

        -- Wait 1 second before allowing this player to be teleported again
        task.wait(1)

        -- Unlock the debounce
        debounce[character.Name] = nil
    end
end)
```
