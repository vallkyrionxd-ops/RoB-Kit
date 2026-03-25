-- ============================================
-- InvisibilityBrick | RoB-Kit
-- ============================================
-- Makes the player invisible for a few seconds when they touch this brick.
-- Their character still exists and can take damage, they just can't be seen.
-- Good for stealth power-ups or hiding zones.
--
-- WHERE TO PUT IT:
--   Insert a Script (not LocalScript) directly inside your brick.
--
-- WHAT TO CHANGE:
--   INVISIBLE_TIME = how long the player stays invisible (seconds)
-- ============================================

local Players        = game:GetService("Players")
local INVISIBLE_TIME = 8    -- seconds of invisibility

local brick    = script.Parent
local debounce = {}

local function setTransparency(character, value)
	for _, part in ipairs(character:GetDescendants()) do
		-- skip the HumanoidRootPart (invisible but still used for position)
		if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
			part.Transparency = value
		end
	end
end

brick.Touched:Connect(function(hit)
	local character = hit.Parent
	local humanoid  = character:FindFirstChildWhichIsA("Humanoid")
	local player    = Players:GetPlayerFromCharacter(character)

	if not player or not humanoid or debounce[character.Name] then return end
	debounce[character.Name] = true

	-- make fully invisible
	setTransparency(character, 1)

	task.wait(INVISIBLE_TIME)

	-- restore visibility
	setTransparency(character, 0)

	task.wait(1)
	debounce[character.Name] = nil
end)
