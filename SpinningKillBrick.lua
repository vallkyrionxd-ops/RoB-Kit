-- ============================================
-- BouncePad | RoB-Kit
-- ============================================
-- Launches the player upward when they touch this brick.
-- Good for jump pads, springs, or launching platforms.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   LAUNCH_POWER = how hard to fling the player upward (default: 80)
--   Play around with this. 50 is a small hop, 150 is very high.
-- ============================================

local LAUNCH_POWER = 80   -- upward force applied to the player

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")
	local rootPart  = character:FindFirstChild("HumanoidRootPart")

	if humanoid and rootPart and not debounce[character.Name] then
		debounce[character.Name] = true

		-- apply upward velocity to launch the player
		local bodyVelocity    = Instance.new("BodyVelocity")
		bodyVelocity.Velocity = Vector3.new(0, LAUNCH_POWER, 0)
		bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		bodyVelocity.Parent   = rootPart

		-- remove the force after a short moment so gravity takes over
		task.wait(0.1)
		bodyVelocity:Destroy()

		task.wait(0.5)
		debounce[character.Name] = nil
	end
end)
