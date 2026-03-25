-- ============================================
-- SpeedBoostBrick | RoB-Kit
-- ============================================
-- Gives the player a temporary speed boost when touched.
-- Good for speed pads, power-ups, or reward bricks.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   BOOST_SPEED    = walking speed during the boost (default Roblox speed is 16)
--   BOOST_DURATION = how many seconds the boost lasts
--   NORMAL_SPEED   = what speed to restore after the boost
-- ============================================

local BOOST_SPEED    = 40   -- speed during boost
local BOOST_DURATION = 5    -- seconds the boost lasts
local NORMAL_SPEED   = 16   -- default Roblox walk speed

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true

		-- apply the speed boost
		humanoid.WalkSpeed = BOOST_SPEED

		-- wait for the duration, then remove it
		task.wait(BOOST_DURATION)
		humanoid.WalkSpeed = NORMAL_SPEED

		-- short cooldown before the brick can boost this player again
		task.wait(1)
		debounce[character.Name] = nil
	end
end)
