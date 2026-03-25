-- ============================================
-- TeleportBrick | RoB-Kit
-- ============================================
-- Teleports the player to another brick when touched.
-- Good for portals, stage skips, or secret rooms.
--
-- WHERE TO PUT IT:
--   Insert a Script inside the brick players will STEP ON.
--
-- WHAT TO CHANGE:
--   DESTINATION_NAME = the exact Name of the brick to teleport TO
--   HEIGHT_OFFSET    = how high above the destination to place the player
--
-- SETUP STEPS:
--   1. Place two bricks in your game
--   2. Name the destination brick (e.g. "Stage5Start")
--   3. Set DESTINATION_NAME below to match that name exactly
--   4. Capitals matter! "stage5start" won't find "Stage5Start"
-- ============================================

local DESTINATION_NAME = "TeleportDestination"  -- change this to your destination brick's name
local HEIGHT_OFFSET    = 5                       -- studs above the destination brick to land

local brick       = script.Parent
local debounce    = {}
local destination = game.Workspace:FindFirstChild(DESTINATION_NAME)

-- warn in the output window if the destination brick is missing
if not destination then
	warn("[TeleportBrick] Could not find a brick named '" .. DESTINATION_NAME .. "' in Workspace.")
	warn("[TeleportBrick] Check the name spelling. Capitals matter.")
end

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")
	local rootPart  = character:FindFirstChild("HumanoidRootPart")

	if humanoid and rootPart and destination and not debounce[character.Name] then
		debounce[character.Name] = true

		-- move the player above the destination brick
		rootPart.CFrame = CFrame.new(destination.Position + Vector3.new(0, HEIGHT_OFFSET, 0))

		task.wait(1)
		debounce[character.Name] = nil
	end
end)
