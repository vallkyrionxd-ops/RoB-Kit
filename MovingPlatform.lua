-- ============================================
-- KillBrick | RoB-Kit
-- ============================================
-- Instantly kills any player who touches this brick.
-- Good for death floors, void zones, or instant-fail traps.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   Nothing required. Works right out of the box.
--   COOLDOWN = seconds before the brick can kill again (prevents double-kill on respawn)
-- ============================================

local COOLDOWN = 1    -- seconds before the brick can kill the same player again

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true

		-- setting health to 0 kills the player immediately
		humanoid.Health = 0

		task.wait(COOLDOWN)
		debounce[character.Name] = nil
	end
end)
