-- ============================================
-- SpinningKillBrick | RoB-Kit
-- ============================================
-- A brick that rotates continuously and kills any player it hits.
-- Classic obby hazard. Drop it into any spinning obstacle.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   ROTATION_SPEED = how fast it spins (degrees per second)
--   AXIS           = which axis to spin on (X, Y, or Z)
-- ============================================

local ROTATION_SPEED = 90   -- degrees per second (default: 90 = one full spin every 4 seconds)
local AXIS           = "Y"  -- "X", "Y", or "Z"

local brick        = script.Parent
local debounce     = {}
local RunService   = game:GetService("RunService")

-- lock the brick in place so physics don't move it around
brick.Anchored = true

-- spin the brick every frame
RunService.Heartbeat:Connect(function(dt)
	local angle = math.rad(ROTATION_SPEED * dt)
	if AXIS == "X" then
		brick.CFrame = brick.CFrame * CFrame.Angles(angle, 0, 0)
	elseif AXIS == "Y" then
		brick.CFrame = brick.CFrame * CFrame.Angles(0, angle, 0)
	elseif AXIS == "Z" then
		brick.CFrame = brick.CFrame * CFrame.Angles(0, 0, angle)
	end
end)

-- kill on touch
brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true
		humanoid.Health = 0
		task.wait(1)
		debounce[character.Name] = nil
	end
end)
