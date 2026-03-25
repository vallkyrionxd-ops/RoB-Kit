-- ============================================
-- JumpBoostBrick | RoB-Kit
-- ============================================
-- Gives the player a temporary jump boost when touched.
-- Great for jump pads that don't launch you, or spring tiles.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   BOOST_POWER    = jump height during boost (default Roblox = 7.2)
--   BOOST_DURATION = how long the boost lasts (seconds)
--   NORMAL_POWER   = jump height to restore after the boost
-- ============================================

local BOOST_POWER    = 30     -- jump height during boost
local BOOST_DURATION = 6      -- seconds the boost lasts
local NORMAL_POWER   = 7.2    -- default Roblox jump height

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true

		humanoid.JumpHeight = BOOST_POWER

		task.wait(BOOST_DURATION)
		humanoid.JumpHeight = NORMAL_POWER

		task.wait(1)
		debounce[character.Name] = nil
	end
end)
