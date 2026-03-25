-- ============================================
-- SlowBrick | RoB-Kit
-- ============================================
-- Slows the player down while they are standing on this brick.
-- Speed returns to normal when they step off.
-- Good for mud, ice (with slow instead of slide), or tar pits.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   SLOW_SPEED   = walk speed while on the brick (default Roblox = 16)
--   NORMAL_SPEED = speed restored when leaving
-- ============================================

local SLOW_SPEED   = 5     -- very slow
local NORMAL_SPEED = 16    -- default Roblox walk speed

local brick    = script.Parent
local debounce = {}

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and not debounce[character.Name] then
		debounce[character.Name] = true
		humanoid.WalkSpeed = SLOW_SPEED
	end
end)

brick.TouchEnded:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")

	if humanoid and debounce[character.Name] then
		debounce[character.Name] = nil
		humanoid.WalkSpeed = NORMAL_SPEED
	end
end)
