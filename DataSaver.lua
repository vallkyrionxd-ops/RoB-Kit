-- ============================================
-- DisappearingPlatform | RoB-Kit
-- ============================================
-- A platform that disappears shortly after being stepped on,
-- then reappears after a cooldown. Players have to move fast.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   DELAY_BEFORE_VANISH = seconds after touch before it disappears
--   INVISIBLE_TIME      = seconds it stays invisible/non-collidable
-- ============================================

local DELAY_BEFORE_VANISH = 0.8   -- seconds after touch to start disappearing
local INVISIBLE_TIME      = 2     -- seconds the platform stays gone

local brick    = script.Parent
local isFading = false

brick.Touched:Connect(function(hit)
	-- only react to players, not random parts
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not isFading then
		isFading = true

		-- wait a moment so the player has a chance to jump off
		task.wait(DELAY_BEFORE_VANISH)

		-- make it invisible and non-collidable so players fall through
		brick.Transparency = 1
		brick.CanCollide   = false

		-- wait before bringing it back
		task.wait(INVISIBLE_TIME)

		-- restore it
		brick.Transparency = 0
		brick.CanCollide   = true

		isFading = false
	end
end)
